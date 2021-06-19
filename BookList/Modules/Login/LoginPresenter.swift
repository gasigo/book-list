struct LoginViewState {
	let title: String
	let subtitle: String
	let actionTitle: String
	let authenticationImageName: String
}

struct LoginPresenter {
	func format(state: LoginInteractor.State) -> LoginViewState {
		LoginViewState(
			title: "Sign up to see our book list",
			subtitle: "Use \(state.availableBiometry.name) to authenticate",
			actionTitle: "Authenticate",
			authenticationImageName: state.availableBiometry.iconName
		)
	}
}

extension BiometryAuthenticationType {
	var name: String {
		switch self {
		case .faceID: return "Face ID"
		case .touchID: return "Touch ID"
		case .none: return "Passcode"
		}
	}

	var iconName: String {
		switch self {
		case .faceID: return "faceID"
		case .touchID: return "touchID"
		case .none: return "key"
		}
	}
}
