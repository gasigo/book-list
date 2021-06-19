import XCTest
@testable import BookList

final class LoginPresenterTests: XCTestCase {
	private var sut: LoginPresenter!

	override func setUp() {
		sut = LoginPresenter()
	}
}

// MARK: - Format Tests

extension LoginPresenterTests {
	func test_format_withFaceIDAvailable_shouldReturnFaceIDIconAndSubtitle() {
		// given
		let authenticationType = BiometryAuthenticationType.faceID
		let state = LoginInteractor.State(availableBiometry: authenticationType)

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertTrue(viewState.subtitle.contains(authenticationType.name))
		XCTAssertEqual(viewState.authenticationImageName, authenticationType.iconName)
	}

	func test_format_withTouchIDAvailable_shouldReturnTouchIDIconAndSubtitle() {
		// given
		let authenticationType = BiometryAuthenticationType.touchID
		let state = LoginInteractor.State(availableBiometry: authenticationType)

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertTrue(viewState.subtitle.contains(authenticationType.name))
		XCTAssertEqual(viewState.authenticationImageName, authenticationType.iconName)
	}

	func test_format_withNoBiometryAvailable_shouldReturnPasscodeIconAndSubtitle() {
		// given
		let authenticationType = BiometryAuthenticationType.none
		let state = LoginInteractor.State(availableBiometry: authenticationType)

		// when
		let viewState = sut.format(state: state)

		// then
		XCTAssertTrue(viewState.subtitle.contains(authenticationType.name))
		XCTAssertEqual(viewState.authenticationImageName, authenticationType.iconName)
	}
}
