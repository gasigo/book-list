import Foundation

protocol Task {
	/// Cancels the task.
	func cancel()

	/// Resumes the task, if it is suspended.
	func resume()

	/// Temporarily suspends a task.
	func suspend()
}

extension URLSessionDataTask: Task {}

struct EmptyTask: Task {
	func cancel() {}
	func resume() {}
	func suspend() {}
}
