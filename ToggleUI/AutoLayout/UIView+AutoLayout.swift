import UIKit

public extension UIView {
	// MARK: - Center & Align in superview

	@discardableResult
	func autoCenterInSuperview() -> [NSLayoutConstraint] {
		[
			autoAlignAxis(toSuperviewAxis: .horizontal),
			autoAlignAxis(toSuperviewAxis: .vertical)
		]
	}

	@discardableResult
	func autoAlignAxis(toSuperviewAxis axis: ALAxis) -> NSLayoutConstraint {
		autoConstrainAttribute(axis.attribute(), to: axis.attribute(), of: superview!)
	}

	// MARK: - Pin edges to superview

	@discardableResult
	func autoPinEdge(
		toSuperviewEdge edge: ALEdge,
		withInset: CGFloat = 0,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		autoPinEdge(
			edge,
			to: edge,
			of: superview!,
			withOffset: edge.isInverted() ? -withInset : withInset,
			relation: edge.isInverted() ? relation.inverted() : relation
		)
	}

	@discardableResult
	func autoPinEdgesToSuperviewEdges(
		with insets: UIEdgeInsets = .zero,
		excludingEdge edge: ALEdge? = nil
	) -> [NSLayoutConstraint] {
		[
			edge != .top ? autoPinEdge(toSuperviewEdge: .top, withInset: insets.top) : nil,
			edge != .left ? autoPinEdge(toSuperviewEdge: .left, withInset: insets.left) : nil,
			edge != .bottom ? autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom) : nil,
			edge != .right ? autoPinEdge(toSuperviewEdge: .right, withInset: insets.right) : nil
		].compactMap { $0 }
	}

	@discardableResult
	func autoPinEdge(toSuperviewMargin edge: ALMargin) -> NSLayoutConstraint {
		autoConstrainAttribute(edge.attribute(), to: edge.attribute(), of: superview!)
	}

	// MARK: - Pin edges

	@discardableResult
	func autoPinEdge(
		_ edge: ALEdge,
		to: ALEdge,
		of view: UIView,
		withOffset offset: CGFloat = 0,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		autoConstrainAttribute(
			edge.attribute(),
			to: to.attribute(),
			of: view,
			withOffset: offset,
			relation: relation
		)
	}

	// MARK: - Align axes

	@discardableResult
	func autoAlignAxis(
		_ axis: ALAxis,
		toSameAxisOf view: UIView,
		withOffset offset: CGFloat = 0,
		withMultiplier multiplier: CGFloat = 1
	) -> NSLayoutConstraint {
		autoConstrainAttribute(
			axis.attribute(),
			to: axis.attribute(),
			of: view,
			withOffset: offset,
			withMultiplier: multiplier
		)
	}

	// MARK: - Match dimensions

	@discardableResult
	func autoMatch(
		_ dimension: ALDimension,
		to: ALDimension,
		of view: UIView,
		withOffset offset: CGFloat = 0,
		withMultiplier multiplier: CGFloat = 1,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		autoConstrainAttribute(
			dimension.attribute(),
			to: to.attribute(),
			of: view,
			withOffset: offset,
			withMultiplier: multiplier,
			relation: relation
		)
	}

	// MARK: - Set dimensions

	@discardableResult
	func autoSetDimension(
		_ dimension: ALDimension,
		toSize: CGFloat,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(
			item: self,
			attribute: dimension.attribute(),
			relatedBy: relation,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: toSize
		)
		constraint.priority = NSLayoutConstraint.currentPriority.last!
		constraint.isActive = true
		return constraint
	}

	@discardableResult
	func autoSetDimensions(to size: CGSize) -> [NSLayoutConstraint] {
		[
			autoSetDimension(.width, toSize: size.width),
			autoSetDimension(.height, toSize: size.height)
		]
	}

	// MARK: - Constrain any attributes

	@discardableResult
	func autoConstrainAttribute(
		_ attribute: NSLayoutConstraint.Attribute,
		to toAttribute: NSLayoutConstraint.Attribute,
		of otherView: UIView,
		withOffset offset: CGFloat = 0,
		withMultiplier multiplier: CGFloat = 1,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(
			item: self,
			attribute: attribute,
			relatedBy: relation,
			toItem: otherView,
			attribute: toAttribute,
			multiplier: multiplier,
			constant: offset
		)
		constraint.priority = NSLayoutConstraint.currentPriority.last!
		constraint.isActive = true
		return constraint
	}

	// MARK: - Pin to layout guides

	@discardableResult
	func autoPin(
		toTopLayoutGuideOf viewController: UIViewController,
		withInset: CGFloat = 0,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(
			item: self,
			attribute: .top,
			relatedBy: relation,
			toItem: viewController.view.safeAreaLayoutGuide,
			attribute: .bottom,
			multiplier: 1,
			constant: withInset
		)
		constraint.priority = NSLayoutConstraint.currentPriority.last!
		constraint.isActive = true
		return constraint
	}

	@discardableResult
	func autoPin(
		toBottomLayoutGuideOf viewController: UIViewController,
		withInset: CGFloat = 0,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(
			item: self,
			attribute: .bottom,
			relatedBy: relation.inverted(),
			toItem: viewController.view.safeAreaLayoutGuide,
			attribute: .top,
			multiplier: 1,
			constant: -withInset
		)
		constraint.priority = NSLayoutConstraint.currentPriority.last!
		constraint.isActive = true
		return constraint
	}
}
