import UIKit

extension UIWindow {
    public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil, windowScene: UIWindowScene? = nil, application: UIApplication? = nil) -> UIWindow? {	fxd_log()
		guard nibName == nil else {
			let newWindow: UIWindow? = Self.view(fromNibName: nibName, owner: owner) as! UIWindow?
			return newWindow
		}

        var mainWindowScreen: UIScreen = UIScreen()
        var newWindow: UIWindow? = nil

        if windowScene == nil {
            let application = application ?? UIApplication.shared
            mainWindowScreen = application.mainWindow()?.screen ?? UIScreen()
            newWindow = Self.init(frame: mainWindowScreen.bounds)
        }
        else if let windowScene {
            mainWindowScreen = windowScene.screen
            newWindow = Self.init(windowScene: windowScene)
        }

        fxdPrint("windowScene.screen.bounds: \(mainWindowScreen.bounds)")
        fxdPrint("windowScene.screen.nativeBounds: \(mainWindowScreen.nativeBounds)")
        fxdPrint("windowScene.screen.nativeScale: \(mainWindowScreen.nativeScale)")

        fxdPrint("newWindow?.autoresizesSubviews: ", newWindow?.autoresizesSubviews)

		return newWindow
	}
}

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

		let waitingOverlay = FXDhostedOverlay(rootView: fXDviewOverlay(observable: observable))

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
				(_) in

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
