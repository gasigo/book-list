@testable import BookList

final class LoginDelegateSpy: LoginDelegate, Spy {
	var didLoginCounter = 0
	func didLogin() {
		didLoginCounter += 1
	}

	func reset() {
		didLoginCounter = 0
	}
}
