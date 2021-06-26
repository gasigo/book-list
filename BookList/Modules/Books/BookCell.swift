import ToggleUI
import UIKit

final class BookCell: UITableViewCell {
	private let content = BookCellContentView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		selectionStyle = .none
		contentView.addSubview(content)
		content.autoPinEdgesToSuperviewEdges()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func prepareForReuse() {
		super.prepareForReuse()
		content.reset()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		content.setSelected(selected, animated: animated)
	}

	func update(with book: BooksViewState.BookCell) {
		content.update(with: book, isSelected: isSelected)
	}
}

private final class BookCellContentView: UIView {
	private let titleLabel = UILabel()
		.style(font: .systemFont(ofSize: 15, weight: .semibold), color: .black)
		.layout(lines: 0)
	private let authorLabel = UILabel()
		.style(font: .systemFont(ofSize: 15), color: .black)
		.layout(lines: 0)
	private let descriptionLabel = UILabel()
		.style(font: .systemFont(ofSize: 12), color: .black)
		.layout(lines: 0)
	private let priceLabel = UILabel()
		.style(font: .systemFont(ofSize: 12, weight: .semibold), color: .systemGreen)
		.layout(lines: 0)

	private var book: BooksViewState.BookCell?

	init() {
		super.init(frame: .zero)

		let stack = UIStackView()
			.containing([titleLabel, authorLabel, descriptionLabel, priceLabel])
			.configured(axis: .vertical)
			.with(margins: .vertical(8) + .horizontal(8), spacing: 8)

		let contentView = UIView()
		contentView.addSubview(stack)
		contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
		contentView.clipsToBounds = true
		contentView.layer.cornerRadius = 8

		stack.autoPinEdgesToSuperviewEdges()

		addSubview(contentView)
		contentView.autoPinEdgesToSuperviewEdges(with: .horizontal(18) + .vertical(8))
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func reset() {
		titleLabel.text = nil
		authorLabel.text = nil
		descriptionLabel.text = nil
		priceLabel.text = nil
	}

	func update(with book: BooksViewState.BookCell, isSelected: Bool) {
		self.book = book
		titleLabel.text = book.title
		authorLabel.text = book.author
		priceLabel.text = book.price

		if isSelected {
			descriptionLabel.text = book.description
		} else {
			descriptionLabel.text = book.shortDescription ?? book.description
		}
	}

	func setSelected(_ selected: Bool, animated: Bool) {
		guard let book = book, book.canExpand else { return }

		if !selected {
			descriptionLabel.text = book.shortDescription
		} else {
			descriptionLabel.text = book.description
		}
	}
}
