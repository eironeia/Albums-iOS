import Foundation
import RxSwift

protocol AlbumsUseCaseInterface {
    func getAlbums(page: UInt) -> Single<[Album]>
}

struct AlbumsUseCase: AlbumsUseCaseInterface {
    let albumsProvider: AlbumsProviderInterface
    let localAlbumsProvider: LocalAlbumsProviderInterface

    func getAlbums(page: UInt) -> Single<[Album]> {
        if let localAlbums = localAlbumsProvider.getAlbums(page: page) {
            return .just(localAlbums)
        } else {
            return albumsProvider.getAlbums(page: page)
        }
    }
}
