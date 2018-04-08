
import UIKit

public typealias FXDcallbackHitIntercept = (_ hitView: UIView?, _ point: CGPoint?, _ event: UIEvent?) -> UIView?

open class FXDviewNonInteractive: UIView {
	var hitIntercept: FXDcallbackHitIntercept?

	override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

		var hitView: UIView = super.hitTest(point, with: event)!

		if self.hitIntercept != nil {
			hitView = self.hitIntercept!(hitView, point, event)!
		}

		return hitView
	}
}
