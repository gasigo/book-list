import ToggleFoundation
import XCTest
@testable import BookList

final class RootInteractorTests: XCTestCase {
	private var configurationProviderSpy: ConfigurationProviderSpy!
	private var loginProviderSpy: LoginProviderSpy!
	private var routerSpy: RootRouterSpy!
	private var sut: RootInteractor!

	override func setUp() {
		configurationProviderSpy = ConfigurationProviderSpy()
		loginProviderSpy = LoginProviderSpy()
		routerSpy = RootRouterSpy()
		sut = RootInteractor(
			configurationProvider: configurationProviderSpy,
			loginProvider: loginProviderSpy
		)
	}

	private func startSUTAndReset() {
		loginProviderSpy.isUserAuthenticatedResponse = false
		sut.start(router: routerSpy)

		let spies: [Spy] = [configurationProviderSpy, loginProviderSpy, routerSpy]
		spies.forEach { $0.reset() }
	}
}

// MARK: - Start Tests

extension RootInteractorTests {
	func test_start_withWorkingConfigurationProviderAndAuthenticatedUser_shouldRouteToHome() {
		// given
		let dummyConfiguration = NetworkConfiguration(baseURL: "test", apiKey: "test")
		configurationProviderSpy.getConfigurationResponse = dummyConfiguration
		loginProviderSpy.isUserAuthenticatedResponse = true

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(loginProviderSpy.isUserAuthenticatedCounter, 1)
		XCTAssertEqual(configurationProviderSpy.getConfigurationCounter, 1)
		XCTAssertEqual(routerSpy.routeToHomeCounter, 1)
	}

	func test_start_withFailingConfigurationProviderAndAuthenticatedUser_shouldRouteToError() {
		// given
		configurationProviderSpy.getConfigurationError = CustomError.testError
		loginProviderSpy.isUserAuthenticatedResponse = true

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(configurationProviderSpy.getConfigurationCounter, 1)
		XCTAssertEqual(routerSpy.routeToErrorCounter, 1)
	}

	func test_start_withNonAuthenticatedUser_shouldRouteToLogin() {
		// given
		loginProviderSpy.isUserAuthenticatedResponse = false

		// when
		sut.start(router: routerSpy)

		// then
		XCTAssertEqual(loginProviderSpy.isUserAuthenticatedCounter, 1)
		XCTAssertEqual(routerSpy.routeToLoginCounter, 1)
	}
}

// MARK: - Did Login Tests

extension RootInteractorTests {
	func test_didLogin_withWorkingConfigurationProviderAndStartWasCalled_shouldRouteToHome() {
		// given
		startSUTAndReset()
		let dummyConfiguration = NetworkConfiguration(baseURL: "test", apiKey: "test")
		configurationProviderSpy.getConfigurationResponse = dummyConfiguration

		// when
		sut.didLogin()

		// then
		XCTAssertEqual(configurationProviderSpy.getConfigurationCounter, 1)
		XCTAssertEqual(routerSpy.routeToHomeCounter, 1)
	}

	func test_didLogin_withFailingConfigurationProviderAndStartWasCalled_shouldRouteToHome() {
		// given
		startSUTAndReset()
		configurationProviderSpy.getConfigurationError = CustomError.testError

		// when
		sut.didLogin()

		// then
		XCTAssertEqual(configurationProviderSpy.getConfigurationCounter, 1)
		XCTAssertEqual(routerSpy.routeToErrorCounter, 1)
	}
}
