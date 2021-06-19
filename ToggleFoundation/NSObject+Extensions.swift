import Foundation

public extension NSObject {
	class var nameOfClass: String {
		NSStringFromClass(self).components(separatedBy: ".").last!
	}

	/// Maintains a strong anonymous reference to `object`
	func retain(object: AnyObject) {
		objc_setAssociatedObject(
			self,
			Unmanaged.passUnretained(object).toOpaque(),
			object,
			.OBJC_ASSOCIATION_RETAIN
		)
	}
}
