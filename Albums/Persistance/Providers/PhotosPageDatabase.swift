import Foundation

protocol PhotosPageDatabaseInterface {
    func getPhotosPage(page: UInt, albumId: Int) -> PhotoPageDB?
    func savePhotosPage(_ photoPageDB: PhotoPageDB, albumId: Int)
}

extension LocalDatabase: PhotosPageDatabaseInterface {
    func getPhotosPage(page: UInt, albumId: Int) -> PhotoPageDB? {
        guard let data = storage.value(forKey: photosPageKey(page: page, albumId: albumId)) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(PhotoPageDB.self, from: data)
    }

    func savePhotosPage(_ photoPageDB: PhotoPageDB, albumId: Int) {
        let data = try? JSONEncoder().encode(photoPageDB)
        storage.set(
            data,
            forKey: photosPageKey(page: photoPageDB.page, albumId: albumId)
        )
    }

    func photosPageKey(page: UInt, albumId: Int) -> String {
        KeyIdentifier.photosPage.rawValue + "albumId:\(albumId)-page:\(page)"
    }
}

extension Photo {
    init(photoDB: PhotoDB) {
        albumId = photoDB.albumId
        id = photoDB.id
        title = photoDB.title
        url = photoDB.url
        thumbnailUrl = photoDB.thumbnailUrl
    }
}
