import UIKit

public extension NSLayoutConstraint {
	internal static var currentPriority = [UILayoutPriority.required]

	static func autoSetPriority(_ priority: UILayoutPriority, forConstraints block: () -> Void) {
		currentPriority.append(priority)
		block()
		_ = currentPriority.popLast()
	}

	func autoRemove() {
		isActive = false
	}
}

public extension NSLayoutConstraint {
	@discardableResult
	func offset(by value: CGFloat) -> Self {
		constant = value
		return self
	}

	@discardableResult
	func inset(by value: CGFloat) -> Self {
		switch firstAttribute {
		case .bottom, .right, .trailing:
			constant = -value
		default:
			constant = value
		}
		return self
	}
}

public extension Array where Element: NSLayoutConstraint {
	@discardableResult
	func inset(by insets: UIEdgeInsets) -> [Element] {
		map { constraint in
			switch constraint.firstAttribute {
			case .top:
				return constraint.inset(by: insets.top)
			case .leading, .left:
				return constraint.inset(by: insets.left)
			case .bottom:
				return constraint.inset(by: insets.bottom)
			case .right, .trailing:
				return constraint.inset(by: insets.right)
			default:
				return constraint
			}
		}
	}
}

extension NSLayoutConstraint.Relation {
	func inverted() -> NSLayoutConstraint.Relation {
		switch self {
		case .equal: return self
		case .greaterThanOrEqual: return .lessThanOrEqual
		case .lessThanOrEqual: return .greaterThanOrEqual
		@unknown default: return self
		}
	}
}
