public struct WritablePromise<T> {
	private var _promise: Promise<T>!
	private var _fulfill: (T) -> Void = { _ in }
	private var _reject: (Error) -> Void = { _ in }

	public static func pending() -> WritablePromise<T> {
		var promise = WritablePromise()
		promise._promise = Promise { fulfill, reject in
			promise._fulfill = fulfill
			promise._reject = reject
		}
		return promise
	}

	public func asPromise() -> Promise<T> {
		_promise
	}

	public func fulfill(value: T) {
		_fulfill(value)
	}

	public func reject(error: Error) {
		_reject(error)
	}
}
