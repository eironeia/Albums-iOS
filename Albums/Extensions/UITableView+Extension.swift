import UIKit

extension UITableView {
    func cell<T: Reusable>(as _: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T else {
            fatalError("Cell has not been registered.")
        }
        return cell
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func cell<T: Reusable>(as _: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            fatalError("Cell has not been registered.")
        }
        return cell
    }
}
