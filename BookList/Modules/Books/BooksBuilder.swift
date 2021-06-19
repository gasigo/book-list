import ToggleCore

protocol BooksComponent {
	var presentationContext: NavigableContext { get }
	var bookProvider: BookProvider { get }
}

struct BooksArgs {
	let presentationContext: NavigableContext
	let networkConfiguration: NetworkConfiguration
}

struct BooksBuilder: Builder {
	func build(component: BooksComponent) -> Router {
		let interactor = BooksInteractor(bookProvider: component.bookProvider)
		let presenter = BooksPresenter()
		let vc = BooksViewController(
			interactor: interactor,
			state: interactor.state.map(presenter.format(state:))
		)

		return BooksRouter(component: component)
			.routing(for: interactor)
			.presenting(view: vc, using: component.presentationContext)
	}
}
