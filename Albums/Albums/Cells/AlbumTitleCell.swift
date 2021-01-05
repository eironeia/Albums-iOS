import UIKit

final class AlbumTitleCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setup(uiModel: AlbumUIModel) {
        titleLabel.text = uiModel.title
    }
}

private extension AlbumTitleCell {
    func setupUI() {
        setupLayout()
    }

    func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.fillSuperview(
            withEdges: .init(
                top: Constants.Spacing.default,
                left: Constants.Spacing.double,
                bottom: Constants.Spacing.default,
                right: Constants.Spacing.double
            )
        )
    }
}
