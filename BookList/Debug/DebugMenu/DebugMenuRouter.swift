import ToggleCore
import UIKit

final class DebugMenuRouter: AbstractRouter<DebugMenuComponent>, DebugMenuRouting {
	private let debugViewController: UIViewController
	private let navigation = UINavigationController()

	private var window: UIWindow?

	init(viewController: UIViewController, component: DebugMenuComponent) {
		self.debugViewController = viewController
		super.init(component: component)
	}

	func showDebugMenu() {
		guard let windowScene = component.window.windowScene else { return }

		let window = UIWindow(windowScene: windowScene)
		let viewController = UIViewController()
		window.windowLevel = UIWindow.Level.alert
		window.rootViewController = viewController
		window.makeKeyAndVisible()
		self.window = window

		navigation.setViewControllers([debugViewController], animated: false)
		navigation.modalPresentationStyle = .fullScreen
		viewController.present(navigation, animated: true)
	}

	func closeDebugMenu() {
		window?.isHidden = true
		window = nil
	}
}
