import UIKit

final class DebugMenuViewController: UITableViewController {
	private let interactor: DebugMenuInteractor

	private lazy var items: [(title: String, action: () -> Void)] = {
		[
			(
				title: "🖨 Generate Composition Tree Diagram",
				action: interactor.generateCompositionTreeDiagram
			)
		]
	}()

	init(interactor: DebugMenuInteractor) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)

		title = "Debug menu"
		navigationItem.leftBarButtonItem = .close { [weak self] _ in
			self?.interactor.close()
		}
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.tableFooterView = UIView(frame: .zero)
		tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
		tableView.reloadData()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)

		cell.textLabel?.text = item.title

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		items[indexPath.row].action()
	}
}

private final class TableViewCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.font = .systemFont(ofSize: 17)
		textLabel?.numberOfLines = 0
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
