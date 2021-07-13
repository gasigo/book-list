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
	var queryParameters: [String: String]? { get }
	var body: [String: AnyHashable]? { get }
}

extension Request {
	func toURLRequest(configuration: NetworkConfiguration) -> URLRequest? {
		guard let url = makeURL(configuration: configuration) else { return nil }

		let request = URLRequest(url: url).set(httpMethod: method.rawValue)

		switch method {
		case .delete, .post, .put:
			return request.set(httpBody: body ?? [:])
		case .get:
			return request
		}
	}

	private func makeURL(configuration: NetworkConfiguration) -> URL? {
		var baseURL = URLComponents(string: configuration.baseURL + path)

		if let parameters = queryParameters {
			baseURL?.queryItems =
				[URLQueryItem(name: "api-key", value: configuration.apiKey)]
				+ parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		}

		return baseURL?.url
	}
}

private extension URLRequest {
	func set(httpMethod: String) -> Self {
		var request = self
		request.httpMethod = httpMethod
		return request
	}

	func set(httpBody: [String: AnyHashable]) -> Self {
		var request = self
		request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
		return request
	}
}
