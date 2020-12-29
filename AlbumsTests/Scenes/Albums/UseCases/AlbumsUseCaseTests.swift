import XCTest
import RxSwift
import RxTest

@testable import Albums

final class AlbumsUseCaseTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: AlbumsUseCase!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = makeSUT()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        sut = nil
        super.tearDown()
    }

    func test_getAlbumsUseCase() {
        let expectation = self.expectation(description: "Get albums called")
        sut
            .getAlbums(page: 0)
            .verifySuccessfulRequest(expectation: expectation)
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 1)
    }
}

private extension AlbumsUseCaseTests {
    func makeSUT() -> AlbumsUseCase {
        return AlbumsUseCase(albumsProvider: MockAlbumsProvider())
    }
}
