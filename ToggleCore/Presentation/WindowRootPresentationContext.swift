import UIKit

public struct WindowRootPresentationContext: PresentationContext {
	let window: UIWindow

	public init(window: UIWindow) {
		self.window = window
	}

	public func present(_ view: UIViewController) {
		DispatchQueue.main.async {
			self.window.rootViewController = view
		}
	}

	public func dismiss(_ view: UIViewController) {
		// Not dismissable
	}
}
