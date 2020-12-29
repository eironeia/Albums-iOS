import RxSwift

@testable import Albums

struct MockAlbumsProvider: AlbumsProviderInterface {
    func getAlbums(page: UInt) -> Single<[Album]> {
        return .just([])
    }
}
