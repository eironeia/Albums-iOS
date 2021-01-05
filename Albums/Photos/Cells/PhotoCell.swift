import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    static var labelFont = UIFont.systemFont(ofSize: Constants.FontSize.small)

    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Spacing.small
        return stackView
    }()

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
        label.font = PhotoCell.labelFont
        label.backgroundColor = .clear
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

    func setup(uiModel: PhotoUIModel) {
        imageView
            .kf
            .setImage(
                with: URL(string: uiModel.thumbnailUrl),
                placeholder: UIImage(named: "image_placeholder")
            )

        titleLabel.text = uiModel.title
    }

    static func getHeight(
        for text: String,
        andImageUrl imageUrl: URL?,
        withConstrainedWidth: CGFloat
    ) -> CGFloat {
        let labelSideSpacing = Constants.Spacing.small * 2
        let textHeight = text.height(
            withConstrainedWidth: withConstrainedWidth - labelSideSpacing,
            font: labelFont
        )
        let stackViewSpacing = Constants.Spacing.small
        let imageSize: CGFloat = 150
        return imageSize + stackViewSpacing + textHeight
    }
}

private extension PhotoCell {
    func setupUI() {
        contentMode = .center
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .darkGray
        setupLayout()
    }

    func setupLayout() {

        [container].forEach(contentView.addSubview)
        [imageView, titleContainer].forEach(container.addArrangedSubview)
        titleContainer.addSubview(titleLabel)

        container.fillSuperview()

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
