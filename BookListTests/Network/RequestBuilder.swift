@testable import BookList

final class RequestBuilder {
	private(set) var method: HTTPMethod = .get
	private(set) var path: String = ""
	private(set) var queryParameters: [String: String] = [:]
	private(set) var body: [String : AnyHashable]? = [:]

	func setMethod(_ method: HTTPMethod) -> Self {
		self.method = method
		return self
	}

	func setPath(_ path: String) -> Self {
		self.path = path
		return self
	}

	func setQueryParameters(_ queryParameters: [String: String]) -> Self {
		self.queryParameters = queryParameters
		return self
	}

	func setBody(_ body: [String : AnyHashable]) -> Self {
		self.body = body
		return self
	}

	func build() -> Request {
		DummyRequest(method: method, path: path, queryParameters: queryParameters, body: body)
	}
}
