import ToggleFoundation

struct BookList: Equatable, Decodable {
	enum CodingKeys: String, CodingKey {
		case numberOfResults = "num_results"
		case results
	}

	let numberOfResults: Int
	let results: [Book]

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let books = try values.decode([Throwable<Book>].self, forKey: .results)
		results = books.compactMap { try? $0.result.get() }
		numberOfResults = try values.decode(Int.self, forKey: .numberOfResults)
	}
}

struct Book: Equatable, Decodable {
	enum CodingKeys: String, CodingKey {
		case title
		case author
		case description
		case price
	}

	let title: String
	let author: String
	let description: String
	let price: String

	init(title: String, author: String, description: String, price: String) {
		self.title = title
		self.author = author
		self.description = description
		self.price = price
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let title = try values.decode(String.self, forKey: .title)
		let author = try values.decode(String.self, forKey: .author)
		let description = try values.decode(String.self, forKey: .description)
		let price = try values.decode(String.self, forKey: .price)

		try [title, author, description, price].forEach {
			if $0.isEmpty {
				throw CustomError.emptyField
			}
		}

		self.title = title
		self.author = author
		self.description = description
		self.price = price
	}
}

private extension CustomError {
	static var emptyField: CustomError {
		CustomError(message: "Empty strings are not allowed")
	}
}
