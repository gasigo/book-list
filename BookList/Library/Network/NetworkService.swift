import Foundation
import ToggleFoundation

protocol NetworkService {
	func request<T: Decodable>(request: Request, resposeType: T.Type) -> Promise<T>
}

struct NetworkServiceImpl: NetworkService {
	private let session: URLSession
	private let configuration: NetworkConfiguration

	init(session: URLSession, configuration: NetworkConfiguration) {
		self.session = session
		self.configuration = configuration
	}

	func request<T: Decodable>(request: Request, resposeType: T.Type) -> Promise<T> {
		guard let url = makeURL(request) else {
			return Promise(error: CustomError.invalidURL)
		}

		var httpRequest = URLRequest(url: url)
		httpRequest.httpMethod = request.method.rawValue

		return Promise { success, failure in
			session.dataTask(with: httpRequest) { data, response, error in
				switch (data, error) {
				case let (_, .some(error)):
					failure(error)
				case let (.some(date), .none):
					guard let response = self.decode(data: date, to: resposeType) else {
						failure(CustomError.unableToSerialize)
						return
					}

					success(response)
				default:
					failure(CustomError.requestFailed)
				}

			}.resume()
		}
	}

	private func decode<T: Decodable>(data: Data, to type: T.Type) -> T? {
		do {
			return try JSONDecoder().decode(type, from: data)
		} catch {
			print(error)
		}

		return nil
	}

	private func makeURL(_ request: Request) -> URL? {
		var baseURL = URLComponents(string: configuration.baseURL + request.path)
		baseURL?.queryItems =
			[URLQueryItem(name: "api-key", value: configuration.apiKey)]
			+ request.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		return baseURL?.url
	}
}

private extension CustomError {
	static var requestFailed: CustomError {
		CustomError(message: "Couldn't complete request")
	}

	static var unableToSerialize: CustomError {
		CustomError(message: "Couldn't serialize server response")
	}

	static var invalidURL: CustomError {
		CustomError(message: "The request URL provided was invalid")
	}
}
