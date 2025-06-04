import Foundation
import UIKit

extension UIResponder {
	@objc public func executeOperations(for application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {	fxd_log()

		guard launchOptions != nil else {
			return
		}

		let url: URL? = launchOptions![.url] as? URL
		let sourceApplication = launchOptions![.sourceApplication]

		guard url != nil
			|| sourceApplication != nil else {
				return
		}

		let openOptions: [UIApplication.OpenURLOptionsKey: Any]
			= [.sourceApplication: sourceApplication!]

		if let appDelegate = self as? UIApplicationDelegate {
			_ = appDelegate.application!(application, open: url!, options: openOptions)
		}
	}

	@objc public func isUsable(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {	fxd_log()

		guard launchOptions != nil else {
			return false
		}

		let url = launchOptions![.url]
		let sourceApplication = launchOptions![.sourceApplication]
		let remoteNotification = launchOptions![.remoteNotification]

		guard url != nil
			|| sourceApplication != nil
			|| remoteNotification != nil else {
				return false
		}

		return true
	}
}
