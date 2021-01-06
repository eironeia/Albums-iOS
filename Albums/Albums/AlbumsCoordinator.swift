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
            .makePhotosViewController(albumId: albumId)
        presenter?.pushViewController(viewController, animated: true)
    }

    func handleAlbumsViewModelNavigation(navigation: AlbumsViewModel.Navigation) {
        switch navigation {
        case let .photos(albumId): toPhotos(albumId: albumId)
        }
    }
}
