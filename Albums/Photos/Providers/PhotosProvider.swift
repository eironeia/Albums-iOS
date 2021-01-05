import Foundation
import RxSwift
import Moya

protocol PhotosProviderInterface {
    func getPhotos(page: UInt, albumId: Int) -> Single<[Album]>
}

struct PhotosProvider: PhotosProviderInterface {
    let provider: MoyaProvider<EndpointsAPI>

    init(provider: MoyaProvider<EndpointsAPI> = .init()) {
        self.provider = provider
    }

    func getAlbums(page: UInt) -> Single<[Album]> {
        provider
            .rx
            .request(.getAlbums(page: page))
            .filterSuccessfulStatusCodes()
            .map([Album].self)
    }
}
