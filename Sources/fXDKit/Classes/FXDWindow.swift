

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
	private weak var currentWaitingController: FXDhostedInformation? {
		guard let activeController = rootViewController?.children.last as? FXDhostedInformation else {
			return nil
		}

		return activeController
	}

	@objc public func showWaiting() {
		let activeController = currentWaitingController
		guard activeController == nil && activeController?.view.superview == nil else {
			return
		}


		let informationController = FXDhostedInformation(rootView: FXDswiftuiInformation())

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

	@objc public func hideWaiting() {
		let activeController = currentWaitingController
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

	@objc public func showWaitingView(afterDelay: TimeInterval) {
		DispatchQueue.main.async {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showWaiting), object: nil)
			self.perform(#selector(self.showWaitingView), with: nil, afterDelay: afterDelay, inModes: [RunLoop.Mode.common])
		}
	}

	@objc public func hideWaitingView(afterDelay: TimeInterval) {
		DispatchQueue.main.async {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hideWaiting), object: nil)
			self.perform(#selector(self.hideWaiting), with: nil, afterDelay: afterDelay, inModes: [RunLoop.Mode.common])
		}
	}
}
