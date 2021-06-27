import ToggleFoundation
import XCTest
@testable import BookList

final class BookPresenterTests: XCTestCase {
	private var sut: BooksPresenter!

	override func setUp() {
		sut = BooksPresenter()
	}
}

// MARK: - Format Tests

extension BookPresenterTests {
	func test_format_withLoadedStateWhileIsOnFirstPage_shouldSetContentToLoaded() {
		// given
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loaded(books: []))

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertEqual(viewState.content, .loaded(cells: []))
	}

	func test_format_withFreeBook_shouldSetPriceLabelToFree() {
		// given
		let dummyBook = BookBuilder().set(price: "0.00").build()
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loaded(books: [dummyBook]))

		// when
		let viewState = sut.format(state: state)

		// then
		switch viewState.content {
		case let .loaded(cells):
			XCTAssertEqual(cells.first?.price, BooksPresenter.Copy.free)
		default:
			XCTFail()
		}
	}

	func test_format_withNotFreeBook_shouldSetPriceLabelToCorrectPrice() {
		// given
		let expectedPrice = "4.00"
		let dummyBook = BookBuilder().set(price: "4.00").build()
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loaded(books: [dummyBook]))

		// when
		let viewState = sut.format(state: state)

		// then
		switch viewState.content {
		case let .loaded(cells):
			XCTAssertEqual(cells.first?.price, "$ " + expectedPrice)
		default:
			XCTFail()
		}
	}

	func test_format_withBookWithLongDescription_shouldSetCanExpandToTrue() {
		// given
		let dummyBook = BookBuilder()
			.set(description: "This is a very very very very very long test sentence")
			.build()
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loaded(books: [dummyBook]))

		// when
		let viewState = sut.format(state: state)

		// then
		switch viewState.content {
		case let .loaded(cells):
			XCTAssertTrue(cells.first!.canExpand)
		default:
			XCTFail()
		}
	}

	func test_format_withBookWithShortDescription_shouldSetCanExpandToFalse() {
		// given
		let dummyBook = BookBuilder()
			.set(description: "This is a short sentence")
			.build()
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loaded(books: [dummyBook]))

		// when
		let viewState = sut.format(state: state)

		// then
		switch viewState.content {
		case let .loaded(cells):
			XCTAssertFalse(cells.first!.canExpand)
		default:
			XCTFail()
		}
	}

	func test_format_withLoadingStateWhileIsOnFirstPage_shouldSetContentToLoading() {
		// given
		let state = BooksInteractor.State(isOnFirstPage: true, content: .loading)

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertEqual(viewState.content, .loading(message: BooksPresenter.Copy.loadingMessage))
	}

	func test_format_withLoadingStateWhileIsNotOnFirstPage_shouldSetContentToLoadingMorePages() {
		// given
		let state = BooksInteractor.State(isOnFirstPage: false, content: .loading)

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertEqual(viewState.content, .loadingMorePages)
	}

	func test_format_withFailedStateWhileIsOnFirstPage_shouldSetContentToFailedToLoadFirstPage() {
		// given
		let state = BooksInteractor.State(isOnFirstPage: true, content: .failed(error: CustomError.testError))

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertEqual(viewState.content, .failedToLoadFirstPage(error: CustomError.testError))
	}

	func test_format_withFailedStateWhileIsNotOnFirstPage_shouldSetContentToFailed() {
		// given
		let state = BooksInteractor.State(isOnFirstPage: false, content: .failed(error: CustomError.testError))

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertEqual(viewState.content, .failed(error: CustomError.testError))
	}
}
