import XCTest
import RxSwift
import RxTest

@testable import Albums

final class PhotosUseCaseTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockPhotosProvider: MockPhotosProvider!
    var mockLocalPhotosProvider: MockLocalPhotosProvider!
    var resultsObserver: TestableObserver<[Photo]>!
    var sut: PhotosUseCase!

    override func setUp() {
        super.setUp()
        mockPhotosProvider = MockPhotosProvider()
        mockLocalPhotosProvider = MockLocalPhotosProvider()
        scheduler = TestScheduler(initialClock: 10)
        resultsObserver = scheduler.createObserver([Photo].self)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        sut = nil
        super.tearDown()
    }

    func test_getPhotosUseCase_withoutStoredData() {
        let mockPhoto = Photo(
            albumId: 1,
            id: 1,
            title: "Title",
            url: "https://via.placeholder.com/600/54176f",
            thumbnailUrl: "https://via.placeholder.com/150/54176f"
        )
        mockPhotosProvider.getPhotosResponse = [mockPhoto]

        sut = makeSUT()

        subscribeEvents()
        XCTAssertEqual(
            resultsObserver.events,
            [
                .next(10, [mockPhoto]),
                .completed(10)
            ]
        )
    }

    func test_getPhotosUseCase_withStoredData() {
        let mockLocalPhoto = Photo(
            albumId: 1,
            id: 1,
            title: "Title",
            url: "https://via.placeholder.com/600/54176f",
            thumbnailUrl: "https://via.placeholder.com/150/54176f"
        )
        let pageDB = PhotoPageDB(page: 1, photos: [mockLocalPhoto])
        mockLocalPhotosProvider.getPhotosPageResponse = pageDB

        sut = makeSUT()
        subscribeEvents()

        XCTAssertEqual(
            resultsObserver.events,
            [
                .next(10, [mockLocalPhoto]),
                .completed(10)
            ]
        )
    }
}

private extension PhotosUseCaseTests {
    func makeSUT() -> PhotosUseCase {
        PhotosUseCase(
            photosProvider: mockPhotosProvider,
            localPhotosProvider: mockLocalPhotosProvider
        )
    }

    func subscribeEvents() {
        sut
            .getPhotos(page: 1, albumId: 1)
            .asObservable()
            .subscribe(resultsObserver)
            .disposed(by: disposeBag)
    }
}
