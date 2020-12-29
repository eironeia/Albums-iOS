import Foundation
import RxSwift
import Moya

protocol AlbumsProviderInterface {
    func getAlbums(page: UInt) -> Single<[Album]>
}

struct AlbumsProvider: AlbumsProviderInterface {
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
