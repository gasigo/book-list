import UIKit

public extension UITableView {
	func registerClass<T: UITableViewCell>(_ type: T.Type) {
		register(type, forCellReuseIdentifier: T.nameOfClass)
	}

	func dequeue<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
		dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as! T
	}

	func setAutoLayoutFooterView(_ view: UIView) {
		let size = view.systemLayoutSizeFitting(CGSize(width: frame.width, height: 0))
		guard view.frame.height != size.height else { return }
		tableFooterView = view
		view.frame.size = size
		tableFooterView = view
	}
}
