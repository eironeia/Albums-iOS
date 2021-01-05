import RxSwift

@testable import Albums

final class MockPhotosProvider: PhotosProviderInterface {
    var getPhotosResponse: [Photo]!
    var getPhotosTimesCalled: UInt = 0
    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]> {
        getPhotosTimesCalled += 1
        return .just(getPhotosResponse)
    }
}
