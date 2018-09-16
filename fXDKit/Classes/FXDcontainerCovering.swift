import fXDObjC

public enum COVER_DIRECTION_TYPE: Int {
	case top
	case bottom
}

public protocol FXDprotocolCovering {
	var coverDirectionType: COVER_DIRECTION_TYPE { get set }
	var shouldCoverAbove: Bool { get set }
	var shouldStayFixed: Bool { get set }
	var offsetYforUncovering: NSNumber? { get }

	func didFinishAnimation()
}

public class FXDsegueCover: FXDStoryboardSegue {
	override public func perform() {	fxd_log()
		if let coveringContainer = mainContainer(of: FXDcontainerCovering.classForCoder()) as? FXDcontainerCovering {
			coveringContainer.cover(segue: self)
		}
	}
}

public class FXDsegueUncover: FXDStoryboardSegue {
	override public func perform() {	fxd_log()
		if let coveringContainer = mainContainer(of: FXDcontainerCovering.classForCoder()) as? FXDcontainerCovering {
			coveringContainer.uncover(segue: self)
		}
	}
}

open class FXDcontainerCovering: UIViewController {
	public var minimumChildCount: Int = 0
	var shouldFadeOutUncovering: Bool = false

	public var isCovering: Bool = false
	public var isUncovering: Bool = false

	@IBOutlet public weak var mainNavigationbar:  UIView!
	@IBOutlet public weak var mainToolbar: UIView!
}

extension FXDcontainerCovering {
	override open func viewDidLoad() {
		super.viewDidLoad()

		minimumChildCount = children.count
	}
}

extension FXDcontainerCovering {
	func coveringOffset(directionType: COVER_DIRECTION_TYPE) -> CGPoint {

		var offset = CGPoint.zero

		let direction = coveringDirection(directionType: directionType)

		offset.x = view.frame.size.width * direction.x
		offset.y = view.frame.size.height * direction.y

		return offset
	}

	func coveringDirection(directionType: COVER_DIRECTION_TYPE) -> CGPoint {

		var direction = CGPoint.zero
		direction.y = (directionType == .top) ? -1 : 1

		return direction
	}

	func cover(segue: FXDsegueCover) {	fxd_log()
		guard (isCovering == false && isUncovering == false),
			let presentedScene = segue.destination as? (UIViewController & FXDprotocolCovering)
			else {
				return
		}

		isCovering = true

		addChild(presentedScene)


		let offset = coveringOffset(directionType: presentedScene.coverDirectionType)
		let direction = coveringDirection(directionType: presentedScene.coverDirectionType)


		var animatedFrame = presentedScene.view.frame
		animatedFrame.origin.y = 0.0
		fxdPrint("1.\(animatedFrame)")

		var modifiedFrame = presentedScene.view.frame
		modifiedFrame.origin.x -= offset.x
		modifiedFrame.origin.y -= offset.y
		modifiedFrame.origin.y += (UIApplication.shared.statusBarFrame.size.height * direction.y)
		presentedScene.view.frame = modifiedFrame


		var pushedScene: UIViewController? = nil;
		var animatedPushedFrame = CGRect.zero

		if (presentedScene.shouldCoverAbove == false
			&& children.count > minimumChildCount),
			let destinationIndex = children.index(of: presentedScene) {
			//MARK: Including newly added child, the count should be bigger than one

			for child in children {
				let childScene = child as? (UIViewController & FXDprotocolCovering)
				if childScene == nil {
					continue
				}

				fxdPrint("\(childScene!), \(String(describing: childScene?.shouldStayFixed))")

				if let childIndex = children.index(of: childScene!),
					(childIndex < destinationIndex && childScene?.shouldStayFixed == false) {

					//MARK: If the childScene is last slid one, which is in previous index
					if (childIndex == (destinationIndex - 1)) {
						pushedScene = childScene
						animatedPushedFrame = (pushedScene?.view.frame)!
						animatedPushedFrame.origin.x += offset.x
						animatedPushedFrame.origin.y += offset.y
					}
					else {
						var modifiedPushedFrame = childScene?.view.frame
						modifiedPushedFrame?.origin.x += offset.x
						modifiedPushedFrame?.origin.y += offset.y

						childScene?.view.frame = modifiedPushedFrame!
					}
				}
			}
		}

		fxdPrint("\(String(describing: pushedScene)), \(animatedPushedFrame)")

		presentedScene.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]


		view.insertSubview(presentedScene.view, belowSubview: mainNavigationbar)
		presentedScene.didMove(toParent: self)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 delay: 0.0,
					 options: .curveEaseInOut,
					 animations: {
						
						presentedScene.view.frame = animatedFrame

						if (pushedScene != nil) {
							pushedScene?.view.frame = animatedPushedFrame
						}
			}) {
				[weak self] (didFinish) in	fxd_log()

				fxdPrint(String(describing: self?.children))

				self?.isCovering = false

				presentedScene.didFinishAnimation()
		}
	}

	func uncover(segue: FXDsegueUncover) {	fxd_log()

		guard (isCovering == false && isUncovering == false),
			let dismissedScene = segue.source as? (UIViewController & FXDprotocolCovering)
			else {
				return
		}

		isUncovering = true

		let offset = coveringOffset(directionType: dismissedScene.coverDirectionType)
		let direction = coveringDirection(directionType: dismissedScene.coverDirectionType)


		var animatedFrame = dismissedScene.view.frame
		animatedFrame.origin.x -= (animatedFrame.size.width * direction.x)

		let animatedAlpha = (shouldFadeOutUncovering) ? 0.0:dismissedScene.view.alpha


		if let offsetY = dismissedScene.offsetYforUncovering?.floatValue,
			(offsetY > 0.0) {
			fxdPrint("1.\(String(describing: offsetY))")
			animatedFrame.origin.y -= (CGFloat(offsetY) * direction.y)
		}
		else {
			animatedFrame.origin.y -= (animatedFrame.size.height * direction.y)
		}
		fxdPrint("2.CALCULATED offsetY: \(dismissedScene.view.frame.origin.y) - \(animatedFrame.origin.y) = \((dismissedScene.view.frame.origin.y - animatedFrame.origin.y))")


		var pulledScene: UIViewController? = nil
		var animatedPulledFrame = CGRect.zero

		if (dismissedScene.shouldCoverAbove == false
			&& children.count > minimumChildCount),
			let sourceIndex = children.index(of: dismissedScene) {
			//MARK: Including newly added child, the count should be bigger than one

			for child in children {
				let childScene = child as? (UIViewController & FXDprotocolCovering)
				if childScene == nil {
					continue
				}

				fxdPrint("\(childScene!), \(String(describing: childScene?.shouldStayFixed))")

				if let childIndex = children.index(of: childScene!),
					(childIndex < sourceIndex && childScene?.shouldStayFixed == false) {

					//MARK: If the childController is last slid one, which is in previous index
					if (childIndex == sourceIndex-1) {
						pulledScene = childScene
						animatedPulledFrame = (pulledScene?.view.frame)!
						animatedPulledFrame.origin.x -= offset.x
						animatedPulledFrame.origin.y -= offset.y
					}
					else {
						var modifiedPushedFrame = childScene?.view.frame
						modifiedPushedFrame?.origin.x -= offset.x
						modifiedPushedFrame?.origin.y -= offset.y

						childScene?.view.frame = modifiedPushedFrame!
					}
				}
			}
		}

		fxdPrint("\(String(describing: pulledScene)), \(animatedPulledFrame)")

		dismissedScene.willMove(toParent: nil)

		UIView
			.animate(withDuration: DURATION_ANIMATION,
					 delay: 0.0,
					 options: .curveEaseOut,
					 animations: {

						dismissedScene.view.frame = animatedFrame
						dismissedScene.view.alpha = animatedAlpha

						if (pulledScene != nil) {
							pulledScene?.view.frame = animatedPulledFrame
						}
			}) {
				[weak self] (didFinish) in

				fxdPrint("\(didFinish), \(String(describing: pulledScene))")

				dismissedScene.view.removeFromSuperview()
				dismissedScene.removeFromParent()

				self?.isUncovering = false

				dismissedScene.didFinishAnimation()
		}
	}

	func uncoverAllScenes(callback: @escaping FXDcallback) {
		//MARK: Assume direction is only vertical
		guard children.count > 0 else {
			callback(true, nil)
			return
		}


		var lateAddedSceneArray = Array<UIViewController>.init()

		for child in children {
			let childScene = child as? (UIViewController & FXDprotocolCovering)
			if childScene == nil {
				continue
			}

			fxdPrint("\(childScene!), \(String(describing: childScene?.shouldStayFixed))")

			if childScene?.shouldStayFixed == false {
				lateAddedSceneArray.append(childScene!)
			}
		}


		guard lateAddedSceneArray.count > 0 else {
			callback(true, nil)
			return
		}


		isUncovering = true

		fxd_log()
		fxdPrint("1.\(children)")
		fxdPrint(lateAddedSceneArray)

		var totalUncoveringOffsetY: CGFloat = 0.0

		for childScene in lateAddedSceneArray {
			totalUncoveringOffsetY += childScene.view.frame.size.height
		}

		fxdPrint(totalUncoveringOffsetY)


		var animatedFrameObjArray = Array<CGRect>.init()

		for childScene in lateAddedSceneArray {
			var animatedFrame = childScene.view.frame
			animatedFrame.origin.y += totalUncoveringOffsetY

			animatedFrameObjArray.append(animatedFrame)

			childScene.willMove(toParent: nil)
		}

		fxdPrint(animatedFrameObjArray)


		UIView
		.animate(withDuration: DURATION_ANIMATION,
				 delay: 0.0,
				 options: .curveLinear,
				 animations: {
					for childScene in lateAddedSceneArray {
						if let childIndex = lateAddedSceneArray.index(of: childScene) {
							let animatedFrame = animatedFrameObjArray[childIndex]
							childScene.view.frame = animatedFrame
						}
					}
		}) {
			[weak self] (didFinish) in	fxd_log()

			for childScene in lateAddedSceneArray {
				childScene.view.removeFromSuperview()
				childScene.removeFromParent()
			}

			fxdPrint("2.\(String(describing: self?.children))")

			self?.isUncovering = false

			callback(true, nil)
		}
	}
}
