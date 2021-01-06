import RxSwift
import RxCocoa
import UIKit
import PKHUD

class PhotosViewController: UICollectionViewController {
    private let eventsSubject = PublishSubject<PhotosViewModel.Event>()
    private lazy var disposeBag = DisposeBag()
    private let viewModel: PhotosViewModelInterface
    private var photosUIModel: [PhotoUIModel] = []
    private lazy var pageIndex: UInt = viewModel.firstPageIndex
    private var shouldFetchMorePages: Bool = true
    private var itemSize: CGFloat {
        let separatorSpacing: CGFloat = 8
        let sideInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let collectionViewWidth = collectionView.frame.width
        let numberOfColumns: CGFloat = 2
        return (collectionViewWidth - (sideInsets + separatorSpacing)) / numberOfColumns
    }

    init(viewModel: PhotosViewModelInterface) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: PinterestLayout())
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvents()
        eventsSubject.onNext(.start)
    }
}

private extension PhotosViewController {
    func setupUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(
            top: Constants.Spacing.double,
            left: Constants.Spacing.double,
            bottom: Constants.Spacing.default,
            right: Constants.Spacing.double
        )
        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.identifier
        )
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefresh),
            for: .valueChanged
        )

        if let layout = collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }

    func setupEvents() {
        viewModel
            .transform(event: eventsSubject)
            .asDriverOnErrorJustComplete()
            .drive(onNext: handleState)
            .disposed(by: disposeBag)
    }

    func handleState(state: PhotosViewModel.State) {
        switch state {
        case let .photos(photosUIModel):
            self.photosUIModel = photosUIModel
            collectionView.reloadData()
        case let .nextPhotosPage(photosUIModel):
            pageIndex += 1
            self.photosUIModel += photosUIModel
            collectionView.reloadData()
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
extension PhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosUIModel.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.cell(
            as: PhotoCell.self,
            indexPath: indexPath
        )
        let photoUIModel = photosUIModel[indexPath.row]
        cell.setup(uiModel: photoUIModel)
        return cell
    }
}

// MARK: - Delegate

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: itemSize, height: itemSize)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard !photosUIModel.isEmpty,
              shouldFetchMorePages else {
            return
        }

        print(indexPath.row, photosUIModel.count - 4)
        let isNearbyTheEnd = (photosUIModel.count - 4) == indexPath.row
        guard isNearbyTheEnd else { return }
        eventsSubject.onNext(.loadMore(page: pageIndex + 1))
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = PhotoDetailsViewModel(
            photo: Photo(
                albumId: 1,
                id: 1,
                title: "tenetur minus voluptatum et",
                url: "https://via.placeholder.com/600/c96cad",
                thumbnailUrl: "https://via.placeholder.com/600/c96cad"
            )
        )
        let viewController = PhotoDetailsViewController(viewModel: viewModel)
        present(viewController, animated: true, completion: nil)
    }

    @objc
    func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        shouldFetchMorePages = true
        pageIndex = viewModel.firstPageIndex
        eventsSubject.onNext(.refresh)
    }
}

extension PhotosViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let text = photosUIModel[indexPath.row].title
        let imageUrl = photosUIModel[indexPath.row].thumbnailUrl
        let url = URL(string: imageUrl)
        return PhotoCell.getHeight(
            for: text,
            andImageUrl: url,
            withConstrainedWidth: itemSize
        )
    }
}
