import ToggleCore
import ToggleFoundation
import XCTest
@testable import BookList

final class BooksInteractorTests: XCTestCase {
	private var bookProviderSpy: BookProviderSpy!
	private var routerSpy: Router!
	private var sut: BooksInteractor!

	override func setUp() {
		bookProviderSpy = BookProviderSpy()
		routerSpy = AnyRouter()
		sut = BooksInteractor(bookProvider: bookProviderSpy)
	}

	private func startSUTAndReset(setToFirstPage: Bool, books: [Book] = [BookBuilder().build()]) {
		bookProviderSpy.listBooksResponse = setToFirstPage
			? WritablePromise.makePromise(with: CustomError.testError, of: [Book].self)
			: WritablePromise.makePromise(with: books, of: [Book].self)
		sut.start(router: routerSpy)
		bookProviderSpy.reset()
	}
}

// MARK: - Init Tests

extension BooksInteractorTests {
	func test_init_withWorkingBookProvider_shouldSetContentToLoading() {
		// when
		sut = BooksInteractor(bookProvider: bookProviderSpy)

		// then
		XCTAssertTrue(sut.state.value.isOnFirstPage)
		XCTAssertEqual(sut.state.value.content, .loading)
	}
}

// MARK: - Start Tests

extension BooksInteractorTests {
	func test_start_withWorkingListBooksResponse_shouldSetContentToLoaded() {
		// given
		let dummyBooks = [BookBuilder().build()]
		bookProviderSpy.listBooksResponse = WritablePromise.makePromise(with: dummyBooks, of: [Book].self)

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(sut.state.value.content, .loaded(books: dummyBooks))
		XCTAssertFalse(sut.state.value.isOnFirstPage)
		XCTAssertEqual(bookProviderSpy.listBooksCounter, 1)
	}

	func test_start_withEmptyListBooksResponse_shouldSetContentToFailed() {
		// given
		bookProviderSpy.listBooksResponse = WritablePromise.makePromise(with: [], of: [Book].self)

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(sut.state.value.content, .failed(error: CustomError.noBooksFound))
		XCTAssertTrue(sut.state.value.isOnFirstPage)
		XCTAssertEqual(bookProviderSpy.listBooksCounter, 1)
	}

	func test_start_withFailingListBooksResponse_shouldSetContentToFailed() {
		// given
		bookProviderSpy.listBooksResponse = WritablePromise.makePromise(
			with: CustomError.testError,
			of: [Book].self
		)

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(sut.state.value.content, .failed(error: CustomError.testError))
		XCTAssertTrue(sut.state.value.isOnFirstPage)
		XCTAssertEqual(bookProviderSpy.listBooksCounter, 1)
	}
}

// MARK: - Retry Tests

extension BooksInteractorTests {
	func test_retry_withIsOnFirstPageTrue_shouldSetContentToLoading() {
		// given
		startSUTAndReset(setToFirstPage: true)
		bookProviderSpy.listBooksResponse = .pending()

		// when
		sut.retry()

		// then
		XCTAssertEqual(sut.state.value.content, .loading)
		XCTAssertEqual(bookProviderSpy.listBooksCounter, 1)
	}

	func test_retry_withIsOnFirstPageFalse_shouldSetContentToLoading() {
		// given
		startSUTAndReset(setToFirstPage: false)
		bookProviderSpy.loadMoreBooksResponse = .pending()

		// when
		sut.retry()

		// then
		XCTAssertEqual(sut.state.value.content, .loading)
		XCTAssertEqual(bookProviderSpy.loadMoreBooksCounter, 1)
	}

	func test_retry_withWorkingListBooksResponseWhileOnFirstPage_shouldSetContentToLoaded() {
		// given
		startSUTAndReset(setToFirstPage: true)
		let dummyBooks = [BookBuilder().build()]
		bookProviderSpy.listBooksResponse = WritablePromise.makePromise(with: dummyBooks, of: [Book].self)

		// when
		sut.retry()

		// then
		XCTAssertEqual(sut.state.value.content, .loaded(books: dummyBooks))
		XCTAssertEqual(bookProviderSpy.listBooksCounter, 1)
	}

	func test_retry_withWorkingListBooksResponseWhileNotOnFirstPage_shouldSetContentToLoaded() {
		// given
		let dummyBooksFirstPage = [BookBuilder().set(title: "first page").build()]
		let dummyBooksSecondPage = [BookBuilder().set(title: "second page").build()]
		startSUTAndReset(setToFirstPage: false, books: dummyBooksFirstPage)
		bookProviderSpy.loadMoreBooksResponse = WritablePromise.makePromise(
			with: dummyBooksSecondPage,
			of: [Book].self
		)

		// when
		sut.retry()

		// then
		XCTAssertEqual(sut.state.value.content, .loaded(books: dummyBooksFirstPage + dummyBooksSecondPage))
		XCTAssertEqual(bookProviderSpy.loadMoreBooksCounter, 1)
	}
}
