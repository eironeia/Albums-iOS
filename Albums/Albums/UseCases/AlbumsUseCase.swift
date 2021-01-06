import Foundation
import RxSwift

protocol AlbumsUseCaseInterface {
    func getAlbums(page: UInt) -> Single<[Album]>
}

struct AlbumsUseCase: AlbumsUseCaseInterface {
    let albumsProvider: AlbumsProviderInterface
    let localAlbumsProvider: AlbumsPageDatabaseInterface

    func getAlbums(page: UInt) -> Single<[Album]> {
        if let albumsPageDB  = localAlbumsProvider.getAlbumsPage(page: page) {
            let localAlbums = albumsPageDB.albums.map(Album.init(albumDB:))
            return .just(localAlbums)
        } else {
            return albumsProvider
                .getAlbums(page: page)
                .do(onSuccess: { albums in
                    let albumPageDB = AlbumPageDB(page: page, albums: albums)
                    localAlbumsProvider.saveAlbumsPage(albumPageDB)
                })
        }
    }
}
