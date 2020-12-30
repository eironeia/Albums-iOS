import Foundation

struct AlbumUIModel: Equatable {
    let title: String

    init(album: Album) {
        title = album.title
    }
}
