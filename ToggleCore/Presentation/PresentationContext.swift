import UIKit

public protocol PresentationContext {
	func present(_ view: UIViewController)
	func dismiss(_ view: UIViewController)
}

public protocol NavigableContext: PresentationContext {
	var navigationController: ObservableNavigationController { get }
}

public protocol CancelablePresentationContext: PresentationContext {
	func cancelPresentation()
}

public protocol CancelableNavigableContext: NavigableContext, CancelablePresentationContext {}
