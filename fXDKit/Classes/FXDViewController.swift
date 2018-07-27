

extension UIViewController {
	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {	fxd_log_func()

		var fromNibName = nibName

		if (fromNibName == nil) {
			fromNibName = String(describing: self)
		}

		let fromNib: UINib? = UINib.init(nibName:fromNibName!, bundle: nil)

		//MARK: self must be the owner
		let viewArray: [UIView]? = fromNib?.instantiate(withOwner: self, options: nil) as? [UIView]

		fxdPrint("\(String(describing: viewArray?.first))")

		return viewArray?.first
	}
}

extension UIViewController {
	func lastChildScene(ofClass sceneClass: AnyClass?) -> UIViewController? {
		guard sceneClass != nil else {
			return nil
		}


		var lastChildScene: UIViewController? = nil

		for childScene in self.childViewControllers.reversed() {
			if childScene.isKind(of: sceneClass!) {
				lastChildScene = childScene
				break
			}
		}

		return lastChildScene
	}
}

extension UIViewController {

	@IBAction func dismissSceneForEventSender(sender: Any) {  fxd_log_func()

		fxdPrint("\(String(describing: self.parent)) \(String(describing: self.presentingViewController))")

		if (self.parent != nil) {
			self.parent?.dismiss(animated: true, completion: nil)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}

	@objc public func fadeOutScene(callback: FXDcallback?) {

		UIView.animate(
			withDuration: DURATION_ONE_SECOND,
			delay: 0.0,
			options: .curveEaseIn,
			animations: {
				[weak self] in
				
				self?.view.alpha = 0.0
			}
		) {
			(finished: Bool) in
			
			if callback != nil {
				callback!(true, nil)
			}
		}
	}
}
