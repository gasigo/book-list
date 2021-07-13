import ToggleFoundation
import XCTest
@testable import BookList

final class NetworkServiceTests: XCTestCase {
	private var taskSpy: TaskSpy!
	private var httpClientSpy: HTTPClientSpy!
	private var dummyConfiguration: NetworkConfiguration!
	private var responseDecoderSpy: ResponseDecoderSpy!
	private var sut: NetworkService!

	override func setUp() {
		taskSpy = TaskSpy()
		httpClientSpy = HTTPClientSpy()
		dummyConfiguration = NetworkConfiguration(baseURL: "https://test.com", apiKey: "test_key")
		responseDecoderSpy = ResponseDecoderSpy()

		sut = NetworkServiceImpl(
			client: httpClientSpy,
			configuration: dummyConfiguration,
			decoder: responseDecoderSpy
		)
	}
}

// MARK: - Request Tests

extension NetworkServiceTests {
	func test_request_withInvalidURL_shouldFail() {
		// given
		let expectation = XCTestExpectation()
		let dummyRequest = RequestBuilder().setPath("//kl'[]!///").build()

		// when
		let (_, promise) = sut.request(request: dummyRequest, resposeType: String.self)

		// then
		promise.fulfill(expectation: expectation, if: CustomError.NetworkService.invalidRequest)
		wait(for: [expectation], timeout: 0.5)
	}

	func test_request_withFailingClient_shouldFail() {
		// given
		let expectation = XCTestExpectation()
		let dummyRequest = RequestBuilder().setPath("/test").build()
		httpClientSpy.responseError = CustomError.testError
		httpClientSpy.responseTask = taskSpy

		// when
		let (_, promise) = sut.request(request: dummyRequest, resposeType: String.self)

		// then
		promise.fulfill(expectation: expectation, if: CustomError.testError)
		XCTAssertEqual(httpClientSpy.executeCounter, 1)
		XCTAssertEqual(taskSpy.resumeCounter, 1)
		wait(for: [expectation], timeout: 0.5)
	}

	func test_request_withWorkingClientAndFailingDecoder_shouldFail() {
		// given
		let expectation = XCTestExpectation()
		let dummyRequest = RequestBuilder().setPath("/test").build()
		let dummyData = Data("test".utf8)
		httpClientSpy.responseData = dummyData
		httpClientSpy.responseTask = taskSpy
		responseDecoderSpy.response = nil

		// when
		let (_, promise) = sut.request(request: dummyRequest, resposeType: String.self)

		// then
		promise.fulfill(expectation: expectation, if: CustomError.NetworkService.unableToSerialize)
		XCTAssertEqual(httpClientSpy.executeCounter, 1)
		XCTAssertEqual(taskSpy.resumeCounter, 1)
		XCTAssertEqual(responseDecoderSpy.decodeCounter, 1)
		wait(for: [expectation], timeout: 0.5)
	}

	func test_request_withWorkingClientAndDecoder_shouldWork() {
		// given
		let expectation = XCTestExpectation()
		let dummyRequest = RequestBuilder().setPath("/test").build()
		let dummyString = "test"
		let dummyData = Data(dummyString.utf8)
		httpClientSpy.responseData = dummyData
		httpClientSpy.responseTask = taskSpy
		responseDecoderSpy.response = dummyString

		// when
		let (_, promise) = sut.request(request: dummyRequest, resposeType: String.self)

		// then
		promise.fulfill(expectation: expectation, if: dummyString)
		XCTAssertEqual(httpClientSpy.executeCounter, 1)
		XCTAssertEqual(taskSpy.resumeCounter, 1)
		XCTAssertEqual(responseDecoderSpy.decodeCounter, 1)
		XCTAssertEqual(responseDecoderSpy.capturedData, dummyData)
		wait(for: [expectation], timeout: 0.5)
	}
}
