@testable import BookList

final class RootRouterSpy: RootRouting, Spy {
	var routeToHomeCounter = 0
	var routeToHomeCapturedConfiguration: NetworkConfiguration?
	func routeToHome(configuration: NetworkConfiguration) {
		routeToHomeCounter += 1
		routeToHomeCapturedConfiguration = configuration
	}

	var routeToLoginCounter = 0
	var routeToLoginCapturedDelegate: LoginDelegate?
	func routeToLogin(delegate: LoginDelegate) {
		routeToLoginCounter += 1
		routeToLoginCapturedDelegate = delegate
	}

	var routeToErrorCounter = 0
	var routeToErrorCapturedError: Error?
	func routeToError(with error: Error) {
		routeToErrorCounter += 1
		routeToErrorCapturedError = error
	}

	func reset() {
		routeToHomeCounter = 0
		routeToLoginCounter = 0
		routeToErrorCounter = 0

		routeToHomeCapturedConfiguration = nil
		routeToLoginCapturedDelegate = nil
		routeToErrorCapturedError = nil
	}
}

