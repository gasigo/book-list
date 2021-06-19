enum Method: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

protocol Request {
	var method: Method { get }
	var path: String { get }
	var queryParameters: [String: String] { get }
}
