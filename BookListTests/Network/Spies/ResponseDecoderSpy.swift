import Foundation
@testable import BookList

final class ResponseDecoderSpy: ResponseDecoder {
	var decodeCounter = 0
	var capturedData: Data?
	var capturedType: Any?
	var response: Any?
	func decode<T>(data: Data, to type: T.Type) -> T? where T : Decodable {
		decodeCounter += 1
		capturedData = data
		capturedType = type
		return response as? T
	}
}
