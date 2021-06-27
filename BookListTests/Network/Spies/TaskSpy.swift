@testable import BookList

final class TaskSpy: Task {
	var cancelCounter = 0
	func cancel() {
		cancelCounter += 1
	}

	var resumeCounter = 0
	func resume() {
		resumeCounter += 1
	}

	var suspendCounter = 0
	func suspend() {
		suspendCounter += 1
	}
}
