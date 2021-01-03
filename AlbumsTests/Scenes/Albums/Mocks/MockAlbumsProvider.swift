import RxSwift

@testable import Albums

final class MockAlbumsProvider: AlbumsProviderInterface {
    var getAlbumsResponse: [Album]!
    var getAlbumsTimesCalled: UInt = 0
    func getAlbums(page: UInt) -> Single<[Album]> {
        getAlbumsTimesCalled += 1
        return .just(getAlbumsResponse)
    }
}
