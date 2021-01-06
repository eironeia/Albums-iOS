import UIKit

final class PhotoCell: UICollectionViewCell {
    static var labelFont = UIFont.systemFont(ofSize: Constants.FontSize.small)

    private let photoDetailsView = PhotoDetailsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setup(uiModel: PhotoUIModel) {
        let photoDetailsUIModel = PhotoDetailsUIModel(
            title: uiModel.title,
            url: uiModel.thumbnailUrl
        )
        photoDetailsView.setup(uiModel: photoDetailsUIModel)
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
        contentView.addSubview(photoDetailsView)
        photoDetailsView.fillSuperview()
    }
}
