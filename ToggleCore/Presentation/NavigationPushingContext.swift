import UIKit

public final class NavigationPushingContext: CancelableNavigableContext {
	public let navigationController: ObservableNavigationController

	private weak var presentedView: UIViewController?
	private var dismissalCallback: (() -> Void)?
	private var animated: Bool

	public init(navigationController: ObservableNavigationController, dismissed: @escaping () -> Void) {
		self.navigationController = navigationController
		dismissalCallback = dismissed
		animated = true
	}

	public convenience init(context: NavigableContext, dismissed: @escaping () -> Void = {}) {
		self.init(navigationController: context.navigationController, dismissed: dismissed)
	}

	public func present(_ view: UIViewController) {
		presentedView = view
		if let markedPop = navigationController.viewControllerMarkedForPop,
			let index = navigationController.viewControllers.firstIndex(of: markedPop) {
			let newStack = navigationController.viewControllers.prefix(upTo: index) + [view]

			DispatchQueue.main.async {
				self.navigationController.setViewControllers(Array(newStack), animated: self.animated)
				self.navigationController.viewControllerMarkedForPop = nil
			}
		} else {
			DispatchQueue.main.async {
				self.navigationController.pushViewController(
					view,
					animated: self.animated ? self.navigationController.viewIfLoaded?.window != nil : false
				)
			}
		}
		var appeared = false
		navigationController.observeStackChanges(context: self) { [weak view, weak self] controller in
			if !controller.viewControllers.contains(where: { $0 == view }), appeared {
				let callback = self?.dismissalCallback
				self?.dismissalCallback = nil
				callback?()
			} else {
				appeared = true
			}
		}
	}

	public func dismiss(_ view: UIViewController) {
		navigationController.viewControllerMarkedForPop = view
		DispatchQueue.main.async(execute: popMarkedViewController)
		let callback = dismissalCallback
		dismissalCallback = nil
		callback?()
	}

	public func cancelPresentation() {
		presentedView.map(dismiss)
	}

	func disableAnimations() {
		animated = false
	}

	private func popMarkedViewController() {
		guard let view = navigationController.viewControllerMarkedForPop else { return }
		navigationController.viewControllerMarkedForPop = nil
		let stack = navigationController.viewControllers
		if let index = stack.firstIndex(of: view), index > 0 {
			navigationController.popToViewController(stack[index - 1], animated: animated)
		}
	}
}

private extension UINavigationController {
	private static var markedControllerKey: UInt8 = 0

	var viewControllerMarkedForPop: UIViewController? {
		get {
			return objc_getAssociatedObject(
				self,
				&UINavigationController.markedControllerKey
			) as? UIViewController
		}
		set {
			if
				let newController = newValue,
				let existingController = viewControllerMarkedForPop,
				let newIndex = viewControllers.firstIndex(of: newController),
				let currentIndex = viewControllers.firstIndex(of: existingController),
				newIndex > currentIndex {
				return
			}
			objc_setAssociatedObject(
				self,
				&UINavigationController.markedControllerKey,
				newValue,
				.OBJC_ASSOCIATION_RETAIN
			)
		}
	}
}
