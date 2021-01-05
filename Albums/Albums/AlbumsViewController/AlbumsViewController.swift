import RxSwift
import RxCocoa
import UIKit
import PKHUD

class AlbumsViewController: UITableViewController {
    private let eventsSubject = PublishSubject<AlbumsViewModel.Event>()
    private lazy var disposeBag = DisposeBag()
    private let viewModel: AlbumsViewModelInterface
    private var albumsUIModel: [AlbumUIModel] = []
    private lazy var pageIndex: UInt = viewModel.firstPageIndex
    private var shouldFetchMorePages: Bool = true

    init(viewModel: AlbumsViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        eventsSubject.onNext(.start)
    }
}

private extension AlbumsViewController {
    func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.register(
            AlbumTitleCell.self,
            forCellReuseIdentifier: AlbumTitleCell.identifier
        )
    }

    func setupEvents() {
        viewModel
            .transform(event: eventsSubject)
            .asDriverOnErrorJustComplete()
            .drive(onNext: handleState)
            .disposed(by: disposeBag)
    }

    func handleState(state: AlbumsViewModel.State) {
        switch state {
        case let .albums(albumsUIModel):
            self.albumsUIModel = albumsUIModel
            tableView.reloadData()
        case let .nextAlbumsPage(albumsUIModel):
            pageIndex += 1
            self.albumsUIModel += albumsUIModel
            tableView.reloadData()
        case let .isLoading(showLoader):
            showLoader
                ? HUD.show(.progress)
                : HUD.hide()
        case .noMorePages:
            shouldFetchMorePages = false
        case .idle: return
        }
    }
}

// MARK: - Datasource
extension AlbumsViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return albumsUIModel.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.cell(as: AlbumTitleCell.self)
        let albumUIModel = albumsUIModel[indexPath.row]
        cell.setup(uiModel: albumUIModel)
        return cell
    }
}

// MARK: - Delegate

extension AlbumsViewController {
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard !albumsUIModel.isEmpty,
              shouldFetchMorePages else {
            return
        }

        let isNearbyTheEnd = (albumsUIModel.count - 4) == indexPath.row
        guard isNearbyTheEnd else { return }
        eventsSubject.onNext(.loadMore(page: pageIndex + 1))
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provider = PhotosProvider()
        let localProvider = LocalPhotosProvider()
        let useCase = PhotosUseCase(
            photosProvider: provider,
            localPhotosProvider: localProvider
        )
        let viewModel = PhotosViewModel(
            albumId: 1,
            photosUseCase: useCase
        )
        let viewController = PhotosViewController(viewModel: viewModel)
        present(viewController, animated: true)
    }
}
