import ToggleFoundation
import UIKit

public extension UIControl {
	func on(_ events: UIControl.Event, _ closure: @escaping (Self) -> Void) {
		let target = ClosureTarget<Self>(closure: closure)
		addTarget(target, action: #selector(target.action(_:)), for: events)
		retain(object: target)
	}
}
