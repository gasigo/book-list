import ToggleFoundation
import UIKit

public final class ObservableNavigationController: UINavigationController {
	public override var childForStatusBarStyle: UIViewController? {
		topViewController
	}

	public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.portrait
	}

	public override var delegate: UINavigationControllerDelegate? {
		didSet {
			if delegate !== self {
				externalDelegate = delegate
				delegate = self
			}
		}
	}

	private var isPushingViewController = false
	private var navigationBarStyleObserver: NSObject?
	private weak var externalDelegate: UINavigationControllerDelegate?
	private var previousViewControllers = [UIViewController]()
	private let changeObservers = ObserverList<UINavigationController>()

	public init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func observeStackChanges(context: AnyObject?, observer: @escaping (UINavigationController) -> Void) {
		changeObservers.append(context: context, observer: observer)
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		interactivePopGestureRecognizer?.delegate = self
	}

	public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		isPushingViewController = true
		super.pushViewController(viewController, animated: animated)
		if viewControllers.count == 1 {
			// does not call didShowViewController, so we need to notify observers manually
			changeObservers.notify(of: self)
		}
	}

	public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		isPushingViewController = true
		super.setViewControllers(viewControllers, animated: animated)
	}

	private func setShadowImage(_ image: UIImage?) {
		  let appearance = UINavigationBarAppearance()
		  appearance.shadowImage = image
		  appearance.backgroundEffect = nil
		  navigationBar.standardAppearance = appearance
	}
}

extension ObservableNavigationController: UIGestureRecognizerDelegate {
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
		return viewControllers.count > 1 && !isPushingViewController
	}
}

extension ObservableNavigationController: UINavigationControllerDelegate {
	public func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		isPushingViewController = false
		externalDelegate?.navigationController?(
			navigationController,
			didShow: viewController,
			animated: animated
		)

		if viewControllers != previousViewControllers {
			changeObservers.notify(of: self)
		}
		previousViewControllers = viewControllers
	}

	public func navigationController(
		_ navigationController: UINavigationController,
		willShow viewController: UIViewController,
		animated: Bool
	) {
		externalDelegate?.navigationController?(
			navigationController,
			willShow: viewController,
			animated: animated
		)
	}

	public func navigationControllerSupportedInterfaceOrientations(
		_ navigationController: UINavigationController
	) -> UIInterfaceOrientationMask {
		externalDelegate?.navigationControllerSupportedInterfaceOrientations?(navigationController)
			?? visibleViewController?.supportedInterfaceOrientations
			?? .all
	}

	public func navigationControllerPreferredInterfaceOrientationForPresentation(
		_ navigationController: UINavigationController
	) -> UIInterfaceOrientation {
		externalDelegate?
			.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController)
			?? .portrait
	}

	public func navigationController(
		_ navigationController: UINavigationController,
		interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? {
		externalDelegate?.navigationController?(
			navigationController,
			interactionControllerFor: animationController
		)
	}

	public func navigationController(
		_ navigationController: UINavigationController,
		animationControllerFor operation: UINavigationController.Operation,
		from fromVC: UIViewController,
		to toVC: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		externalDelegate?.navigationController?(
			navigationController,
			animationControllerFor: operation,
			from: fromVC,
			to: toVC
		)
	}
}

private final class ClosureObserver<T>: NSObject {
	private let observable: NSObject
	private let keyPath: String
	private let closure: (T) -> Void

	init(observable: NSObject, keyPath: String, closure: @escaping (T) -> Void) {
		self.observable = observable
		self.keyPath = keyPath
		self.closure = closure
		super.init()
		observable.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)
	}

	override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey: Any]?,
		context: UnsafeMutableRawPointer?
	) {
		closure(change![.newKey] as! T)
	}

	deinit {
		observable.removeObserver(self, forKeyPath: keyPath)
	}
}
