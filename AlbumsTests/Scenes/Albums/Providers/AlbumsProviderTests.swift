import XCTest
import RxSwift
import RxTest

@testable import Albums

struct MockNetworkProvider: NetworkProviderInterface {
    func request(endpoint: Endpoint) {

    }
}

final class AlbumsProviderTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var sut: AlbumsProvider!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = makeSUT()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_getAlbumProvider() {
        let expectation = self.expectation(description: "Get album called")
        sut
            .getAlbums()
            .verifySuccessfulRequest(expectation: expectation)
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 1)
    }
}

private extension AlbumsProviderTests {
    func makeSUT() -> AlbumsProvider {
        let networkProvider = MockNetworkProvider()
        return AlbumsProvider(networkProvider: networkProvider)
    }
}
