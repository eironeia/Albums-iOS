import Foundation

protocol PhotoDetailsViewModelInterface {
    var photoDetailsUIModel: PhotoDetailsUIModel { get }
    var onNavigate: (PhotoDetailsViewModel.Navigation) -> Void { get }
}

extension PhotoDetailsViewModel {
    enum Navigation {
        case completion
    }
}

struct PhotoDetailsViewModel: PhotoDetailsViewModelInterface {
    let photoDetailsUIModel: PhotoDetailsUIModel
    let onNavigate: (Navigation) -> Void

    init(photo: Photo, onNavigate: @escaping (Navigation) -> Void) {
        photoDetailsUIModel = PhotoDetailsUIModel(photo: photo)
        self.onNavigate = onNavigate
    }
}
