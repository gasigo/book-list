import UIKit

public extension UILabel {
	convenience init(text: String?) {
		self.init(frame: .zero)
		self.text = text
	}

	@discardableResult
	func style(font: UIFont, color: UIColor) -> Self {
		self.font = font
		textColor = color
		return self
	}

	func layout(lines: Int? = nil, alignment: NSTextAlignment? = nil) -> Self {
		lines.map { numberOfLines = $0 }
		alignment.map { textAlignment = $0 }
		return self
	}
}
