import UIKit

/// Presents a modal view controller in a new window atop an existing one.
public struct FullWindowPresentationContext: CancelablePresentationContext {
	private let window = UIWindow(frame: UIScreen.main.bounds)
	private let adaptedContext: ClosableModalPresentationContext

	public init(sourceWindow: UIWindow, closed: @escaping () -> Void) {
		window.windowLevel = sourceWindow.windowLevel + 0.1
		window.rootViewController = UIViewController()
		adaptedContext = ClosableModalPresentationContext(
			source: window.rootViewController!,
			closed: closed
		)
	}

	public func present(_ view: UIViewController) {
		window.makeKeyAndVisible()
		adaptedContext.present(view)
	}

	public func dismiss(_ view: UIViewController) {
		adaptedContext.dismiss(view)
	}

	public func cancelPresentation() {
		adaptedContext.cancelPresentation()
	}
}
