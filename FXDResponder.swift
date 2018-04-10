

extension UIResponder {
	@objc public func executeOperations(for application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) {	FXDLog_Func()

		guard launchOptions != nil else {
			return
		}


		let url: URL? = launchOptions![UIApplicationLaunchOptionsKey("url")] as? URL
		let sourceApplication = launchOptions![UIApplicationLaunchOptionsKey("sourceApplication")]
		let annotation = launchOptions![UIApplicationLaunchOptionsKey("annotation")]

		guard (url != nil
			|| sourceApplication != nil
			|| annotation != nil) else {
				return
		}


		let openOptions = [UIApplicationOpenURLOptionsKey("sourceApplication") : sourceApplication!,
						   UIApplicationOpenURLOptionsKey("annotation"):annotation!]

		if let appDelegate = self as? UIApplicationDelegate {
			_ = appDelegate.application!(application, open: url!, options: openOptions)
		}
	}


	@objc public func isUsable(_ launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {	FXDLog_Func()

		guard launchOptions != nil else {
			return false
		}


		let url = launchOptions![UIApplicationLaunchOptionsKey("url")]
		let sourceApplication = launchOptions![UIApplicationLaunchOptionsKey("sourceApplication")]
		let annotation = launchOptions![UIApplicationLaunchOptionsKey("annotation")]
		let remoteNotification = launchOptions![UIApplicationLaunchOptionsKey("remoteNotification")]

		guard (url != nil
			|| sourceApplication != nil
			|| annotation != nil
			|| remoteNotification != nil) else {
				return false
		}

		return true
	}
}
