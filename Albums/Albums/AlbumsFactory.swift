import Foundation

protocol AlbumsFactoryInterface {
    func makeAlbumsViewController(onNavigate: @escaping (AlbumsViewModel.Navigation) -> Void) -> AlbumsViewController
    func makePhotosViewController(albumId: Int) -> PhotosViewController
}

struct AlbumsFactory: AlbumsFactoryInterface {
    func makeAlbumsViewController(onNavigate: @escaping (AlbumsViewModel.Navigation) -> Void) -> AlbumsViewController {
        let albumsProvider = AlbumsProvider()
        let localAlbumsProvider = LocalAlbumsProvider()
        let useCase = AlbumsUseCase(
            albumsProvider: albumsProvider,
            localAlbumsProvider: localAlbumsProvider
        )
        let viewModel = AlbumsViewModel(
            albumsUseCase: useCase,
            onNavigate: onNavigate
        )
        return AlbumsViewController(viewModel: viewModel)
    }

    func makePhotosViewController(albumId: Int) -> PhotosViewController {
        let provider = PhotosProvider()
        let localProvider = LocalPhotosProvider()

        let useCase = PhotosUseCase(
            photosProvider: provider,
            localPhotosProvider: localProvider
        )

        let viewModel = PhotosViewModel(
            albumId: albumId,
            photosUseCase: useCase
        )

        return PhotosViewController(viewModel: viewModel)
    }
}
