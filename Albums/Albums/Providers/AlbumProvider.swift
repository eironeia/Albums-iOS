import Foundation
import RxSwift

protocol AlbumsProviderInterface {}

struct AlbumsProvider: AlbumsProviderInterface {
    func getAlbums() -> [Album] {
        [
            .init(userId: 1, id: 1, title: "")
        ]
    }
}
