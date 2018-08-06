

extension UIViewController {
	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {	fxd_log()

		var fromNibName = nibName

		if (fromNibName == nil) {
			fromNibName = String(describing: self)
		}

		let resourceBundle = Bundle.init(for: self.classForCoder)

		let fromNib: UINib? = UINib.init(nibName:fromNibName!, bundle: resourceBundle)

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
    @IBAction func dismissSceneForEventSender(sender: Any) {  fxd_log()
		fxdPrint("\(String(describing: self.parent)) \(String(describing: self.presentingViewController))")

		if (self.parent != nil) {
			self.parent?.dismiss(animated: true, completion: nil)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}

	@objc public func dismissFadingOut(callback: FXDcallback?) {
		UIView.animate(
			withDuration: DURATION_ONE_SECOND,
			delay: 0.0,
			options: .curveEaseIn,
			animations: {
				[weak self] in
				
				self?.view.alpha = 0.0
			}
		) {
			[weak self] (finished: Bool) in
			
			self?.willMove(toParentViewController: nil)
			self?.view.removeFromSuperview()
			self?.removeFromParentViewController()

			if callback != nil {
				callback!(finished, nil)
			}
		}
	}
}
