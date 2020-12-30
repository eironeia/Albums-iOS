import XCTest
import RxSwift
import RxTest
import Moya

@testable import Albums

final class AlbumsProviderTests: XCTestCase {
    var disposeBag: DisposeBag!
    var sut: AlbumsProvider!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        sut = makeSUT()
    }

    override func tearDown() {
        disposeBag = nil
        sut = nil
        super.tearDown()
    }

    func test_getAlbumsProvider() {
        let expectation = self.expectation(description: "Get albums called")
        sut
            .getAlbums(page: 1)
            .verifySuccessfulRequest(expectation: expectation)
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 1)
    }
}

private extension AlbumsProviderTests {
    func makeSUT() -> AlbumsProvider {
        return AlbumsProvider(
            provider: .init(stubClosure: MoyaProvider<EndpointsAPI>.immediatelyStub)
        )
    }
}
