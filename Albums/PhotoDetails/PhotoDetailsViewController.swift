import UIKit

struct PhotoDetailsUIModel {
    let title: String
    let url: String

    init(title: String, url: String) {
        self.title = title
        self.url = url
    }

    init(photo: Photo) {
        title = photo.title
        url = photo.url
    }
}

protocol PhotoDetailsViewModelInterface {
    var photoDetailsUIModel: PhotoDetailsUIModel { get }
}

struct PhotoDetailsViewModel: PhotoDetailsViewModelInterface {
    let photoDetailsUIModel: PhotoDetailsUIModel

    init(photo: Photo) {
        photoDetailsUIModel = PhotoDetailsUIModel(photo: photo)
    }
}

class PhotoDetailsViewController: UIViewController {
    private let photoDetailsView = PhotoDetailsView()
    private let viewModel: PhotoDetailsViewModelInterface

    init(viewModel: PhotoDetailsViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension PhotoDetailsViewController {
    func setupUI() {
        photoDetailsView.setup(uiModel: viewModel.photoDetailsUIModel)
        addXDismissalButton(selector: #selector(closeButtonTapped))
        setupLayout()
    }

    func setupLayout() {
        view.addSubview(photoDetailsView)
        photoDetailsView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
    }

    @objc
    func closeButtonTapped() {
        print("close")
    }
}
