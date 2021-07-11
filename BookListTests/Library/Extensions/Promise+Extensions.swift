import ToggleFoundation
import XCTest

extension Promise where T: Equatable {
	func fulfill(expectation: XCTestExpectation, if expectedResponse: T) {
		then { response in
			if response == expectedResponse {
				expectation.fulfill()
			}
		}.shouldNotFail()
	}

	func fulfill(expectation: XCTestExpectation, if expectedError: Error) {
		self.catch { error in
			if error.toCustomError() == expectedError.toCustomError() {
				expectation.fulfill()
			}
		}
	}
}
