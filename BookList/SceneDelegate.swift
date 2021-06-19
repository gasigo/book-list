import ToggleCore
import ToggleUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	private var rootRouter: Router?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let window = ToggleWindow(windowScene: windowScene)
		self.window = window
		window.makeKeyAndVisible()
		self.rootRouter = buildCompositionTree(window: window)
		_ = rootRouter?.start()
	}

	private func buildCompositionTree(window: UIWindow) -> Router {
		RootBuilder().build(component: RootComponentImpl(window: window))
	}
}
