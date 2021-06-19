import ToggleCore
import UIKit

protocol RootComponent {
	var window: UIWindow { get }
	var configurationProvider: ConfigurationProvider { get }
	var loginProvider: LoginProvider { get }

	var loginBuilder: ScopedBuilder<LoginArgs> { get }
	var booksBuilder: ScopedBuilder<BooksArgs> { get }
	var debugMenuBuilder: ScopedBuilder<Void> { get }
}

struct RootBuilder: Builder {
	func build(component: RootComponent) -> Router {
		let interactor = RootInteractor(
			configurationProvider: component.configurationProvider,
			loginProvider: component.loginProvider
		)

		return RootRouter(component: component)
			.routing(for: interactor)
	}
}
