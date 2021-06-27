@testable import BookList

final class RequestBuilder: Request {
	private(set) var method: HTTPMethod = .get
	private(set) var path: String = ""
	private(set) var queryParameters: [String : String] = [:]

	func setMethod(_ method: HTTPMethod) -> Self {
		self.method = method
		return self
	}

	func setPath(_ path: String) -> Self {
		self.path = path
		return self
	}

	func setQueryParameters(_ queryParameters: [String : String]) -> Self {
		self.queryParameters = queryParameters
		return self
	}

	func build() -> Request {
		DummyRequest(method: method, path: path, queryParameters: queryParameters)
	}
}
