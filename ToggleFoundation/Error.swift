import Foundation

private let defaultErrorTitle = "Something went wrong"

public struct CustomError: LocalizedError, Equatable {
	public let title: String
	public let message: String

	public var errorDescription: String? { message }

	public init(title: String? = nil, message: String) {
		self.title = title ?? defaultErrorTitle
		self.message = message
	}

	public init(error: Error) {
		title = error.title
		message = error.message
	}
}

public extension Error {
	var title: String {
		(self as? CustomError)?.title ?? defaultErrorTitle
	}

	var message: String {
		(self as? CustomError)?.message ?? localizedDescription
	}

	func toCustomError() -> CustomError {
		CustomError(error: self)
	}
}
