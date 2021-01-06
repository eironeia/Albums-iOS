import UIKit

struct PhotoDetailsUIModel {
    let title: String
    let url: String

    init(title: String, url: String) {
        self.title = title
        self.url = url
    }

    init(photo: Photo) {
        title = photo.title
        url = photo.url
    }
}
