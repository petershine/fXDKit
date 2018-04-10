

extension UIWindow {
	@objc public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {	FXDLog_Func()

		// Exploit that UIWindow is UIView
		guard nibName == nil else {
			let newWindow: UIWindow? = self.view(fromNibName: nibName!, owner: owner) as! UIWindow?
			return newWindow
		}

		
		let screenBounds = UIScreen.main.bounds
		FXDLog("screenBounds: \(screenBounds)")
		FXDLog("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds)")
		FXDLog("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")

		let newWindow: UIWindow? = self.init(frame: screenBounds)
		newWindow?.autoresizesSubviews = true

		return newWindow
	}
}
