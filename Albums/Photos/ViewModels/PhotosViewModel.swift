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
}

struct PhotosViewModel: PhotosViewModelInterface {
    // MARK: - Dependencies
    let albumId: Int
    let photosUseCase: PhotosUseCaseInterface

    // MARK: - Stored properties
    let firstPageIndex: UInt = 1

    // MARK: - Subject
    let isLoadingSubject = PublishSubject<Bool>()

    func transform(event: Observable<Event>) -> Observable<State> {
        let state = event
            .flatMapLatest { event -> Observable<State> in
                switch event {
                case .start, .refresh:
                    return getPhotosState(page: firstPageIndex, albumId: albumId)
                case let .loadMore(page):
                    return getPhotosState(page: page, albumId: albumId)
                }
            }

        let isLoadingState = isLoadingSubject.map(State.isLoading)

        return Observable.merge(
            state,
            isLoadingState
        )
    }
}

private extension PhotosViewModel {
    func getPhotosState(page: UInt, albumId: Int) -> Observable<State> {
        isLoadingSubject.onNext(true)
        return photosUseCase
            .getPhotos(page: page, albumId: albumId)
            .asObservable()
            .stopLoading(loadingSubject: isLoadingSubject)
            .map { $0.map(PhotoUIModel.init) }
            .map { photosUIModel -> State in
                guard !photosUIModel.isEmpty else { return .noMorePages }
                return page == firstPageIndex
                    ? .photos(photosUIModel)
                    : .nextPhotosPage(photosUIModel)
            }
    }
}
