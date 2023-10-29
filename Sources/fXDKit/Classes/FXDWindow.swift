

extension UIWindow {
	@objc public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {	fxd_log()
		guard nibName == nil else {
			let newWindow: UIWindow? = Self.view(fromNibName: nibName, owner: owner) as! UIWindow?
			return newWindow
		}

		
		let screenBounds = UIScreen.main.bounds
		fxdPrint("screenBounds: \(screenBounds)")
		fxdPrint("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds)")
		fxdPrint("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")

		let newWindow: UIWindow? = Self.init(frame: screenBounds)
		fxdPrint("newWindow?.autoresizesSubviews: \(String(describing: newWindow?.autoresizesSubviews))")

		return newWindow
	}
}


open class FXDviewInformation: UIView {
	@IBOutlet open var indicatorActivity: UIActivityIndicatorView?
	@IBOutlet open var labelTitle: UILabel?
	@IBOutlet open var labelMessage_0: UILabel?
	@IBOutlet open var labelMessage_1: UILabel?
	@IBOutlet open var sliderProgress: UISlider?
	@IBOutlet open var indicatorProgress: UIProgressView?
}

extension UIWindow {
	public weak var informationSubview: FXDviewInformation? {
		var found: FXDviewInformation? = nil
		for subview in subviews {
			if let informationSubview = subview as? FXDviewInformation {
				found = informationSubview
				break
			}
		}
		return found
	}

	@objc public func showInformation() {
		let overlay = informationSubview
		guard overlay == nil else {
			return
		}

		guard let information = FXDviewInformation.view() else {
			return
		}

		var modifiedFrame = information.frame
		modifiedFrame.size = frame.size
		information.frame = modifiedFrame

		information.alpha = 0.0
		information.isHidden = false

		addSubview(information)
		bringSubviewToFront(information)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
						information.alpha = 1.0
			})
	}

	@objc public func hideInformation() {
		guard let information = informationSubview else {
			return
		}

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
						information.alpha = 0.0
			}) {
				(finished) in

				information.removeFromSuperview()
		}
	}

	@objc public func showInformationView(afterDelay: TimeInterval) {
		DispatchQueue.main.async {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showInformation), object: nil)
			self.perform(#selector(self.showInformation), with: nil, afterDelay: afterDelay, inModes: [RunLoop.Mode.common])
		}
	}

	@objc public func hideInformationView(afterDelay: TimeInterval) {
		DispatchQueue.main.async {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hideInformation), object: nil)
			self.perform(#selector(self.hideInformation), with: nil, afterDelay: afterDelay, inModes: [RunLoop.Mode.common])
		}
	}
}
