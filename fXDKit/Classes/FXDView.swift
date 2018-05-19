

extension UIView {
	//REFERENCE: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/

	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}

	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable
	var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.borderColor = color.cgColor
			} else {
				layer.borderColor = nil
			}
		}
	}

	@IBInspectable
	var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}

	@IBInspectable
	var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}

	@IBInspectable
	var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}

	@IBInspectable
	var shadowColor: UIColor? {
		get {
			if let color = layer.shadowColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.shadowColor = color.cgColor
			} else {
				layer.shadowColor = nil
			}
		}
	}
}

extension UIView {

	@objc public class func view(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {	fxd_log_func()

		//FIXME: Should update this method to use Self class, for subclasses.
		//https://github.com/apple/swift-evolution/blob/master/proposals/0068-universal-self.md

		var fromNibName = nibName

		if fromNibName == nil {
			fromNibName = String(describing: self)
		}
		fxdPrint("fromNibName: \(String(describing: fromNibName))")

		let fromNib: UINib? = UINib.init(nibName:fromNibName!, bundle: nil)
		fxdPrint("fromNib: \(String(describing: fromNib))")

		let viewArray: [UIView]? = fromNib?.instantiate(withOwner: owner, options: nil) as? [UIView]
		fxdPrint("viewArray: \(String(describing: viewArray))")

		return viewArray?.first
	}
}


extension UIView {
	@objc public func fadeInFromHidden() {
		guard (self.isHidden || self.alpha != 1.0) else {
			return
		}

		self.alpha = 0.0;
		self.isHidden = false;

		UIView.animate(withDuration: DURATION_ANIMATION) {
			self.alpha = 1.0
		}
	}

	@objc public func fadeOutThenHidden() {
		guard (self.isHidden == false) else {
			return
		}

		let previousAlpha = self.alpha

		UIView.animate(withDuration: DURATION_ANIMATION,
		               animations: {
						self.alpha = 0.0
		}) { (didFinish: Bool) in
			self.isHidden = true
			self.alpha = previousAlpha
		}
	}

	@objc public func addAsFadeInSubview(_ subview: UIView?, afterAddedBlock: (() -> Swift.Void)? = nil) {

		guard subview != nil else {
			afterAddedBlock?()
			return
		}

		subview?.alpha = 0.0

		self.addSubview(subview!)
		self.bringSubview(toFront: subview!)

		UIView.animate(
			withDuration: DURATION_ANIMATION,
			animations: {
				subview?.alpha = 0.0

		}) { (didFinish: Bool) in
			afterAddedBlock?()
		}
	}

	@objc public func removeAsFadeOutSubview(_ subview: UIView?, afterRemovedBlock: (() -> Swift.Void)? = nil) {

		guard subview != nil else {
			afterRemovedBlock?()
			return
		}

		UIView.animate(
			withDuration: DURATION_ANIMATION,
			animations: {
			subview?.alpha = 0.0

		}) { (didFinish: Bool) in
			subview?.removeFromSuperview()
			subview?.alpha = 1.0

			afterRemovedBlock?()
		}
	}

	@objc public func modifyToCircular() {
		self.layer.masksToBounds = true
		self.layer.cornerRadius = self.bounds.size.width/2.0
	}

	@objc public func removeAllSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
}

extension UIView {
	@objc public func superView(forClassName className: String?) -> Any? {
		var superView: Any? = nil

		if self.superview != nil {
			if String(describing: self.superview) == className {
				superView = self.superview
			}
			else {
				// Recursive call
				superView = self.superview?.superView(forClassName: className)
			}
		}

		return superView
	}
}

extension UIView {
	@objc public func blinkShadowOpacity() {
		let blinkShadow: CABasicAnimation = CABasicAnimation.init(keyPath: "shadowOpacity")
		blinkShadow.fromValue = self.layer.shadowOpacity
		blinkShadow.toValue = 0.0
		blinkShadow.duration = DURATION_ANIMATION
		blinkShadow.autoreverses = true
		self.layer.add(blinkShadow, forKey: "shadowOpacity")
	}
}

