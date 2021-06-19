import LocalAuthentication
import ToggleFoundation

protocol LoginProvider {
	var isUserAuthenticated: Bool { get }
	func authenticate() -> Promise<Void>
	func getAvailableBiometry() -> BiometryAuthenticationType
}

enum BiometryAuthenticationType {
	case faceID
	case touchID
	case none
}

final class LoginProviderImpl: LoginProvider {
	var isUserAuthenticated: Bool {
		userDefaults.bool(forKey: isUserAuthenticatedKey)
	}

	private let context: LAContext
	private let userDefaults: UserDefaults
	private let isUserAuthenticatedKey = "isUserAuthenticated"
	private let policy = LAPolicy.deviceOwnerAuthentication

	init(userDefaults: UserDefaults) {
		context = LAContext()
		self.userDefaults = userDefaults
	}

	func authenticate() -> Promise<Void> {
		var authError: NSError? = NSError()
		if context.canEvaluatePolicy(policy, error: &authError) {
			if let error = authError {
				return Promise(error: CustomError(message: error.localizedDescription))
			}

			return Promise { success, failure in
				context.evaluatePolicy(
					policy,
					localizedReason: "You need to be authenticated to use this app",
					reply: { [weak self] authenticated, error in
						if let error = error {
							switch (error as NSError).code {
							case LAError.Code.systemCancel.rawValue, LAError.Code.userCancel.rawValue:
								failure(CustomError.autheticationCanceled)
							default:
								failure(error)
							}

							return
						}

						if authenticated {
							self?.handleAuthentication()
							success(())
						} else {
							failure(CustomError.couldNotAuthenticate)
						}
					}
				)
			}
		} else {
			return Promise(error: CustomError.autheticationNotAvailable)
		}
	}

	func getAvailableBiometry() -> BiometryAuthenticationType {
		if context.canEvaluatePolicy(policy, error: nil) {
			if context.biometryType == .faceID { return .faceID }
			if context.biometryType == .touchID { return .touchID }
		}

		return .none
	}

	private func handleAuthentication() {
		userDefaults.set(true, forKey: isUserAuthenticatedKey)
	}
}

extension CustomError {
	static var autheticationCanceled: CustomError {
		CustomError(message: "Authentication attempted was cancelled")
	}
	fileprivate static var couldNotAuthenticate: CustomError {
		CustomError(message: "It was not possible to authenticate")
	}
	fileprivate static var autheticationNotAvailable: CustomError {
		CustomError(message: "Authentication is not available on this device")
	}
}
