import ToggleCore
import ToggleFoundation

protocol LoginRouting: AnyObject {
	func routeToError(with error: Error)
}

protocol LoginDelegate: AnyObject {
	func didLogin()
}

final class LoginInteractor: Interactor {
	let state: State

	private let loginProvider: LoginProvider

	private weak var delegate: LoginDelegate?
	private weak var router: LoginRouting?

	init(loginProvider: LoginProvider, delegate: LoginDelegate?) {
		self.state = State(availableBiometry: loginProvider.getAvailableBiometry())
		self.loginProvider = loginProvider
		self.delegate = delegate
	}

	func start(router: LoginRouting) {
		self.router = router
	}

	func login() {
		loginProvider.authenticate().then { [weak self] _ in
			self?.delegate?.didLogin()
		}.catch { [weak self] error in
			if error.toCustomError() != CustomError.autheticationCanceled {
				self?.router?.routeToError(with: error)
			}
		}
	}
}

extension LoginInteractor {
	struct State {
		let availableBiometry: BiometryAuthenticationType
	}
}
