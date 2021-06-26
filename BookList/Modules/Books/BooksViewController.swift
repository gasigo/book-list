import ToggleFoundation
import ToggleUI
import UIKit

final class BooksViewController: UIViewController {
	private let interactor: BooksInteractor
	private let state: Property<BooksViewState>
	private let tableView: UITableView
	private var currentAttachedView: UIView?
	private var books: [BooksViewState.BookCell] = []

	init(interactor: BooksInteractor, state: Property<BooksViewState>) {
		self.interactor = interactor
		self.state = state
		tableView = UITableView(frame: .zero)

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		title = state.value.title
		setupTableView()
		state.subscribe(context: self) { [weak self] state in
			DispatchQueue.main.async {
				self?.updateUI(with: state)
			}
		}
    }

	private func updateUI(with state: BooksViewState) {
		tableView.tableFooterView = makeLoadingFooter()
		setFooterHidden(true)

		switch state.content {
		case let .loaded(books):
			displayBookList(books: books)
		case let .loading(message):
			displayLoading(message: message)
		case .loadingMorePages:
			setFooterHidden(false)
		case let .failed(error):
			tableView.setAutoLayoutFooterView(makeErrorFooter(error: error))
			setFooterHidden(false)
		case let .failedToLoadFirstPage(error):
			displayError(error)
		}
	}

	private func displayBookList(books: [BooksViewState.BookCell]) {
		self.books = books
		attachView(tableView)
		tableView.reloadData()
	}

	private func displayLoading(message: String) {
		attachView(LoadingView(message: message))
	}

	private func displayError(_ error: Error) {
		attachView(
			ErrorView(
				error: error,
				retry: { [weak self] in
					self?.interactor.retry()
				}
			)
		)
	}

	private func attachView(_ content: UIView) {
		guard currentAttachedView != content else { return }
		currentAttachedView?.removeFromSuperview()
		view.insertSubview(content, at: 0)
		content.autoPinEdgesToSuperviewEdges()
		currentAttachedView = content
	}

	private func setupTableView() {
		tableView.registerClass(BookCell.self)
		tableView.separatorStyle = .none
		tableView.separatorInset = .vertical(5)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.allowsMultipleSelection = true
		tableView.delegate = self
		tableView.dataSource = self
	}

	private func setFooterHidden(_ isHidden: Bool) {
		tableView.tableFooterView?.isHidden = isHidden
	}

	private func makeLoadingFooter() -> UIView {
		let spinner = UIActivityIndicatorView(style: .medium)
		spinner.startAnimating()
		return spinner
	}

	private func makeErrorFooter(error: Error) -> UIView {
		let messageLabel = UILabel(text: error.message)
			.style(font: .systemFont(ofSize: 14), color: .black)
			.layout(lines: 0, alignment: .center)
		let retryButton = UIButton()
		retryButton.setTitle("Retry", for: .normal)
		retryButton.setTitleColor(.blue, for: .normal)
		retryButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
		_ = retryButton.on(.touchUpInside) { [weak self] _ in
			self?.interactor.retry()
		}

		return UIStackView()
			.containing([messageLabel, retryButton])
			.configured(axis: .vertical)
			.with(margins: .horizontal(18) + .vertical(4), spacing: 4)
	}
}

extension BooksViewController: UITableViewDataSource {
	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		books.count
	}

	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell: BookCell = tableView.dequeue(indexPath)
		cell.update(with: books[indexPath.row])
		return cell
	}

	func tableView(
		_ tableView: UITableView,
		willDisplay cell: UITableViewCell,
		forRowAt indexPath: IndexPath
	) {
		if indexPath.row == books.count - 1 {
			setFooterHidden(false)
			interactor.loadMoreBooks()
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.3) {
			tableView.performBatchUpdates(nil)
		}
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.3) {
			tableView.performBatchUpdates(nil)
		}
	}
}

extension BooksViewController: UITableViewDelegate {}

private final class LoadingView: UIView {
	init(message: String) {
		super.init(frame: .zero)

		let spinner = UIActivityIndicatorView(style: .large)
		let messageLabel = UILabel(text: message)
			.style(font: .systemFont(ofSize: 14), color: .black)
			.layout(lines: 0, alignment: .center)
		let stack = UIStackView()
			.centralizing([spinner, messageLabel], with: .height)
			.configured(axis: .vertical)
			.with(margins: .horizontal(20), spacing: 8)

		addSubview(stack)
		spinner.startAnimating()
		stack.autoPinEdgesToSuperviewEdges()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private final class ErrorView: UIView {
	init(error: Error, retry: @escaping () -> Void) {
		super.init(frame: .zero)

		let titleLabel = UILabel(text: error.title)
			.style(font: .systemFont(ofSize: 16, weight: .bold), color: .black)
			.layout(lines: 0, alignment: .center)
		let messageLabel = UILabel(text: error.message)
			.style(font: .systemFont(ofSize: 14), color: .black)
			.layout(lines: 0, alignment: .center)
		let retryButton = UIButton()
		retryButton.setTitle("Retry", for: .normal)
		retryButton.setTitleColor(.blue, for: .normal)
		retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
		_ = retryButton.on(.touchUpInside) { _ in retry() }
		let stack = UIStackView()
			.centralizing([titleLabel, messageLabel, retryButton], with: .height)
			.configured(axis: .vertical)
			.with(margins: .horizontal(20), spacing: 8)

		addSubview(stack)
		stack.autoPinEdgesToSuperviewEdges()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
