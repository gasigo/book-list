import Foundation
import ToggleCore
import ToggleUI

final class RootRouter: AbstractRouter<RootComponent>, RootRouting {
	func routeToHome(configuration: NetworkConfiguration) {
		detachAll()

		DispatchQueue.main.async {
			let rootContext = WindowRootPresentationContext(window: self.component.window)
			let context = NavigationEmbeddingContext(embeddedContext: rootContext)
			let booksRouter = self.component.booksBuilder.build(
				args: BooksArgs(presentationContext: context, networkConfiguration: configuration)
			)
			self.attach(child: booksRouter, identifier: .books)
		}
	}

	func routeToLogin(delegate: LoginDelegate) {
		let rootContext = WindowRootPresentationContext(window: component.window)
		let context = NavigationEmbeddingContext(embeddedContext: rootContext)
		let loginRouter = component.loginBuilder.build(
			args: LoginArgs(presentationContext: context, delegate: delegate)
		)
		attach(child: loginRouter, identifier: .login)
	}

	func routeToError(with error: Error) {
		let context = WindowRootPresentationContext(window: component.window)

		DispatchQueue.main.async {
			let errorRouter = AnyRouter()
				.presenting(view: ErrorViewController(error: error), using: context)
			self.attach(child: errorRouter, identifier: .error)
		}
	}

	func routeToDebugMenu() {
		DispatchQueue.main.async {
			let debugMenuRouter = self.component.debugMenuBuilder.build(args: ())
			self.attach(child: debugMenuRouter, identifier: .debugMenu)
		}
	}
}

private extension ChildIdentifier {
	static let books: ChildIdentifier = "Books"
	static let login: ChildIdentifier = "Login"
	static let error: ChildIdentifier = "Error"
	static let debugMenu: ChildIdentifier = "Debug Menu"
}
