import Foundation
import RxSwift

protocol AlbumsUseCaseInterface {
    func getAlbums(page: UInt) -> Single<[Album]>
}

struct AlbumsUseCase {
    let albumsProvider: AlbumsProviderInterface
//    let localAlbumsProvider: AlbumsProviderInterface

    func getAlbums(page: UInt) -> Single<[Album]> {
        albumsProvider.getAlbums(page: page)
    }
}
