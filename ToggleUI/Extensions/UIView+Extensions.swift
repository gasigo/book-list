import UIKit

public extension UIView {
	static func spacer(height: CGFloat) -> UIView {
		let view = UIView()
		view.autoSetDimension(.height, toSize: height)
		return view
	}

	static func spacer(width: CGFloat) -> UIView {
		let view = UIView()
		view.autoSetDimension(.width, toSize: width)
		return view
	}
}
