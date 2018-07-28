

public protocol FXDsceneScrollable {
	var heightRaioForSceneDismissing: CGFloat { get }
	var heightOffsetForSceneDismissing: CGFloat { get }

	func rateAgainst(maximumDistance: CGFloat, scrollView: UIScrollView) -> CGFloat

	var mainScrollview: UIScrollView? { get }
}

extension FXDsceneScrollable {
	public var heightRaioForSceneDismissing: CGFloat {
		 return 0.275
	}
	public var heightOffsetForSceneDismissing: CGFloat {
		return (0.0 - (UIScreen.main.bounds.size.height*heightRaioForSceneDismissing))
	}

	public func rateAgainst(maximumDistance: CGFloat, scrollView: UIScrollView) -> CGFloat {

		var distance: CGFloat = scrollView.contentOffset.y + scrollView.contentInset.top

		if #available(iOS 11.0, *) {
			distance += scrollView.safeAreaInsets.top
		}

		if (distance < 0.0) {
			distance = 0.0
		}
		else if (distance > maximumDistance) {
			distance = maximumDistance
		}

		return (distance/maximumDistance)
	}
}
