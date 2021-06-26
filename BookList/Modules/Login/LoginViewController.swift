import ToggleUI
import UIKit

final class LoginViewController: UIViewController {
	private let interactor: LoginInteractor
	private let state: LoginViewState

	init(interactor: LoginInteractor, state: LoginViewState) {
		self.interactor = interactor
		self.state = state
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		setupUI()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	private func setupUI() {
		let equalSpacer1 = UIView()
		let equalSpacer2 = UIView()
		let title = UILabel(text: state.title)
			.style(font: .systemFont(ofSize: 24), color: .black)
			.layout(lines: 0, alignment: .center)
		let subtitle = UILabel(text: state.subtitle)
			.style(font: .systemFont(ofSize: 16), color: .black)
			.layout(lines: 0, alignment: .center)
		let loginButton = makeAuthenticateButton()
		let authenticationIcon = UIImageView(image: UIImage(named: state.authenticationImageName))
		authenticationIcon.contentMode = .scaleAspectFit

		let stack = UIStackView()
			.containing(
				[
					equalSpacer1,
					title,
					.spacer(height: 8),
					subtitle,
					.spacer(height: 60),
					authenticationIcon,
					.spacer(height: 60),
					loginButton,
					equalSpacer2
				]
			)
			.configured(axis: .vertical)

		view.addSubview(stack)
		equalSpacer1.autoMatch(.height, to: .height, of: equalSpacer2)
		authenticationIcon.autoSetDimensions(to: CGSize(width: 64, height: 64))
		stack.autoPinEdgesToSuperviewEdges(with: .horizontal(30) + .vertical(8))
	}

	private func makeAuthenticateButton() -> UIButton {
		let button = UIButton(frame: .zero)
		button.setTitle(state.actionTitle, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		button.backgroundColor = .blue
		button.clipsToBounds = true
		button.layer.cornerRadius = 8
		_ = button.on(.touchUpInside) { [weak self] _ in
			self?.interactor.login()
		}
		button.autoSetDimension(.height, toSize: 44)
		return button
	}
}
