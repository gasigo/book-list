import Foundation

public final class ClosureTarget<T>: NSObject {
	public var closure: ((T) -> Void)?

	public init(closure: ((T) -> Void)? = nil) {
		self.closure = closure
	}

	@objc public func action(_ sender: NSObject) {
		closure?(sender as! T)
	}
}
