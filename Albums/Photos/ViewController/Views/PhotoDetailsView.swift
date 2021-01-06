import UIKit
import Kingfisher

final class PhotoDetailsView: UIView {
    static var labelFont = UIFont.systemFont(ofSize: Constants.FontSize.small)

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()

    let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = labelFont
        label.backgroundColor = .clear
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setup(uiModel: PhotoDetailsUIModel) {
        imageView.kf.setImage(
            with: URL(string: uiModel.url),
            placeholder: UIImage(named: "image_placeholder")
        )

        titleLabel.text = uiModel.title
    }
}

private extension PhotoDetailsView {
    func setupUI() {
        setupLayout()
    }

    func setupLayout() {
        [imageView, titleContainer].forEach(addSubview)
        titleContainer.addSubview(titleLabel)

        imageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )

        titleContainer.anchor(
            top: imageView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )

        titleLabel.fillSuperview(
            withEdges: .init(
                top: Constants.Spacing.small,
                left: Constants.Spacing.small,
                bottom: Constants.Spacing.small,
                right: Constants.Spacing.small
            )
        )
    }
}
