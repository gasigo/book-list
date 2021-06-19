public struct ScopedBuilder<Args> {
	let buildFunc: (Args) -> Router

	public func build(args: Args) -> Router {
		buildFunc(args)
	}
}

public extension Builder {
	func scoped<T>(_ makeComponent: @escaping (T) -> Component) -> ScopedBuilder<T> {
		ScopedBuilder(buildFunc: { args -> Router in
			self.build(component: makeComponent(args))
		})
	}
}
