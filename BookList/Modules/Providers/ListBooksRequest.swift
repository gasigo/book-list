struct ListBooksRequest: Request {
	let method: Method = .get
	let path: String = "/svc/books/v3/lists/best-sellers/history.json"
	let queryParameters: [String: String]

	init(offset: Int) {
		queryParameters = ["offset": offset.description]
	}
}
