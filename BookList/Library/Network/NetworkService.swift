import Foundation
import ToggleFoundation

protocol NetworkService {
	/// Creates a Task to retrieve the contents of the specified url and return a Promise of the specified type.
	func request<T: Decodable>(request: Request, resposeType: T.Type) -> Promise<T>

	/// Creates a Task to retrieve the contents of the specified url and return a Response of the specified type.
	/// The created task is resumed by default.
	func request<T: Decodable>(request: Request, resposeType: T.Type) -> (task: Task, response: Promise<T>)
}

extension NetworkService {
	func request<T: Decodable>(request: Request, resposeType: T.Type) -> Promise<T> {
		self.request(request: request, resposeType: resposeType).response
	}
}

struct NetworkServiceImpl: NetworkService {
	private let client: HTTPClient
	private let configuration: NetworkConfiguration
	private let decoder: ResponseDecoder

	init(client: HTTPClient, configuration: NetworkConfiguration, decoder: ResponseDecoder) {
		self.client = client
		self.configuration = configuration
		self.decoder = decoder
	}

	func request<T: Decodable>(request: Request, resposeType: T.Type) -> (task: Task, response: Promise<T>) {
		guard let httpRequest = request.toURLRequest(configuration: configuration) else {
			return (EmptyTask(), Promise(error: CustomError.invalidRequest))
		}

		let response: WritablePromise<T> = WritablePromise.pending()
		let task = client.execute(request: httpRequest) { data, request, error in
			switch (data, error) {
			case let (_, .some(error)):
				response.reject(error: error)
			case let (.some(date), .none):
				guard let data = self.decoder.decode(data: date, to: resposeType) else {
					response.reject(error: CustomError.unableToSerialize)
					return
				}

				response.fulfill(value: data)
			default:
				response.reject(error: CustomError.requestFailed)
			}
		}
		task.resume()

		return (task: task, response: response.asPromise())
	}
}

extension CustomError {
	static var requestFailed: CustomError {
		CustomError(message: "Couldn't complete request")
	}

	static var unableToSerialize: CustomError {
		CustomError(message: "Couldn't serialize server response")
	}

	static var invalidRequest: CustomError {
		CustomError(message: "The request provided was invalid")
	}
}
