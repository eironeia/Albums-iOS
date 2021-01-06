import Foundation

struct AlbumDB: Codable {
    let userId: Int
    let id: Int
    let title: String

    init(album: Album) {
        userId = album.userId
        id = album.id
        title = album.title
    }
}
