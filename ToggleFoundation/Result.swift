typealias Result<T> = Swift.Result<T, Error>

extension Result {
	var value: Success? {
		switch self {
		case let .success(wrapped):
			return wrapped
		case .failure:
			return nil
		}
	}
}
