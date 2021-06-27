import Foundation

protocol HTTPClient {
	func execute(
		request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> Task
}

extension URLSession: HTTPClient {
	func execute(
		request: URLRequest,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> Task {
		dataTask(with: request, completionHandler: completionHandler)
	}
}
