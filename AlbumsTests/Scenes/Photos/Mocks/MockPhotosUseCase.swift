import RxSwift
@testable import Albums

struct MockPhotosUseCase: PhotosUseCaseInterface {
    var getPhotosResponse: [Photo]!
    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]> {
        .just(getPhotosResponse)
    }
}
