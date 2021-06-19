import Foundation
import ToggleCore
import ToggleUI

final class LoginRouter: AbstractRouter<LoginComponent>, LoginRouting {
	func routeToError(with error: Error) {
		let context = NavigationPushingContext(
			context: component.presentationContext
		) { [weak self] in
			self?.detach(child: .error)
		}

		DispatchQueue.main.async {
			let errorRouter = AnyRouter()
				.presenting(view: ErrorViewController(error: error), using: context)
			self.attach(child: errorRouter, identifier: .error)
		}
	}
}

private extension ChildIdentifier {
	static let error: ChildIdentifier = "Error"
}
