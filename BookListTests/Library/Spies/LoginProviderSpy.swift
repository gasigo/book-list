import ToggleFoundation
@testable import BookList

final class LoginProviderSpy: LoginProvider, Spy {
	var isUserAuthenticatedCounter = 0
	var isUserAuthenticatedResponse: Bool?
	var isUserAuthenticated: Bool {
		isUserAuthenticatedCounter += 1
		return isUserAuthenticatedResponse!
	}

	var authenticateCounter = 0
	var authenticateResponse: Promise<Void>?
	func authenticate() -> Promise<Void> {
		authenticateCounter += 1
		return authenticateResponse!
	}

	var getAvailableBiometryCounter = 0
	var getAvailableBiometryResponse: BiometryAuthenticationType?
	func getAvailableBiometry() -> BiometryAuthenticationType {
		getAvailableBiometryCounter += 1
		return getAvailableBiometryResponse!
	}

	func reset() {
		isUserAuthenticatedCounter = 0
		authenticateCounter = 0
		getAvailableBiometryCounter = 0

		isUserAuthenticatedResponse = nil
		authenticateResponse = nil
		getAvailableBiometryResponse = nil
	}
}
