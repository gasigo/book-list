import Foundation

protocol ResponseDecoder {
	func decode<T: Decodable>(data: Data, to type: T.Type) -> T?
}

struct ResponseDecoderImpl: ResponseDecoder {
	func decode<T: Decodable>(data: Data, to type: T.Type) -> T? {
		try? JSONDecoder().decode(type, from: data)
	}
}
