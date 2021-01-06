import Foundation

struct AlbumPageDB: Codable {
    let page: UInt
    let albums: [AlbumDB]

    init(page: UInt, albums: [Album]) {
        self.page = page
        self.albums = albums.map(AlbumDB.init)
    }
}
