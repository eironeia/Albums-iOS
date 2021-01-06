import Foundation

struct AlbumUIModel: Equatable {
    let id: Int
    let title: String

    init(album: Album) {
        id = album.id
        title = album.title
    }
}
