import Foundation
import RxSwift
import Moya

protocol PhotosProviderInterface {
    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]>
}

struct PhotosProvider: PhotosProviderInterface {
    let provider: MoyaProvider<EndpointsAPI>

    init(provider: MoyaProvider<EndpointsAPI> = .init()) {
        self.provider = provider
    }

    func getPhotos(page: UInt, albumId: Int) -> Single<[Photo]> {
        provider
            .rx
            .request(.getPhotos(page: page, albumId: albumId))
            .debug()
            .filterSuccessfulStatusCodes()
            .map([Photo].self)
    }
}
