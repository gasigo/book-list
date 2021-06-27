import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

protocol Request {
	var method: HTTPMethod { get }
	var path: String { get }
	var queryParameters: [String: String] { get }
}

extension Request {
	func toURLRequest(configuration: NetworkConfiguration) -> URLRequest? {
		guard let url = makeURL(configuration: configuration) else { return nil }
		return URLRequest(url: url).set(httpMethod: method.rawValue)
	}

	private func makeURL(configuration: NetworkConfiguration) -> URL? {
		var baseURL = URLComponents(string: configuration.baseURL + path)
		baseURL?.queryItems =
			[URLQueryItem(name: "api-key", value: configuration.apiKey)]
			+ queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		return baseURL?.url
	}
}

private extension URLRequest {
	func set(httpMethod: String) -> Self {
		var request = self
		request.httpMethod = httpMethod
		return request
	}
}
