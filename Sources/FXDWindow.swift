

import UIKit


extension UIWindow {
	public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {	fxd_log()
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

@available(iOS 17.0, *)
extension UIWindow {
	private weak var currentActiveController: FXDhostedOverlay? {
		guard let activeController = rootViewController?.children.last as? FXDhostedOverlay else {
			return nil
		}

		return activeController
	}

	public func showWaiting(configuration: FXDobservableOverlay? = nil) {
		let activeController = currentActiveController
		guard activeController == nil && activeController?.view.superview == nil else {
			return
		}


		let waitingController = FXDhostedOverlay(rootView: FXDswiftuiOverlay(configuration: configuration ?? FXDobservableOverlay()))

		rootViewController?.addChild(waitingController)
		rootViewController?.view.addSubview(waitingController.view)
		waitingController.didMove(toParent: rootViewController)

		waitingController.view.alpha = 0.0
		waitingController.view.isHidden = false

		bringSubviewToFront(waitingController.view)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
						waitingController.view.alpha = 1.0
			})
	}

	public func hideWaiting() {
		let activeController = currentActiveController
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

	public func showWaitingView(afterDelay: TimeInterval, configuration: FXDobservableOverlay? = nil) {
		cancelAsyncTask()
		performAsyncTask(afterDelay: afterDelay) {
			DispatchQueue.main.async {
				[weak self] in
				self?.showWaiting(configuration: configuration)
			}
		}
	}

	public func hideWaitingView(afterDelay: TimeInterval) {
		cancelAsyncTask()
		performAsyncTask(afterDelay: afterDelay) {
			DispatchQueue.main.async {
				[weak self] in
				self?.hideWaiting()
			}
		}
	}
}
