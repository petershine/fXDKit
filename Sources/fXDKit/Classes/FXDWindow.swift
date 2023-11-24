

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


extension UIWindow {
	private weak var presentedController: FXDhostedInformation? {
		guard let activeController = rootViewController?.children.last as? FXDhostedInformation else {
			return nil
		}

		return activeController
	}

	@objc public func showInformation() {
		let activeController = presentedController
		guard activeController == nil && activeController?.view.superview == nil else {
			return
		}


		let configuration = FXDconfigurationInformation()
		let informationController = FXDhostedInformation(rootView: FXDswiftuiInformation(configuration: configuration))

		rootViewController?.addChild(informationController)
		rootViewController?.view.addSubview(informationController.view)
		informationController.didMove(toParent: rootViewController)

		informationController.view.alpha = 0.0
		informationController.view.isHidden = false

		bringSubviewToFront(informationController.view)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
						informationController.view.alpha = 1.0
			})
	}

	@objc public func hideInformation() {
		let activeController = presentedController
		guard activeController != nil && activeController?.view.superview != nil else {
			return
		}


		activeController?.willMove(toParent: nil)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
				activeController!.view.alpha = 0.0
			}) {
				(finished) in

				activeController!.view.removeFromSuperview()
				activeController?.removeFromParent()
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
