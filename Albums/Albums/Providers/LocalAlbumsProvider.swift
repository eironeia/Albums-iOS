import Foundation

protocol LocalAlbumsProviderInterface {
    func getAlbums(page: UInt) -> [Album]?
    func saveAlbums(page: UInt, albums: [Album])
}

struct LocalAlbumsProvider: LocalAlbumsProviderInterface {
    func getAlbums(page: UInt) -> [Album]? {
        return nil
    }

    func saveAlbums(page: UInt, albums: [Album]) {}
}
