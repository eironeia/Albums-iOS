import RxSwift
import Foundation

protocol PhotosViewModelInterface {
    var firstPageIndex: UInt { get }
    func transform(
        event: Observable<PhotosViewModel.Event>
    ) -> Observable<PhotosViewModel.State>
}

extension PhotosViewModel {
    enum Event {
        case start
        case photoSelected(photoId: Int)
        case refresh
        case loadMore(page: UInt)
    }

    enum State: Equatable {
        case isLoading(Bool)
        case photos([PhotoUIModel])
        case nextPhotosPage([PhotoUIModel])
        case noMorePages
        case idle
    }

    enum Navigation: Equatable {
        case photoDetails(photo: Photo)
    }
}

final class PhotosViewModel: PhotosViewModelInterface {
    // MARK: - Dependencies
    private let albumId: Int
    private let photosUseCase: PhotosUseCaseInterface
    private let onNavigate: (Navigation) -> Void

    init(
        albumId: Int,
        photosUseCase: PhotosUseCaseInterface,
        onNavigate: @escaping (PhotosViewModel.Navigation) -> Void
    ) {
        self.albumId = albumId
        self.photosUseCase = photosUseCase
        self.onNavigate = onNavigate
    }

    // MARK: - Stored properties
    let firstPageIndex: UInt = 1

    // MARK: - Subject
    private let isLoadingSubject = PublishSubject<Bool>()
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    private var photos: [Photo] = []

    func transform(event: Observable<Event>) -> Observable<State> {
        let state = event
            .flatMapLatest { [weak self] event -> Observable<State> in
                guard let self = self else {
                    assertionFailure("self should not be nil")
                    return .just(.idle)
                }
                return self.mapEventToState(event: event)
            }

        let isLoadingState = isLoadingSubject.map(State.isLoading)

        return Observable.merge(
            state,
            isLoadingState
        )
    }
}

private extension PhotosViewModel {
    func mapEventToState(event: Event) -> Observable<State> {
        switch event {
        case .start, .refresh:
            return getPhotosState(page: firstPageIndex, albumId: albumId)
        case let .loadMore(page):
            return getPhotosState(page: page, albumId: albumId)
        case let .photoSelected(id):
            if let photo = photos.first(where: { $0.id == id }) {
                onNavigate(.photoDetails(photo: photo))
            }
            return .just(.idle)
        }
    }

    func getPhotosState(page: UInt, albumId: Int) -> Observable<State> {
        isLoadingSubject.onNext(true)
        return photosUseCase
            .getPhotos(page: page, albumId: albumId)
            .asObservable()
            .do(onNext: { [weak self] photos in
                self?.storePhotos(photos: photos, page: page)
            })
            .stopLoading(loadingSubject: isLoadingSubject)
            .map { $0.map(PhotoUIModel.init) }
            .map { [weak self] photosUIModel -> State in
                guard !photosUIModel.isEmpty else { return .noMorePages }
                return page == self?.firstPageIndex
                    ? .photos(photosUIModel)
                    : .nextPhotosPage(photosUIModel)
            }
    }

    func storePhotos(photos: [Photo], page: UInt) {
        if page == firstPageIndex {
            self.photos = photos
        } else {
            self.photos += photos
        }
    }
}
