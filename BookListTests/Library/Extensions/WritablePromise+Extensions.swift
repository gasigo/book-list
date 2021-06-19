@testable import BookList

extension WritablePromise {
	static func makePromise(with value: T, of type: T.Type) -> WritablePromise {
		let promise: WritablePromise<T> = WritablePromise.pending()
		promise.fulfill(value: value)
		return promise
	}

	static func makePromise(with error: Error, of type: T.Type) -> WritablePromise {
		let promise: WritablePromise<T> = WritablePromise.pending()
		promise.reject(error: error)
		return promise
	}
}
