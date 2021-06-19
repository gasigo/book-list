@testable import BookList

final class BookProviderSpy: BookProvider, Spy {
	var listBooksCounter = 0
	var listBooksResponse: WritablePromise<[Book]>?
	func listBooks() -> Promise<[Book]> {
		listBooksCounter += 1
		return listBooksResponse!.asPromise()
	}

	var loadMoreBooksCounter = 0
	var loadMoreBooksResponse: WritablePromise<[Book]>?
	func loadMoreBooks() -> Promise<[Book]> {
		loadMoreBooksCounter += 1
		return loadMoreBooksResponse!.asPromise()
	}

	func reset() {
		listBooksCounter = 0
		loadMoreBooksCounter = 0

		listBooksResponse = nil
		loadMoreBooksResponse = nil
	}
}
