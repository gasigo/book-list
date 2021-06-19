import Foundation
import ToggleCore
import ToggleUI

protocol DebugMenuRouting: AnyObject {
	func showDebugMenu()
	func closeDebugMenu()
}

final class DebugMenuInteractor: Interactor {
	private weak var router: DebugMenuRouting?

	func start(router: DebugMenuRouting) {
		self.router = router
		setupShakeListener()
	}

	func generateCompositionTreeDiagram() {
	}

	func close() {
		router?.closeDebugMenu()
	}

	private func setupShakeListener() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(openDebugMenu),
			name: ToggleWindow.windowDidShake,
			object: nil
		)
	}

	@objc
	private func openDebugMenu() {
		router?.showDebugMenu()
	}
}
