

public protocol FXDsceneWithScroll {
	var didStartAutoScrollingToTop: Bool { get set }

	var shouldDismissingByPullingDown: Bool { get set }
	var didStartDismissingByPullingDown: Bool { get set }

	var offsetYdismissingController: CGFloat { get set }

	func dismissByPullingDown(_ scrollView: UIScrollView?)
	func rateAgainst(maximumDistance: CGFloat, scrollView: UIScrollView) -> CGFloat
}


public let SCALE_SCENE_DISMISSING_OFFSET: Float = 0.275


open class FXDsceneScroll: UIViewController, FXDsceneWithScroll {
	@IBOutlet open var mainScrollview: UIScrollView?


	open var didStartAutoScrollingToTop: Bool = false

	open var shouldDismissingByPullingDown: Bool = false
	open var didStartDismissingByPullingDown: Bool = false

	open var offsetYdismissingController: CGFloat = 0.0

	open func dismissByPullingDown(_ scrollView: UIScrollView?) {	fxd_log_func()
	}

	open func rateAgainst(maximumDistance: CGFloat, scrollView: UIScrollView) -> CGFloat {

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


extension FXDsceneScroll {
	override open func viewDidLoad() {
		super.viewDidLoad()

		let screenBounds = UIScreen.main.bounds
		offsetYdismissingController = 0.0 - (screenBounds.size.height * CGFloat(SCALE_SCENE_DISMISSING_OFFSET))
	}
}


extension FXDsceneScroll: UIScrollViewDelegate {
	open func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard shouldDismissingByPullingDown else {
			return
		}

		if scrollView.contentOffset.y < (offsetYdismissingController - scrollView.contentInset.top)
			&& didStartDismissingByPullingDown == false {

			dismissByPullingDown(scrollView)
		}
	}

	open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		didStartAutoScrollingToTop = scrollView.scrollsToTop

		return scrollView.scrollsToTop
	}

	open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
		didStartAutoScrollingToTop = false
	}
}
