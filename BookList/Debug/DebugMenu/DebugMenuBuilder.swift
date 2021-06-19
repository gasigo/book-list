import ToggleCore
import UIKit

protocol DebugMenuComponent {
	var window: UIWindow { get }
}

struct DebugMenuBuilder: Builder {
	func build(component: DebugMenuComponent) -> Router {
		let interactor = DebugMenuInteractor()
		let viewController = DebugMenuViewController(interactor: interactor)

		return DebugMenuRouter(viewController: viewController, component: component)
			.routing(for: interactor)
	}
}
