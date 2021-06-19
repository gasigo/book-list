import ToggleFoundation

struct BooksViewState {
	struct BookCell: Equatable {
		let title: String
		let author: String
		let shortDescription: String?
		let description: String
		let price: String
		let canExpand: Bool
	}

	enum Content: Equatable {
		case loading(message: String)
		case loadingMorePages
		case loaded(cells: [BookCell])
		case failedToLoadFirstPage(error: CustomError)
		case failed(error: CustomError)
	}

	let title: String
	let content: Content
	let retryText: String
}

struct BooksPresenter {
	func format(state: BooksInteractor.State) -> BooksViewState {
		switch state.content {
		case let .loaded(books):
			return makeLoadedState(books: books)
		case .loading:
			return makeLoadingState(isOnFirstPage: state.isOnFirstPage)
		case let .failed(error):
			return makeFailedState(error: error, isOnFirstPage: state.isOnFirstPage)
		}
	}

	private func makeLoadedState(books: [Book]) -> BooksViewState {
		let bookCells: [BooksViewState.BookCell] = books.map { book in
			let price = Double(book.price)
			let canExpand = book.description.count > 50

			return BooksViewState.BookCell(
				title: book.title,
				author: book.author,
				shortDescription: canExpand
					? makeShortDescription(description: book.description)
					: nil,
				description: book.description,
				price: price == 0 ? Copy.free : "$ " + book.price,
				canExpand: canExpand
			)
		}

		return makeViewState(with: .loaded(cells: bookCells))
	}

	private func makeFailedState(error: CustomError, isOnFirstPage: Bool) -> BooksViewState {
		if isOnFirstPage {
			return makeViewState(with: .failedToLoadFirstPage(error: error))
		} else {
			return makeViewState(with: .failed(error: error))
		}
	}

	private func makeLoadingState(isOnFirstPage: Bool) -> BooksViewState {
		if isOnFirstPage {
			return makeViewState(with: .loading(message: Copy.loadingMessage))
		} else {
			return makeViewState(with: .loadingMorePages)
		}
	}

	private func makeViewState(with content: BooksViewState.Content) -> BooksViewState {
		BooksViewState(
			title: Copy.title,
			content: content,
			retryText: Copy.retry
		)
	}

	private func makeShortDescription(description: String) -> String {
		description.prefix(50).description.trimmingCharacters(in: .whitespacesAndNewlines) + "..."
	}
}

extension BooksPresenter {
	struct Copy {
		static var title: String { "Best Sellers" }
		static var retry: String { "Retry" }
		static var loadingMessage: String { "Loading best seller books" }
		static var free: String { "FREE" }
	}
}
