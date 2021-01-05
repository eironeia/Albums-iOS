import Foundation

struct PhotoUIModel: Equatable {
    let id: Int
    let title: String
    let thumbnailUrl: String

    init(photo: Photo) {
        id = photo.id
        title = photo.title
        thumbnailUrl = photo.thumbnailUrl
    }
}

