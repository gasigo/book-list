import UIKit

public struct NavigationEmbeddingContext: NavigableContext {
	public let navigationController = ObservableNavigationController()
	private let embeddedContext: PresentationContext

	public init(embeddedContext: PresentationContext) {
		self.embeddedContext = embeddedContext
	}

	public func present(_ view: UIViewController) {
		DispatchQueue.main.async {
			self.navigationController.setViewControllers([view], animated: true)
			self.embeddedContext.present(navigationController)
		}
	}

	public func dismiss(_ view: UIViewController) {
		DispatchQueue.main.async {
			self.embeddedContext.dismiss(navigationController)
		}
	}
}
