import ToggleCore
import ToggleFoundation

final class BooksInteractor: Interactor {
	let state: Property<State>
	private let _state: MutableProperty<State>
	private let bookProvider: BookProvider
	private var books: [Book] = []

	init(bookProvider: BookProvider) {
		self._state = MutableProperty(value: State(isOnFirstPage: true, content: .loading))
		self.state = _state
		self.bookProvider = bookProvider
	}

	func start(router: Router) {
		fetchFirstPage()
	}

	func loadMoreBooks() {
		bookProvider.loadMoreBooks().then { [weak self] books in
			self?.updateState(with: books)
		}.catch { [weak self] _ in
			self?.updateState(with: CustomError.failedToLoadMorePages)
		}
	}

	func retry() {
		setStateToLoading()

		if books.isEmpty {
			fetchFirstPage()
		} else {
			loadMoreBooks()
		}
	}

	private func fetchFirstPage() {
		bookProvider.listBooks().then { [weak self] books in
			self?.updateState(with: books)
		}.catch { [weak self] error in
			self?.updateState(with: error)
		}
	}

	private func setStateToLoading() {
		let newState = State(isOnFirstPage: self.books.isEmpty, content: .loading)
		_state.update(value: newState)
	}

	private func updateState(with books: [Book]) {
		guard !books.isEmpty else {
			updateState(with: CustomError.noBooksFound)
			return
		}

		self.books += books
		let newState = State(isOnFirstPage: self.books.isEmpty, content: .loaded(books: self.books))
		_state.update(value: newState)
	}

	private func updateState(with error: Error) {
		let newState = State(isOnFirstPage: self.books.isEmpty, content: .failed(error: error.toCustomError()))
		_state.update(value: newState)
	}
}

extension BooksInteractor {
	struct State: Equatable {
		enum Content: Equatable {
			case loading
			case loaded(books: [Book])
			case failed(error: CustomError)
		}

		let isOnFirstPage: Bool
		let content: Content
	}
}

extension CustomError {
	static var noBooksFound: CustomError {
		CustomError(message: "We couldn't find any books to show")
	}

	static var failedToLoadMorePages: CustomError {
		CustomError(message: "Couldn't load more books, please try again")
	}
}
