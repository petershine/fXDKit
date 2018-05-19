

extension UIWindow {
	@objc public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {	fxd_log_func()

		// Exploit that UIWindow is UIView
		guard nibName == nil else {
			let newWindow: UIWindow? = self.view(fromNibName: nibName!, owner: owner) as! UIWindow?
			return newWindow
		}

		
		let screenBounds = UIScreen.main.bounds
		fxdPrint("screenBounds: \(screenBounds)")
		fxdPrint("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds)")
		fxdPrint("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")

		let newWindow: UIWindow? = self.init(frame: screenBounds)
		newWindow?.autoresizesSubviews = true

		return newWindow
	}
}
