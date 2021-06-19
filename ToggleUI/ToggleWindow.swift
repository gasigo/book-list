import UIKit

public final class ToggleWindow: UIWindow {
	public static let windowDidShake = Notification.Name("com.debugger.present")

	public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard motion == .motionShake else { return }

		NotificationCenter.default.post(name: ToggleWindow.windowDidShake, object: nil)
	}
}
