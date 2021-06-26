public class Property<T> {
	public fileprivate(set) var value: T { didSet { observers.notify(of: value) } }

	private var observers = ObserverList<T>()

	public init(value: T) {
		self.value = value
	}

	public func subscribe(context: AnyObject? = nil, observer: @escaping (T) -> Void) {
		observers.append(context: context, observer: observer)
		observer(value)
	}
}

public final class MutableProperty<T>: Property<T> {
	public override init(value: T) {
		super.init(value: value)
	}

	fileprivate init(value: T, setter: (MutableProperty<T>) -> Void) {
		super.init(value: value)
		setter(self)
	}

	public func update(value: T) {
		self.value = value
	}

	public func modify(_ block: (inout T) -> Void) {
		block(&value)
	}
}

public extension Property {
	func map<Y>(context: AnyObject? = nil, _ transform: @escaping (T) -> Y) -> Property<Y> {
		MutableProperty(value: transform(value)) { mutable in
			subscribe(context: context, observer: { mutable.update(value: transform($0)) })
		}
	}
}
