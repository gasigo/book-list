import ToggleCore
import UIKit

struct RootComponentImpl: RootComponent {
	let window: UIWindow
	var configurationProvider: ConfigurationProvider { ConfigurationProviderImpl() }
	var loginProvider: LoginProvider { LoginProviderImpl(userDefaults: .standard) }

	var loginBuilder: ScopedBuilder<LoginArgs> {
		LoginBuilder().scoped {
			LoginComponentImpl(
				parent: self,
				presentationContext: $0.presentationContext,
				delegate: $0.delegate
			)
		}
	}

	var booksBuilder: ScopedBuilder<BooksArgs> {
		BooksBuilder().scoped {
			BooksComponentImpl(
				parent: self,
				networkService: NetworkServiceImpl(
					session: .shared,
					configuration: $0.networkConfiguration
				),
				presentationContext: $0.presentationContext
			)
		}
	}

	var debugMenuBuilder: ScopedBuilder<Void> {
		DebugMenuBuilder().scoped {
			DebugMenuComponentImpl(parent: self)
		}
	}
}
