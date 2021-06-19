import UIKit

open class Service {
	public var router: ExtensibleRouter {
		_router ?? ExtensibleRouterStub()
	}

	private weak var _router: ExtensibleRouter?

	public init() {}

	func start(router: ExtensibleRouter) {
		_router = router
		didStart()
	}

	func stop() {
		didStop()
	}

	open func didStart() {
		// override point
	}

	open func didStop() {
		// override point
	}
}

open class ComponentService<Component>: Service {

	public private(set) var component: Component?

	public init(component: Component) {
		self.component = component
	}

	override func stop() {
		super.stop()
		component = nil
	}
}

private final class ExtensibleRouterStub: ExtensibleRouter {

	var viewIfPresented: UIViewController? { nil }

	func attach(child: Router, identifier: ChildIdentifier) {
		_ = attach(legacyChild: child, asUnique: false)
	}

	func attach(legacyChild child: Router, identifier: ChildIdentifier) -> UIViewController {
		attach(legacyChild: child, asUnique: false).viewController
	}

	func attach(child: Router, asUnique: Bool) -> ChildIdentifier {
		attach(legacyChild: child, asUnique: asUnique).identifier
	}

	func attach(
		legacyChild child: Router,
		asUnique: Bool
	) -> (viewController: UIViewController, identifier: ChildIdentifier) {
		return (UIViewController(), ChildIdentifier())
	}

	func detach(child identifier: ChildIdentifier) {}
}

