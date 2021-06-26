import UIKit

public struct ChildIdentifier: Hashable, ExpressibleByStringLiteral {
	fileprivate let value: String

	fileprivate init(child: Router) {
		value = Unmanaged.passUnretained(child as AnyObject).toOpaque().debugDescription
	}

	init() {
		value = "<undefined>"
	}

	public init(stringLiteral: String) {
		value = stringLiteral
	}
}

open class AbstractRouter<Component>: Router, ExtensibleRouter {
	public final let component: Component

	public var name: String {
		"\(type(of: self))"
	}

	var presentedView: UIViewController {
		guard let view = _presentedView else {
			return UIViewController()
		}
		return view
	}

	public var viewIfPresented: UIViewController? {
		_presentedView
	}

	private var _presentedView: UIViewController?
	private var startFunctions = [() -> Void]()
	private var stopFunctions = [() -> Void]()
	private var services = [Service]()
	private var children = [ChildIdentifier: Router]()

	public init(component: Component) {
		self.component = component
	}

	deinit {
		services.forEach { $0.stop() }
	}

	// MARK: - Lifecycle handling

	@discardableResult
	public func start() -> UIViewController {
		startFunctions.forEach { $0() }
		services.forEach { $0.start(router: self) }
		didStart()
		return UnusedViewController.shared
	}

	public final func stop() {
		stopFunctions.forEach { $0() }
		didStop()
		detachAll()
		services.forEach { $0.stop() }
		services.removeAll()
	}

	func didStart() {
		// override point
	}

	func didStop() {
		// override point
	}

	public func routing<I: Interactor>(for interactor: I) -> Self {
		assert(self is I.Router)
		startFunctions.append { [unowned self] in (self as? I.Router).map(interactor.start(router:)) }
		return self
	}

	public func presenting(view: UIViewController, using context: PresentationContext) -> Self {
		_presentedView = view
		startFunctions.insert({ context.present(view) }, at: 0)
		stopFunctions.append { context.dismiss(view) }
		return self
	}

	public func attach(child: Router, identifier: ChildIdentifier) {
		detach(child: identifier)
		_ = doAttach(child: child, identifier: identifier)
	}

	@discardableResult
	public final func attach(child: Router, asUnique: Bool = false) -> ChildIdentifier {
		if asUnique {
			detachAll()
		}

		let identifier = ChildIdentifier(child: child)
		attach(child: child, identifier: identifier)
		return identifier
	}

	public final func detach(child identifier: ChildIdentifier) {
		if let child = children[identifier] {
			children[identifier] = nil
			child.stop()
		}
	}

	public final func detachAll() {
		children.keys.forEach(detach(child:))
	}

	public func registering(services: [Service]) -> Self {
		self.services += services
		return self
	}

	private func doAttach(child: Router, identifier: ChildIdentifier) -> UIViewController {
		children[identifier] = child
		return child.start()
	}
}

private final class UnusedViewController: UIViewController {
	static let shared = UnusedViewController()
}
