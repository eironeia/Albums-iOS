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

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
