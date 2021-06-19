public struct Throwable<T: Decodable>: Decodable {
	public let result: Swift.Result<T, Error>

	public init(from decoder: Decoder) throws {
		let catching = { try T(from: decoder) }
		result = Swift.Result(catching: catching)
	}
}
