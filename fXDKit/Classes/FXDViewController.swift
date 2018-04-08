

extension UIViewController {

	@IBAction func dismissSceneForEventSender(sender: Any) {  FXDLog_Func()

		FXDLog("\(String(describing: self.parent)) \(String(describing: self.presentingViewController))")

		if (self.parent != nil) {
			self.parent?.dismiss(animated: true, completion: nil)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}

	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {
		FXDLog_Func()

		var fromNibName = nibName

		if (fromNibName == nil) {
			fromNibName = String(describing: self)
		}

		let fromNib: UINib? = UINib.init(nibName:fromNibName!, bundle: nil)

		//MARK: self must be the owner
		let viewArray: [UIView]? = fromNib?.instantiate(withOwner: self, options: nil) as? [UIView]

		FXDLog("\(String(describing: viewArray?.first))")

		return viewArray?.first
	}

}

