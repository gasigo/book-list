@testable import BookList

final class BookBuilder {
	private var title = "test title"
	private var author = "test author"
	private var description = "test description"
	private var price = "0.00"

	init() {}

	func set(title: String) -> BookBuilder {
		self.title = title
		return self
	}

	func set(author: String) -> BookBuilder {
		self.author = author
		return self
	}

	func set(description: String) -> BookBuilder {
		self.description = description
		return self
	}

	func set(price: String) -> BookBuilder {
		self.price = price
		return self
	}

	func build() -> Book {
		Book(title: title, author: author, description: description, price: price)
	}
}
