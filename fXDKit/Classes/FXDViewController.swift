

extension UIViewController {
	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {	fxd_log()

		let resourceBundle = Bundle.init(for: self.classForCoder)

		let nib: UINib? = UINib.init(nibName: nibName ?? String(describing: self), bundle: resourceBundle)

		let views: [UIView]? = nib?.instantiate(withOwner: self, options: nil) as? [UIView]

		fxdPrint("nibName: \(String(describing: nibName ?? String(describing: self)))")
		fxdPrint("resourceBundle: \(String(describing: resourceBundle))")
		fxdPrint("nib: \(String(describing: nib))")
		fxdPrint("views: \(String(describing: views))")
		fxdPrint("views?.first: \(String(describing: views?.first))")

		return views?.first
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
