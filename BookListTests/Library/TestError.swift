import ToggleFoundation
@testable import BookList

extension CustomError {
	static var testError: CustomError {
		makeError(message: "This error is only for test purposes")
	}

	static func makeError(message: String) -> CustomError {
		CustomError(message: message)
	}
}
