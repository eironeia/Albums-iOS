import XCTest
import RxSwift
import RxTest
import Moya

@testable import Albums

final class PhotosProviderTests: XCTestCase {
    var disposeBag: DisposeBag!
    var sut: PhotosProvider!

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

    func test_getPhotosProvider() {
        let expectation = self.expectation(description: "Get photos called")
        sut
            .getPhotos(page: 1, albumId: 1)
            .verifySuccessfulRequest(expectation: expectation)
            .disposed(by: disposeBag)
        waitForExpectations(timeout: 1)
    }
}

private extension PhotosProviderTests {
    func makeSUT() -> PhotosProvider {
        return PhotosProvider(
            provider: .init(stubClosure: MoyaProvider<EndpointsAPI>.immediatelyStub)
        )
    }
}
