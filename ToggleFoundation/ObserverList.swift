public final class ObserverList<T> {
	private var observers = [Observer<T>]()

	public init() {}

	public func append(context: AnyObject? = nil, observer: @escaping (T) -> Void) {
		observers = observers.filter { $0.context != nil }
		observers.append(Observer(context: context ?? self, observer: observer))
	}

	public func notify(of value: T) {
		observers = observers.filter { $0.context != nil }
		observers.forEach { item in item.observer(value) }
	}
}

private final class Observer<T> {
	weak var context: AnyObject?

	let observer: (T) -> Void

	init(context: AnyObject, observer: @escaping (T) -> Void) {
		self.context = context
		self.observer = observer
	}
}

