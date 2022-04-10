

open class FXDsceneLaunching: UIViewController {
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	override open var prefersStatusBarHidden: Bool {
		return true
	}
	override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .fade
	}
	override open var shouldAutorotate: Bool {
		return false
	}

	@IBOutlet weak var imageviewDefault: UIImageView!
}
