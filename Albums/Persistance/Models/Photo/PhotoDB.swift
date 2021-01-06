import Foundation

struct PhotoDB: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String

    init(photo: Photo) {
        albumId = photo.albumId
        id = photo.id
        title = photo.title
        url = photo.url
        thumbnailUrl = photo.thumbnailUrl
    }
}
