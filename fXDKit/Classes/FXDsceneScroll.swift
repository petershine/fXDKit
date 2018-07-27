

protocol FXDsceneWithScroll {
	func dismissByPullingDown(_ scrollView: UIScrollView?)
}


let SCALE_SCENE_DISMISSING_OFFSET: Float = 0.275

open class FXDsceneScroll: UIViewController {

	open var didStartAutoScrollingToTop: Bool = false

	open var shouldDismissingByPullingDown: Bool = false
	open var didStartDismissingByPullingDown: Bool = false

	var offsetYdismissingController: CGFloat = 0.0


	open lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()

	open lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()

	@IBOutlet open var mainScrollview: UIScrollView?


	override open func viewDidLoad() {
		super.viewDidLoad()

		let screenBounds = UIScreen.main.bounds
		offsetYdismissingController = 0.0 - (screenBounds.size.height * CGFloat(SCALE_SCENE_DISMISSING_OFFSET))
	}

	override open func willMove(toParentViewController parent: UIViewController?) {

		if parent == nil {
			cellOperationQueue?.resetOperationQueueAndDictionary(cellOperationDictionary)
		}

		super.willMove(toParentViewController: parent)
	}
}

extension FXDsceneScroll: FXDsceneWithScroll {
	@objc open func dismissByPullingDown(_ scrollView: UIScrollView?) {
		fxd_log_func()
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
