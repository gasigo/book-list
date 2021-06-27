import Foundation
@testable import BookList

final class HTTPClientSpy: HTTPClient {
	var executeCounter = 0
	var capturedRequest: URLRequest?
	var responseData: Data?
	var response: URLResponse?
	var responseError: Error?
	var responseTask: Task?

	func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Task {
		executeCounter += 1
		capturedRequest = request
		completionHandler(responseData, response, responseError)
		return responseTask!
	}
}
