import RxSwift
import RxTest
import XCTest

@testable import Albums

final class AlbumsViewModelTests: XCTestCase {
    var albumUseCase: MockAlbumsUseCase!
    var expectedAlbumUIModel: AlbumUIModel!
    var eventSubject: PublishSubject<AlbumsViewModel.Event>!
    var stateObserver: TestableObserver<AlbumsViewModel.State>!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: AlbumsViewModel!
    var onNavigate: ((AlbumsViewModel.Navigation) -> Void)!

    override func setUp() {
        super.setUp()
        albumUseCase = MockAlbumsUseCase()
        let album = Album(
            userId: 1,
            id: 1,
            title: "Title"
        )
        albumUseCase.getAlbumsResponse = [album]
        expectedAlbumUIModel = AlbumUIModel(album: album)
        onNavigate = { _ in }
        scheduler = TestScheduler(initialClock: 0)
        eventSubject = .init()
        stateObserver = scheduler.createObserver(AlbumsViewModel.State.self)
        disposeBag = DisposeBag()
        sut = makeSUT()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        sut = nil
        super.tearDown()
    }

    func test_whenStartEvent_thenHandleStates() {
        subscribeScheduler(with: [.next(10, .start)])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .isLoading(true)),
                .next(10, .isLoading(false)),
                .next(10, .albums([expectedAlbumUIModel]))
            ]
        )
    }

    func test_whenRefreshEvent_thenHandleStates() {
        subscribeScheduler(with: [.next(10, .refresh)])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .isLoading(true)),
                .next(10, .isLoading(false)),
                .next(10, .albums([expectedAlbumUIModel]))
            ]
        )
    }

    func test_whenLoadMoreEvent_thenHandleStates() {
        subscribeScheduler(with: [.next(10, .loadMore(page: 2))])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .isLoading(true)),
                .next(10, .isLoading(false)),
                .next(10, .nextAlbumsPage([expectedAlbumUIModel]))
            ]
        )
    }

    func test_whenLoadMoreEvent_andNoMorePages_thenHandleStates() {
        albumUseCase.getAlbumsResponse = []
        sut = makeSUT()
        subscribeScheduler(with: [.next(10, .loadMore(page: 2))])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .isLoading(true)),
                .next(10, .isLoading(false)),
                .next(10, .noMorePages)
            ]
        )
    }

    func test_whenSelectedAlbumEvent_andNoMorePages_thenHandleStates() {
        let expectation = self.expectation(description: "Navigate to photos")
        onNavigate = { navigation in
            XCTAssertEqual(navigation, AlbumsViewModel.Navigation.photos(albumId: 1))
            expectation.fulfill()
        }
        sut = makeSUT()
        subscribeScheduler(with: [.next(10, .selectedAlbum(albumId: 1))])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .idle)
            ]
        )
        waitForExpectations(timeout: 1)
    }
}

private extension AlbumsViewModelTests {
    func makeSUT() -> AlbumsViewModel {
        AlbumsViewModel(
            albumsUseCase: albumUseCase,
            onNavigate: onNavigate
        )
    }

    func subscribeScheduler(with events: [Recorded<Event<AlbumsViewModel.Event>>]) {
        scheduler
            .createColdObservable(events)
            .bind(to: eventSubject)
            .disposed(by: disposeBag)
    }

    func subscribeEvents() {
        sut
            .transform(event: eventSubject)
            .asDriverOnErrorJustComplete()
            .drive(stateObserver)
            .disposed(by: disposeBag)

        scheduler.start()
    }
}
