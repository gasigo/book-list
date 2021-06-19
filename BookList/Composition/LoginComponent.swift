import ToggleCore
import UIKit

struct LoginComponentImpl: LoginComponent {
	let parent: RootComponentImpl
	let presentationContext: NavigableContext
	weak var delegate: LoginDelegate?

	var window: UIWindow { parent.window }
	var loginProvider: LoginProvider { parent.loginProvider }
}
