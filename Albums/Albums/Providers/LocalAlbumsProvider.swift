import Foundation

protocol LocalAlbumsProviderInterface {
    func getAlbums(page: UInt) -> [Album]?
}

struct LocalAlbumsProvider: LocalAlbumsProviderInterface {
    func getAlbums(page: UInt) -> [Album]? {
        return nil
    }
}
