import MapKit


extension MKAnnotationView {
	public convenience init(annotation: MKAnnotation!, reuseIdentifier: String!, withDefaultImage defaultImage: UIImage?, shouldChangeOffset: Bool) {
		self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

		self.image = defaultImage

		if defaultImage != nil && shouldChangeOffset == true {
			self.centerOffset.y -= ((defaultImage?.size.height ?? 0.0)/2.0)
		}
	}


	public func animateCustomDrop(afterDelay delay: TimeInterval, fromOffset offset: CGPoint) {
		let animatedFrame = self.frame

		// Move annotation out of view
		var modifiedFrame = self.frame
		modifiedFrame.origin.x += offset.x
		modifiedFrame.origin.y += offset.y
		self.frame = modifiedFrame

		// Animate drop
		UIView.animate(withDuration: DURATION_ANIMATION,
					   delay: delay,
					   options: .curveEaseOut) {
			self.frame = animatedFrame

		} completion: {
			finished in

			UIView.animate(withDuration: DURATION_QUICK_ANIMATION) {
				self.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)

			} completion: {
				finished in

				UIView.animate(withDuration: DURATION_QUICK_ANIMATION) {
					self.transform = .identity
				}
			}
		}
	}
}
