import Foundation

public final class Promise<T> {
	public var value: T? {
		result?.value
	}

	var isPending: Bool {
		return result == nil
	}

	private var result: Result<T>?
	private var successObservers = [(T) -> Void]()
	private var errorObservers = [(Error) -> Void]()

	public init(value: T) {
		fulfill(value: value)
	}

	public init(error: Error) {
		reject(error: error)
	}

	public init(
		_ block: (_ fulfill: @escaping (T) -> Void, _ reject: @escaping (Error) -> Void) throws -> Void
	) {
		do {
			try block(fulfill, reject)
		} catch {
			reject(error: error)
		}
	}

	private init() {}

	public func then<Y>(_ map: @escaping (T) throws -> Y) -> Promise<Y> {
		then { value in
			do {
				return Promise<Y>(value: try map(value))
			} catch {
				return Promise<Y>(error: error)
			}
		}
	}

	public func then<Y>(_ flatMap: @escaping (T) -> Promise<Y>) -> Promise<Y> {
		Promise<Y> { fulfill, reject in
			self.addCallbacks(onSuccess: { value in
				flatMap(value).addCallbacks(onSuccess: fulfill, onError: reject)
			}, onError: { error in
				reject(error)
			})
		}
	}

	@discardableResult
	public func `catch`(_ handler: @escaping (Error) -> Void) -> Promise<T> {
		addCallbacks(onSuccess: { _ in }, onError: handler)
		return self
	}

	@discardableResult
	public func always(_ handler: @escaping () -> Void) -> Promise<T> {
		addCallbacks(onSuccess: { _ in handler() }, onError: { _ in handler() })
		return self
	}

	public func recover(_ handler: @escaping (Error) throws -> Promise<T>) -> Promise<T> {
		Promise { fulfill, reject in
			then(fulfill).catch { error in
				do {
					try handler(error).then(fulfill).catch(reject)
				} catch {
					reject(error)
				}
			}
		}
	}

	/// Explicitly silence unused return value from a `then`.
	public func ignoreOutcome() {}

	public func shouldNotFail() {
		self.catch { error in
			assertionFailure("Unexpected error ocurred in Promise: \(error)")
		}
	}

	private func fulfill(value: T) {
		result = .success(value)
		notifyObserversIfReady()
	}

	private func reject(error: Error) {
		result = .failure(error)
		notifyObserversIfReady()
	}

	private func map<Y>(on queue: DispatchQueue?, _ mapping: @escaping (T) throws -> Y) -> Promise<Y> {
		guard let queue = queue else {
			return then(mapping)
		}
		return then { value -> Promise<Y> in
			Promise<Y> { fulfill, reject in
				queue.async {
					do {
						let result = try mapping(value)
						DispatchQueue.main.async { fulfill(result) }
					} catch {
						DispatchQueue.main.async { reject(error) }
					}
				}
			}
		}
	}

	private func addCallbacks(onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
		successObservers.append(onSuccess)
		errorObservers.append(onError)
		notifyObserversIfReady()
	}

	private func notifyObserversIfReady() {
		switch result {
		case .none:
			return
		case let .success(value)?:
			successObservers.forEach { callback in callback(value) }
		case let .failure(error)?:
			errorObservers.forEach { callback in callback(error) }
		}
		successObservers.removeAll()
		errorObservers.removeAll()
	}
}

extension Promise where T == Any {

	public static func merge<U>(_ promises: [Promise<U>]) -> Promise<[U]> {
		guard !promises.isEmpty else {
			return Promise<[U]>(value: [])
		}
		return Promise<[U]> { fulfill, reject in
			var results = [U?](repeating: nil, count: promises.count)
			var isRejected = false

			promises.enumerated().forEach { index, promise in
				promise.addCallbacks(
					onSuccess: { value in
						results[index] = value
						let all = results.compactMap { $0 }
						if all.count == promises.count {
							fulfill(all)
						}
					},
					onError: { error in
						if !isRejected {
							isRejected = true
							reject(error)
						}
					}
				)
			}
		}
	}

	public static func zip<T, U>(_ promiseA: Promise<T>, _ promiseB: Promise<U>) -> Promise<(T, U)> {
		Promise<(T, U)> { fulfill, reject in
			var resolved = false
			func resolve(_: Any) {
				guard !resolved else {
					return
				}

				switch (promiseA.result, promiseB.result) {
				case let (.success(promiseA)?, .success(promiseB)?):
					fulfill((promiseA, promiseB))
					resolved = true
				case let (.failure(error)?, _), let (_, .failure(error)?):
					reject(error)
					resolved = true
				default:
					break
				}
			}
			promiseA.addCallbacks(onSuccess: resolve, onError: resolve)
			promiseB.addCallbacks(onSuccess: resolve, onError: resolve)
		}
	}

	public static func wait(_ interval: TimeInterval) -> Promise<Void> {
		Promise<Void> { fulfill, _ in
			DispatchQueue.main.asyncAfter(deadline: .now() + interval) { fulfill(()) }
		}
	}

	public static func retry<Y>(
		attempts: Int,
		delay: TimeInterval = 0,
		_ body: @escaping () -> Promise<Y>
	) -> Promise<Y> {
		var attempts = attempts
		func attempt() -> Promise<Y> {
			body().recover { error -> Promise<Y> in
				attempts -= 1
				guard attempts >= 0 else {
					throw error
				}

				return delay == 0 ? attempt() : wait(delay).then(attempt)
			}
		}
		return attempt()
	}
}

func firstly<Y>(_ block: @escaping () -> Promise<Y>) -> Promise<Y> {
	return block()
}

extension Promise where T == Void {
	convenience init() {
		self.init(value: ())
	}
}
