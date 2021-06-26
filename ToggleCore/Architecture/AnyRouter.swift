public final class AnyRouter: AbstractRouter<Any> {
	public override var name: String {
		_name + "Router"
	}

	private let _name: String
	private let onStart: (AnyRouter) -> Void

	public init(name: String = "Any", onStart: @escaping (AnyRouter) -> Void = { _ in }) {
		_name = name
		self.onStart = onStart
		super.init(component: 0)
	}

	override func didStart() {
		onStart(self)
	}
}
