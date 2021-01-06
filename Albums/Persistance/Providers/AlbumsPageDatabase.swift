import Foundation

protocol AlbumsPageDatabaseInterface {
    func getAlbumsPage(page: UInt) -> AlbumPageDB?
    func saveAlbumsPage(_ albumPageDB: AlbumPageDB)
}

extension LocalDatabase: AlbumsPageDatabaseInterface {
    func getAlbumsPage(page: UInt) -> AlbumPageDB? {
        guard let data = storage.value(forKey: albumsPageKey(page: page)) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(AlbumPageDB.self, from: data)
    }

    func saveAlbumsPage(_ albumPageDB: AlbumPageDB) {
        let data = try? JSONEncoder().encode(albumPageDB)
        storage.set(
            data,
            forKey: albumsPageKey(page: albumPageDB.page)
        )
    }

    func albumsPageKey(page: UInt) -> String {
        KeyIdentifier.albumsPage.rawValue + "\(page)"
    }
}

extension Album {
    init(albumDB: AlbumDB) {
        userId = albumDB.userId
        id = albumDB.id
        title = albumDB.title
    }
}
