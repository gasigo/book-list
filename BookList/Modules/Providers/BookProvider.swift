import ToggleFoundation

protocol BookProvider {
	func listBooks() -> Promise<[Book]>
	func loadMoreBooks() -> Promise<[Book]>
}

final class BookProviderImpl: BookProvider {
	private let networkService: NetworkService
	private var pageRequest: PageRequest?

	init(networkService: NetworkService) {
		self.networkService = networkService
	}

	func listBooks() -> Promise<[Book]> {
		networkService.request(
			request: ListBooksRequest(offset: 0), resposeType: BookList.self
		).then { [weak self] list in
			self?.pageRequest = PageRequest(size: 20, offset: 0, total: list.numberOfResults).nextPage()
			return Promise(value: list.results)
		}
	}

	func loadMoreBooks() -> Promise<[Book]> {
		guard let pageRequest = pageRequest else {
			return Promise(error: CustomError.noMorePages)
		}

		return networkService.request(
			request: ListBooksRequest(offset: pageRequest.offset),
			resposeType: BookList.self
		).then { [weak self] list in
			self?.pageRequest = pageRequest.nextPage()
			return Promise(value: list.results)
		}
	}
}

extension CustomError {
	static var noMorePages: CustomError {
		CustomError(message: "There are no more books to fetch")
	}
}
