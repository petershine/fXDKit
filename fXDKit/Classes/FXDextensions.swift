

extension UIApplication {
	@objc public class func mainWindow() -> UIWindow? {
		var mainWindow: UIWindow? = nil

		let appDelegate = self.shared.delegate

		if (appDelegate?.responds(to: #selector(getter: UIApplicationDelegate.window)))! {
			mainWindow = (appDelegate?.window)!
		}

		return mainWindow
	}
}

extension UIStoryboardSegue {
	@objc public func fullDescription() -> Dictionary<String, Any>? {
		var fullDescription: Dictionary<String, Any>? = [:]

		if (self.identifier?.count)! > 0 {
			fullDescription!["identifier"] = self.identifier!
		}

		fullDescription!["source"] = self.source
		fullDescription!["destination"] = self.destination
		fullDescription!["class"] = self.description
		
		return fullDescription
	}
}

extension UIAlertController {
	@objc public class func simpleAlert(withTitle title: String?, message: String?) {
		self.simpleAlert(withTitle: title,
		                 message: message,
		                 cancelText: nil,
		                 fromScene: nil,
		                 handler: nil)
	}

	@objc public class func simpleAlert(withTitle title: String?, message: String?,
	                             cancelText: String?,
	                             fromScene: UIViewController?,
	                             handler: ((UIAlertAction) -> Swift.Void)?) {

		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: ((cancelText != nil) ? cancelText! : NSLocalizedString("OK", comment: "")),
		                                 style: .cancel,
		                                 handler: handler)

		alert.addAction(cancelAction)


		var presentingScene: UIViewController? = fromScene

		if presentingScene == nil {

			// Traverse to find the right presentingScene (live rootViewController in the most front window)
			for window in UIApplication.shared.windows.reversed() {
				if window != UIApplication.shared.keyWindow {
					continue
				}

				
				if window.rootViewController != nil {
					presentingScene = window.rootViewController!
					break
				}
			}
		}

		DispatchQueue.main.async {
			presentingScene?.present(alert,
			                         animated: true,
			                         completion: nil)
		}
	}
}
