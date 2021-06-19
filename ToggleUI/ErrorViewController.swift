import UIKit

public final class ErrorViewController: UIViewController {
	private let errorTitle: String
	private let errorMessage: String

	public init(error: Error) {
		self.errorTitle = error.title
		self.errorMessage = error.message

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	public override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .white

		let titleLabel = UILabel(text: errorTitle)
			.style(font: .systemFont(ofSize: 24), color: .black)
			.layout(lines: 0, alignment: .center)
		let messageLabel = UILabel(text: errorMessage)
			.style(font: .systemFont(ofSize: 14), color: .black)
			.layout(lines: 0, alignment: .center)
		let stack = UIStackView()
			.centralizing([titleLabel, messageLabel], with: .height)
			.configured(axis: .vertical)
			.with(spacing: 14)

		view.addSubview(stack)
		stack.autoPinEdgesToSuperviewEdges(with: .horizontal(20) + .vertical(8))
    }
}
