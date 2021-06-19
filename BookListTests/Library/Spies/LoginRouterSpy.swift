@testable import BookList

final class LoginRouterSpy: LoginRouting, Spy {
	var routeToErrorCounter = 0
	var routeToErrorCapturedError: Error?
	func routeToError(with error: Error) {
		routeToErrorCounter += 1
		routeToErrorCapturedError = error
	}

	func reset() {
		routeToErrorCounter = 0
		routeToErrorCapturedError = nil
	}
}

