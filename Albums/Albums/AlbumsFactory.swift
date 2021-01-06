import Foundation

protocol AlbumsFactoryInterface {
    func makeAlbumsViewController(
        onNavigate: @escaping (AlbumsViewModel.Navigation) -> Void
    ) -> AlbumsViewController
    func makePhotosViewController(
        albumId: Int,
        onNavigate: @escaping (PhotosViewModel.Navigation) -> Void
    ) -> PhotosViewController
    func makePhotoDetailsViewController(
        photo: Photo,
        onNavigate: @escaping (PhotoDetailsViewModel.Navigation) -> Void
    ) -> PhotoDetailsViewController
}

struct AlbumsFactory: AlbumsFactoryInterface {
    func makeAlbumsViewController(
        onNavigate: @escaping (AlbumsViewModel.Navigation) -> Void
    ) -> AlbumsViewController {
        let albumsProvider = AlbumsProvider()
        let useCase = AlbumsUseCase(
            albumsProvider: albumsProvider,
            localAlbumsProvider: LocalDatabase.shared
        )
        let viewModel = AlbumsViewModel(
            albumsUseCase: useCase,
            onNavigate: onNavigate
        )
        return AlbumsViewController(viewModel: viewModel)
    }

    func makePhotosViewController(
        albumId: Int,
        onNavigate: @escaping (PhotosViewModel.Navigation) -> Void
    ) -> PhotosViewController {
        let provider = PhotosProvider()
        let localProvider = LocalPhotosProvider()

        let useCase = PhotosUseCase(
            photosProvider: provider,
            localPhotosProvider: localProvider
        )

        let viewModel = PhotosViewModel(
            albumId: albumId,
            photosUseCase: useCase,
            onNavigate: onNavigate
        )

        return PhotosViewController(viewModel: viewModel)
    }

    func makePhotoDetailsViewController(
        photo: Photo,
        onNavigate: @escaping (PhotoDetailsViewModel.Navigation) -> Void
    ) -> PhotoDetailsViewController {
        let viewModel = PhotoDetailsViewModel(
            photo: photo,
            onNavigate: onNavigate
        )
        return PhotoDetailsViewController(viewModel: viewModel)
    }
}
