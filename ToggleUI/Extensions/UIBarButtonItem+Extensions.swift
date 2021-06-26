import ToggleFoundation
import UIKit

public extension UIBarButtonItem {
	static func image(
		_ image: UIImage,
		_ target: @escaping (UIBarButtonItem) -> Void
	) -> UIBarButtonItem {
		let target = ClosureTarget<UIBarButtonItem>(closure: target)
		let item = UIBarButtonItem(
			image: image,
			style: .plain,
			target: target,
			action: #selector(target.action(_:))
		)
		item.retain(object: target)
		return item
	}

	static func close(_ target: @escaping (UIBarButtonItem) -> Void) -> UIBarButtonItem {
		image(UIImage(named: "close")!, target)
	}
}
