import UIKit

public enum ALEdge {
	case top, left, bottom, right, leading, trailing

	func isInverted() -> Bool {
		self == .right || self == .bottom || self == .trailing
	}

	func attribute() -> NSLayoutConstraint.Attribute {
		switch self {
		case .top: return .top
		case .left: return .left
		case .bottom: return .bottom
		case .right: return .right
		case .leading: return .leading
		case .trailing: return .trailing
		}
	}
}

public enum ALMargin {
	case top, left, bottom, right

	func attribute() -> NSLayoutConstraint.Attribute {
		switch self {
		case .top: return .topMargin
		case .left: return .leftMargin
		case .bottom: return .bottomMargin
		case .right: return .rightMargin
		}
	}
}

public enum ALDimension {
	case width, height

	func attribute() -> NSLayoutConstraint.Attribute {
		switch self {
		case .width: return .width
		case .height: return .height
		}
	}
}

public enum ALAxis {
	case vertical, horizontal, firstBaseline, lastBaseline

	func attribute() -> NSLayoutConstraint.Attribute {
		switch self {
		case .vertical: return .centerX
		case .horizontal: return .centerY
		case .firstBaseline: return .firstBaseline
		case .lastBaseline: return .lastBaseline
		}
	}
}
