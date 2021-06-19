import ToggleCore
import UIKit

protocol LoginComponent {
	var window: UIWindow { get }
	var presentationContext: NavigableContext { get }
	var loginProvider: LoginProvider { get }
	var delegate: LoginDelegate? { get }
}

struct LoginArgs {
	let presentationContext: NavigableContext
	let delegate: LoginDelegate?
}

struct LoginBuilder: Builder {
	func build(component: LoginComponent) -> Router {
		let interactor = LoginInteractor(
			loginProvider: component.loginProvider,
			delegate: component.delegate
		)
		let presenter = LoginPresenter()
		let vc = LoginViewController(interactor: interactor, state: presenter.format(state: interactor.state))

		return LoginRouter(component: component)
			.routing(for: interactor)
			.presenting(view: vc, using: component.presentationContext)
	}
}
