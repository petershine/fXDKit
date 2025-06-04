import fXDObjC

extension UIButton {
	public func replaceImageWithResizableImage(withCapInsets capInsets: UIEdgeInsets) {

		[UIControl.State.normal,
		 UIControl.State.highlighted,
		 UIControl.State.selected,
		 UIControl.State.disabled].forEach({
			controlState in

			if let image = self.image(for: controlState) {
				self.setImage(image.resizableImage(withCapInsets: capInsets), for: controlState)
			}
		})
	}

	public func replaceBackgroundImageWithResizableImage(withCapInsets capInsets: UIEdgeInsets) {

		[UIControl.State.normal,
		 UIControl.State.highlighted,
		 UIControl.State.selected,
		 UIControl.State.disabled].forEach({
			controlState in

			if let image = self.backgroundImage(for: controlState) {
				self.setBackgroundImage(image.resizableImage(withCapInsets: capInsets), for: controlState)
			}
		})
	}
}
