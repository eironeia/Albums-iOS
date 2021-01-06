import UIKit

public extension UIViewController {
    func addXDismissalButton(selector: Selector) {
        let image = UIImage(named: "close-x")
        let button = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: selector
        )
        navigationItem.setLeftBarButton(button, animated: false)
    }
}
