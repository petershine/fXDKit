import Foundation
import UIKit

public protocol FXDprotocolGlobal {
	var mainStoryboardName: String? { get set }
	var mainStoryboard: UIStoryboard? { get }
}

@MainActor
extension FXDprotocolGlobal {
	public var mainStoryboard: UIStoryboard? {
		get {
			return (mainStoryboardName != nil) ? UIStoryboard(name: mainStoryboardName!, bundle: Bundle.main) : nil
		}
	}
}
