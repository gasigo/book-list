public protocol Builder {
	associatedtype Component
	func build(component: Component) -> Router
}
