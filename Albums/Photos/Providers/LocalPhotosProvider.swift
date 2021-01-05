import Foundation

protocol LocalPhotosProviderInterface {
    func getPhotos(page: UInt, albumId: Int) -> [Photo]?
}

struct LocalPhotosProvider: LocalPhotosProviderInterface {
    func getPhotos(page: UInt, albumId: Int) -> [Photo]? {
        return nil
    }
}
