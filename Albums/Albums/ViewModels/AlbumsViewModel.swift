import RxSwift
import Foundation

protocol AlbumsViewModelInterface {
    var firstPageIndex: UInt { get }
    func transform(
        event: Observable<AlbumsViewModel.Event>
    ) -> Observable<AlbumsViewModel.State>
}

extension AlbumsViewModel {
    enum Event {
        case start
        case refresh
        case selectedAlbum(albumId: Int)
        case loadMore(page: UInt)
    }

    enum State: Equatable {
        case isLoading(Bool)
        case albums([AlbumUIModel])
        case nextAlbumsPage([AlbumUIModel])
        case noMorePages
        case idle
    }

    enum Navigation: Equatable {
        case photos(albumId: Int)
    }
}

struct AlbumsViewModel: AlbumsViewModelInterface {
    // MARK: - Dependencies
    let albumsUseCase: AlbumsUseCaseInterface
    let onNavigate: (Navigation) -> Void

    // MARK: - Stored properties
    let firstPageIndex: UInt = 1

    // MARK: - Subject
    let isLoadingSubject = PublishSubject<Bool>()

    func transform(event: Observable<Event>) -> Observable<State> {
        let state = event
            .flatMapLatest { event -> Observable<State> in
                switch event {
                case .start, .refresh:
                    return getAlbumsState(page: firstPageIndex)
                case let .loadMore(page):
                    return getAlbumsState(page: page)
                case let .selectedAlbum(albumId):
                    onNavigate(.photos(albumId: albumId))
                    return .just(.idle)
                }
            }

        let isLoadingState = isLoadingSubject.map(State.isLoading)

        return Observable.merge(
            state,
            isLoadingState
        )
    }
}

private extension AlbumsViewModel {
    func getAlbumsState(page: UInt) -> Observable<State> {
        isLoadingSubject.onNext(true)
        return albumsUseCase
            .getAlbums(page: page)
            .asObservable()
            .stopLoading(loadingSubject: isLoadingSubject)
            .map { $0.map(AlbumUIModel.init) }
            .map { albumsUIModel -> State in
                guard !albumsUIModel.isEmpty else { return .noMorePages }
                return page == firstPageIndex
                    ? .albums(albumsUIModel)
                    : .nextAlbumsPage(albumsUIModel)
            }
    }
}
