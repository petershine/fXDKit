

extension UIViewController {
	@objc open var coverDirectionType: COVER_DIRECTION_TYPE {
		get {
			return .top
		}
	}

	@objc open var shouldCoverAbove: Bool {
		get {
			return false
		}
	}

	@objc open var shouldStayFixed: Bool {
		get {
			return false
		}
	}

	@objc open var offsetYforUncovering: NSNumber? {
		get {
			return nil
		}
	}

	@objc open func didFinishAnimation() {
		fxd_log_func()
	}
}


@objc public enum COVER_DIRECTION_TYPE: Int {
	case top
	case bottom
}


extension FXDcontainerCovering {
	@objc func coveringOffset(directionType: COVER_DIRECTION_TYPE) -> CGPoint {

		var offset = CGPoint.zero

		let direction = coveringDirection(directionType: directionType)

		offset.x = view.frame.size.width * direction.x
		offset.y = view.frame.size.height * direction.y

		return offset
	}

	@objc func coveringDirection(directionType: COVER_DIRECTION_TYPE) -> CGPoint {

		var direction = CGPoint.zero
		direction.y = (directionType == .top) ? -1 : 1

		return direction
	}
}
