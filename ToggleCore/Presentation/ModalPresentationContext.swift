import ToggleUI
import UIKit

public  struct ModalPresentationContext: PresentationContext {
	private let source: UIViewController

	public init(source: UIViewController) {
		self.source = source
	}

	public func present(_ view: UIViewController) {
		DispatchQueue.main.async {
			self.source.present(view, animated: true)
		}
	}

	public func dismiss(_ view: UIViewController) {
		if source.presentedViewController == view {
			DispatchQueue.main.async {
				self.source.dismiss(animated: true)
			}
		}
	}
}

public class ClosableModalPresentationContext: CancelablePresentationContext {
	private let source: UIViewController
	private let dismissalProxy = ModalDismissalProxy()
	private var closed: (() -> Void)?

	private weak var presentedView: UIViewController?

	public init(source: UIViewController, closed: @escaping () -> Void) {
		self.source = source
		self.closed = closed
		dismissalProxy.didDismissObserver = { [weak self] in
			let closureObserver = self?.closed
			self?.closed = nil
			closureObserver?()
		}
	}

	public func present(_ view: UIViewController) {
		view.presentationController?.delegate = dismissalProxy
		presentedView = view
		source.present(view, animated: true)
	}

	public func dismiss(_ view: UIViewController) {
		if view.presentingViewController != nil,
			view.presentingViewController?.isBeingDismissed == false,
			!view.isBeingDismissed {
			view.presentingViewController?.dismiss(animated: true)
		}
		let closureObserver = closed
		closed = nil
		closureObserver?()
	}

	public func cancelPresentation() {
		presentedView.map(dismiss(_:))
	}
}

public final class ClosableModalNavigationContext: ClosableModalPresentationContext, CancelableNavigableContext {
	public let navigationController = ObservableNavigationController()

	public override func present(_ view: UIViewController) {
		navigationController.setViewControllers([view], animated: true)
		view.navigationItem.leftBarButtonItem = .close { [weak self, weak view] _ in
			view.map { self?.dismiss($0) }
		}
		super.present(navigationController)
	}

	public override func dismiss(_ view: UIViewController) {
		super.dismiss(navigationController)
	}
}

private final class ModalDismissalProxy: NSObject, UIAdaptivePresentationControllerDelegate {
	var didDismissObserver: (() -> Void)?
	var allowsDismissal = true

	func presentationControllerDidDismiss(_: UIPresentationController) {
		didDismissObserver?()
	}
}

