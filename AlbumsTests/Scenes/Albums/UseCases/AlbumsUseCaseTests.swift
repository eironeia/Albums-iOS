import XCTest
import RxSwift
import RxTest

@testable import Albums

final class AlbumsUseCaseTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockAlbumsProvider: MockAlbumsProvider!
    var mockLocalAlbumsProvider: MockLocalAlbumsProvider!
    var resultsObserver: TestableObserver<[Album]>!
    var sut: AlbumsUseCase!

    override func setUp() {
        super.setUp()
        mockAlbumsProvider = MockAlbumsProvider()
        mockLocalAlbumsProvider = MockLocalAlbumsProvider()
        scheduler = TestScheduler(initialClock: 10)
        resultsObserver = scheduler.createObserver([Album].self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        sut = nil
        super.tearDown()
    }

    func test_getAlbumsUseCase_withoutStoredData() {
        let mockAlbum = Album(
            userId: 1,
            id: 1,
            title: "Title"
        )

        mockAlbumsProvider.getAlbumsResponse = [mockAlbum]

        sut = makeSUT()

        subscribeEvents()
        XCTAssertEqual(
            resultsObserver.events,
            [
                .next(10, [mockAlbum]),
                .completed(10)
            ]
        )
    }

    func test_getAlbumsUseCase_withStoredData() {
        let mockLocalAlbum = Album(
            userId: 1,
            id: 1,
            title: "Title"
        )

        mockLocalAlbumsProvider.getAlbumsResponse = [mockLocalAlbum]

        sut = makeSUT()
        subscribeEvents()

        XCTAssertEqual(
            resultsObserver.events,
            [
                .next(10, [mockLocalAlbum]),
                .completed(10)
            ]
        )
    }
}

private extension AlbumsUseCaseTests {
    func makeSUT() -> AlbumsUseCase {
        AlbumsUseCase(
            albumsProvider: mockAlbumsProvider,
            localAlbumsProvider: mockLocalAlbumsProvider
        )
    }

    func subscribeEvents() {
        sut
            .getAlbums(page: 0)
            .asObservable()
            .subscribe(resultsObserver)
            .disposed(by: disposeBag)
    }
}
