import ToggleCore
import UIKit

struct DebugMenuComponentImpl: DebugMenuComponent {
	let parent: RootComponentImpl

	var window: UIWindow {
		parent.window
	}
}
