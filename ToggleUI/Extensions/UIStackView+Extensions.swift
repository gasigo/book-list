import UIKit

public extension UIStackView {
	func replaceSubviews(with views: [UIView]) {
		for subview in arrangedSubviews {
			removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}

		for subview in views {
			addArrangedSubview(subview)
		}
	}

	func containing(_ arrangedSubviews: [UIView]) -> Self {
		replaceSubviews(with: arrangedSubviews)
		return self
	}

	func centralizing(_ subviews: [UIView], with dimension: ALDimension) -> Self {
		let equalSpacer1 = UIView()
		let equalSpacer2 = UIView()
		replaceSubviews(with: [equalSpacer1] + subviews + [equalSpacer2])
		equalSpacer1.autoMatch(dimension, to: dimension, of: equalSpacer2)
		return self
	}

	func configured(
		axis: NSLayoutConstraint.Axis? = nil,
		alignment: UIStackView.Alignment? = nil,
		distribution: UIStackView.Distribution? = nil
	) -> Self {
		axis.map { self.axis = $0 }
		alignment.map { self.alignment = $0 }
		distribution.map { self.distribution = $0 }
		return self
	}

	func with(
		margins: UIEdgeInsets? = nil,
		relativeToSafeArea: Bool = true,
		spacing: CGFloat? = nil
	) -> Self {
		if let margins = margins {
			isLayoutMarginsRelativeArrangement = true
			layoutMargins = margins
			insetsLayoutMarginsFromSafeArea = relativeToSafeArea
		}
		spacing.map { self.spacing = $0 }
		return self
	}
}
