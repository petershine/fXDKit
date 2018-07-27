

class FXDsceneLaunching: UIViewController {

	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .fade
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	override var shouldAutorotate: Bool {
		return false
	}

	@IBOutlet var imageviewDefault: UIImageView?
}
