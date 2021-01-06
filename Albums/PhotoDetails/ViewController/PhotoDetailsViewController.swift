import UIKit

class PhotoDetailsViewController: UIViewController {
    deinit {
        debugPrint("👋🏼 Bye bye \(String(describing: PhotoDetailsViewController.self))")
    }

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
        photoDetailsView.imageView.contentMode = .scaleAspectFit
        photoDetailsView.setup(uiModel: viewModel.photoDetailsUIModel)
        addXDismissalButton(selector: #selector(closeButtonTapped))
        view.backgroundColor = .lightGray
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
        viewModel.onNavigate(.completion)
    }
}
