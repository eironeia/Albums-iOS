import Foundation
import RxSwift

protocol PhotosUseCaseInterface {
    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]>
}

struct PhotosUseCase: PhotosUseCaseInterface {
    let photosProvider: PhotosProviderInterface
    let localPhotosProvider: PhotosPageDatabaseInterface

    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]> {
        if let photosPageDB = localPhotosProvider.getPhotosPage(page: page, albumId: albumId) {
            let localPhotos = photosPageDB.photos.map(Photo.init(photoDB:))
            return .just(localPhotos)
        } else {
            return photosProvider
                .getPhotos(page: page, albumId: albumId)
                .do(onSuccess: { photos in
                    let photosPageDB = PhotoPageDB(page: page, photos: photos)
                    localPhotosProvider.savePhotosPage(photosPageDB, albumId: albumId)
                })
        }
    }
}
