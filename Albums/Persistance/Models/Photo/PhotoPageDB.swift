import Foundation

struct PhotoPageDB: Codable {
    let page: UInt
    let photos: [PhotoDB]

    init(page: UInt, photos: [Photo]) {
        self.page = page
        self.photos = photos.map(PhotoDB.init)
    }
}
