

public protocol FXDprotocolScrollable {
	var mainScrollview: UIScrollView? { get }
	
	var heightRatioForSceneDismissing: CGFloat { get }
	var heightOffsetForSceneDismissing: CGFloat { get }

	func rateAgainst(maximumDistance: CGFloat, scrollView: UIScrollView) -> CGFloat
}

extension FXDprotocolScrollable {
	public var heightRatioForSceneDismissing: CGFloat {
		 return 0.275
	}
	public var heightOffsetForSceneDismissing: CGFloat {
		return (0.0 - (UIScreen.main.bounds.size.height*heightRatioForSceneDismissing))
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


public protocol FXDscrollableCells: FXDprotocolScrollable {
	var cellOperationQueue: OperationQueue? { get }
	var cellOperationDictionary: NSMutableDictionary? { get }

	var mainCellIdentifier: String { get }
	var mainDataSource: NSMutableArray? { get set }

	func configureCell(_ cell: UIView, for indexPath: IndexPath)
	func enqueueCellOperation(for cell: UIView, indexPath: IndexPath)
}

