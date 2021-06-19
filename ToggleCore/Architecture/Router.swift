import UIKit

public protocol Router: AnyObject {
	var name: String { get }

	func start() -> UIViewController
	func stop()
}

public extension Router {
	var name: String {
		"\(type(of: self))"
	}

	func stop() {}
}

public protocol ExtensibleRouter: AnyObject {
	var viewIfPresented: UIViewController? { get }

	func attach(child: Router, identifier: ChildIdentifier)
	func attach(child: Router, asUnique: Bool) -> ChildIdentifier
	func detach(child identifier: ChildIdentifier)
}
