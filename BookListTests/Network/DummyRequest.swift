@testable import BookList

struct DummyRequest: Request {
	let method: HTTPMethod
	let path: String
	let queryParameters: [String: String]?
	let body: [String : AnyHashable]?
}
