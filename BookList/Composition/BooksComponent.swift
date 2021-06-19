import ToggleCore

struct BooksComponentImpl: BooksComponent {
	let parent: RootComponentImpl
	let networkService: NetworkService
	let presentationContext: NavigableContext

	var bookProvider: BookProvider {
		BookProviderImpl(networkService: networkService)
	}
}
