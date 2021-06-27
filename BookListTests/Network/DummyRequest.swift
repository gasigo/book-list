@testable import BookList

struct DummyRequest: Request {
	var method: HTTPMethod = .get
	var path: String = ""
	var queryParameters: [String : String] = [:]
}
