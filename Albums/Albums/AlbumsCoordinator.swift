import UIKit
protocol CoordinatorInterface {
    func start()
}

struct AlbumsCoordinator: CoordinatorInterface {
    private weak var presenter: UINavigationController?
    private let albumsFactory: AlbumsFactoryInterface

    init(presenter: UINavigationController, albumsFactory: AlbumsFactoryInterface) {
        self.presenter = presenter
        self.albumsFactory = albumsFactory
    }

    func start() {
        let viewController = albumsFactory
            .makeAlbumsViewController(onNavigate: handleAlbumsViewModelNavigation)
        presenter?.pushViewController(viewController, animated: true)
    }

    func toPhotos(albumId: Int) {
        let viewController = albumsFactory
            .makePhotosViewController(
                albumId: albumId,
                onNavigate: handlePhotosViewModelNavigation
            )
        presenter?.pushViewController(viewController, animated: true)
    }

    func toPhotoDetails(photo: Photo) {
        let viewController = albumsFactory.makePhotoDetailsViewController(
            photo: photo,
            onNavigate: { navigation in
                switch navigation {
                case .completion:
                    presenter?.dismiss(animated: true, completion: nil)
                }
            }
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        presenter?.present(navigationController, animated: true, completion: nil)
    }

    func handleAlbumsViewModelNavigation(navigation: AlbumsViewModel.Navigation) {
        switch navigation {
        case let .photos(albumId): toPhotos(albumId: albumId)
        }
    }

    func handlePhotosViewModelNavigation(navigation: PhotosViewModel.Navigation) {
        switch navigation {
        case let .photoDetails(photo): toPhotoDetails(photo: photo)
        }
    }
}
