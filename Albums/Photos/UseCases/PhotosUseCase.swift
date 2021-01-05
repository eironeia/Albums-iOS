import Foundation
import RxSwift

protocol PhotosUseCaseInterface {
    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]>
}

struct PhotosUseCase: PhotosUseCaseInterface {
    let photosProvider: PhotosProviderInterface
    let localPhotosProvider: LocalPhotosProviderInterface

    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]> {
        if let localPhotos = localPhotosProvider.getPhotos(page: page, albumId: albumId) {
            return .just(localPhotos)
        } else {
            return photosProvider.getPhotos(page: page, albumId: albumId)
        }
    }
}
