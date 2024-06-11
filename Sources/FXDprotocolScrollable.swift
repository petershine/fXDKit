import fXDObjC

import Combine


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
		distance += scrollView.safeAreaInsets.top

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
	var mainDataSource: Array<Any>? { get set }

	func configureCell(_ cell: UIView, for indexPath: IndexPath)
	func enqueueCellOperation(for cell: UIView, indexPath: IndexPath)
}

public protocol FXDscrollableMap: FXDprotocolScrollable {
	var mainMapview: FXDMapView? { get set }
	var isMapviewFadingIn: Bool { get set }
	var durationBeforeStartUserTracking: TimeInterval { get }

	func unloadMapScene()
	func initializeMapview()

	func refreshMapview(coordinate: CLLocationCoordinate2D?)

	var observedCancellableForUserTracking: AnyCancellable? { get set }
	func cancelTrackingUserOnMapView()
	func delayedTrackingUserOnMapView(afterDelay: TimeInterval)
	func startTrackingUserOnMapView()
}
