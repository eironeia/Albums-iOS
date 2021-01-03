import RxSwift
import RxTest
import XCTest

@testable import Albums

final class AlbumsViewModelTests: XCTestCase {
    var eventSubject: PublishSubject<AlbumsViewModel.Event>!
    var stateObserver: TestableObserver<AlbumsViewModel.State>!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: AlbumsViewModel!

    override func setUp() {
        super.setUp()
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
                .next(10, .albums([]))
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
                .next(10, .albums([]))
            ]
        )
    }
}

private extension AlbumsViewModelTests {
    func makeSUT() -> AlbumsViewModel {
        return AlbumsViewModel(albumsUseCase: MockAlbumsUseCase())
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
