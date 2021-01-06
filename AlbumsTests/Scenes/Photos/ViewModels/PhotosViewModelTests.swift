import RxSwift
import RxTest
import XCTest

@testable import Albums

final class PhotosViewModelTests: XCTestCase {
    var photoUseCase: MockPhotosUseCase!
    var expectedPhotoUIModel: PhotoUIModel!
    var mockPhoto: Photo!
    var onNavigate: ((PhotosViewModel.Navigation) -> Void)!
    var eventSubject: PublishSubject<PhotosViewModel.Event>!
    var stateObserver: TestableObserver<PhotosViewModel.State>!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: PhotosViewModel!


    override func setUp() {
        super.setUp()
        photoUseCase = MockPhotosUseCase()
        mockPhoto = Photo(
            albumId: 1,
            id: 1,
            title: "Title",
            url: "https://via.placeholder.com/600/54176f",
            thumbnailUrl: "https://via.placeholder.com/150/54176f"
        )
        photoUseCase.getPhotosResponse = [mockPhoto]
        expectedPhotoUIModel = PhotoUIModel(photo: mockPhoto)
        onNavigate = { _ in }
        scheduler = TestScheduler(initialClock: 0)
        eventSubject = .init()
        stateObserver = scheduler.createObserver(PhotosViewModel.State.self)
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
                .next(10, .photos([expectedPhotoUIModel]))
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
                .next(10, .photos([expectedPhotoUIModel]))
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
                .next(10, .nextPhotosPage([expectedPhotoUIModel]))
            ]
        )
    }

    func test_whenLoadMoreEvent_andNoMorePages_thenHandleStates() {
        photoUseCase.getPhotosResponse = []
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

    func test_whenPhotoSelectedEvent_thenHandleStates() {
        let expectation = self.expectation(description: "Navigate to photo details")
        onNavigate = { navigation in
            XCTAssertEqual(
                navigation,
                PhotosViewModel.Navigation.photoDetails(photo: self.mockPhoto)
            )
            expectation.fulfill()
        }
        sut = makeSUT()
        subscribeScheduler(with: [
                            .next(10, .start),
                            .next(20, .photoSelected(photoId: 1))
        ])
        subscribeEvents()

        XCTAssertEqual(
            stateObserver.events,
            [
                .next(10, .isLoading(true)),
                .next(10, .isLoading(false)),
                .next(10, .photos([expectedPhotoUIModel])),
                .next(20, .idle)
            ]
        )
        waitForExpectations(timeout: 1)
    }
}

private extension PhotosViewModelTests {
    func makeSUT() -> PhotosViewModel {
        PhotosViewModel(albumId: 1, photosUseCase: photoUseCase, onNavigate: onNavigate)
    }

    func subscribeScheduler(with events: [Recorded<Event<PhotosViewModel.Event>>]) {
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
