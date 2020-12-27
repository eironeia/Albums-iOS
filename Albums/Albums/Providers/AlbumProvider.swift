import Foundation
import RxSwift

protocol AlbumsProviderInterface {}

enum Endpoint {
    case getAlbums
}

protocol NetworkProviderInterface {
    func request(endpoint: Endpoint)
}

struct AlbumsProvider: AlbumsProviderInterface {
    let networkProvider: NetworkProviderInterface

    func getAlbums() -> Single<[Album]> {
        .just(
            [
                .init(userId: 1, id: 1, title: "")
            ]
        )
    }
}
