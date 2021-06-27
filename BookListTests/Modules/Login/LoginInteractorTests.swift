import ToggleFoundation
import XCTest
@testable import BookList

final class LoginInteractorTests: XCTestCase {
	private var loginProviderSpy: LoginProviderSpy!
	private var loginDelegateSpy: LoginDelegateSpy!
	private var routerSpy: LoginRouterSpy!
	private var sut: LoginInteractor!

	override func setUp() {
		loginProviderSpy = LoginProviderSpy()
		loginDelegateSpy = LoginDelegateSpy()
		routerSpy = LoginRouterSpy()

		initializeSUTAndReset()
	}

	private func initializeSUTAndReset() {
		loginProviderSpy.getAvailableBiometryResponse = .faceID
		sut = LoginInteractor(loginProvider: loginProviderSpy, delegate: loginDelegateSpy)

		let spies: [Spy] = [loginProviderSpy, loginDelegateSpy, routerSpy]
		spies.forEach { $0.reset() }
	}

	private func startSUTAndReset() {
		sut.start(router: routerSpy)

		let spies: [Spy] = [loginProviderSpy, loginDelegateSpy, routerSpy]
		spies.forEach { $0.reset() }
	}
}

// MARK: - Init Tests

extension LoginInteractorTests {
	func test_init_withFaceIDAvailable_shouldUpdateStateToFaceID() {
		// given
		loginProviderSpy.getAvailableBiometryResponse = .faceID

		// when
		sut = LoginInteractor(loginProvider: loginProviderSpy, delegate: loginDelegateSpy)

		// then
		XCTAssertEqual(loginProviderSpy.getAvailableBiometryCounter, 1)
		XCTAssertEqual(sut.state.availableBiometry, .faceID)
	}

	func test_init_withTouchIDAvailable_shouldUpdateStateToTouchID() {
		// given
		loginProviderSpy.getAvailableBiometryResponse = .touchID

		// when
		sut = LoginInteractor(loginProvider: loginProviderSpy, delegate: loginDelegateSpy)

		// then
		XCTAssertEqual(loginProviderSpy.getAvailableBiometryCounter, 1)
		XCTAssertEqual(sut.state.availableBiometry, .touchID)
	}

	func test_init_withNoBiometryAvailable_shouldUpdateStateToNone() {
		// given
		loginProviderSpy.getAvailableBiometryResponse = BiometryAuthenticationType.none

		// when
		sut = LoginInteractor(loginProvider: loginProviderSpy, delegate: loginDelegateSpy)

		// then
		XCTAssertEqual(loginProviderSpy.getAvailableBiometryCounter, 1)
		XCTAssertEqual(sut.state.availableBiometry, .none)
	}
}

// MARK: - Login Tests

extension LoginInteractorTests {
	func test_login_withWorkingAuthentication_shouldNotifyDelegate() {
		// given
		loginProviderSpy.authenticateResponse = Promise(value: ())

		// when
		sut.login()

		// then
		XCTAssertEqual(loginProviderSpy.authenticateCounter, 1)
		XCTAssertEqual(loginDelegateSpy.didLoginCounter, 1)
	}

	func test_login_withCancelledAuthentication_shouldNotRouteToError() {
		// given
		loginProviderSpy.authenticateResponse = Promise(error: CustomError.autheticationCanceled)

		// when
		sut.login()

		// then
		XCTAssertEqual(loginProviderSpy.authenticateCounter, 1)
		XCTAssertEqual(routerSpy.routeToErrorCounter, 0)
	}

	func test_login_withFailedAuthenticationAndStartWasCalled_shouldRouteToError() {
		// given
		startSUTAndReset()
		loginProviderSpy.authenticateResponse = Promise(error: CustomError.testError)

		// when
		sut.login()

		// then
		XCTAssertEqual(loginProviderSpy.authenticateCounter, 1)
		XCTAssertEqual(routerSpy.routeToErrorCounter, 1)
	}
}
