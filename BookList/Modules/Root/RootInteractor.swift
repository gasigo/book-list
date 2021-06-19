import ToggleCore

protocol RootRouting: AnyObject {
	func routeToHome(configuration: NetworkConfiguration)
	func routeToLogin(delegate: LoginDelegate)
	func routeToError(with error: Error)
	func routeToDebugMenu()
}

final class RootInteractor: Interactor {
	private let configurationProvider: ConfigurationProvider
	private let loginProvider: LoginProvider

	private weak var router: RootRouting?

	init(
		configurationProvider: ConfigurationProvider,
		loginProvider: LoginProvider
	) {
		self.configurationProvider = configurationProvider
		self.loginProvider = loginProvider
	}

	func start(router: RootRouting) {
		self.router = router

		router.routeToDebugMenu()

		if loginProvider.isUserAuthenticated {
			tryRouteToHome()
		} else {
			router.routeToLogin(delegate: self)
		}
	}

	func tryRouteToHome() {
		do {
			router?.routeToHome(configuration: try configurationProvider.getConfiguration())
		} catch {
			router?.routeToError(with: error)
		}
	}
}

extension RootInteractor: LoginDelegate {
	func didLogin() {
		tryRouteToHome()
	}
}
