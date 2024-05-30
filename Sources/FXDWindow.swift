

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

	public func showOverlay(observable: FXDobservableOverlay? = nil) {
		let activeController = currentActiveController
		guard activeController == nil && activeController?.view.superview == nil else {
			return
		}


		let waitingOverlay = FXDhostedOverlay(rootView: FXDswiftuiOverlay(observable: observable))

		rootViewController?.addChild(waitingOverlay)
		rootViewController?.view.addSubview(waitingOverlay.view)
		waitingOverlay.didMove(toParent: rootViewController)

		waitingOverlay.view.alpha = 0.0
		waitingOverlay.view.isHidden = false

		bringSubviewToFront(waitingOverlay.view)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 animations: {
						waitingOverlay.view.alpha = 1.0
			})
	}

	public func hideOverlay() {
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

	public func showOverlay(afterDelay: TimeInterval, observable: FXDobservableOverlay? = nil) {
		cancelAsyncTask()
		performAsyncTask(afterDelay: afterDelay) {
			DispatchQueue.main.async {
				[weak self] in
				self?.showOverlay(observable: observable)
			}
		}
	}

	public func hideOverlay(afterDelay: TimeInterval) {
		cancelAsyncTask()
		performAsyncTask(afterDelay: afterDelay) {
			DispatchQueue.main.async {
				[weak self] in
				self?.hideOverlay()
			}
		}
	}
}
