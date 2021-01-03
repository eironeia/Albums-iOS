import RxSwift
import Foundation

protocol AlbumsViewModelInterface {
    func transform(
        event: Observable<AlbumsViewModel.Event>
    ) -> Observable<AlbumsViewModel.State>
}

extension AlbumsViewModel {
    enum Event {
        case start
        case loadMore(page: UInt)
    }

    enum State: Equatable {
        case isLoading(Bool)
        case albums([AlbumUIModel])
        case idle
    }
}

struct AlbumsViewModel {
    // MARK: - Dependencies
    let albumsUseCase: AlbumsUseCaseInterface

    // MARK: - Stored properties
    let firstPageIndex: UInt = 1

    // MARK: - Subject
    let isLoadingSubject = PublishSubject<Bool>()

    func transform(event: Observable<Event>) -> Observable<State> {
        let state = event
            .flatMapLatest { event -> Observable<State> in
                switch event {
                case .start:
                    return getAlbumsState(page: firstPageIndex)
                case let .loadMore(page):
                    return getAlbumsState(page: page)
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
            .map(AlbumsViewModel.State.albums)
    }
}
