

class FXDsceneLaunching: UIViewController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .fade
	}

	override var shouldAutorotate: Bool {
		return false
	}

	@IBOutlet weak var imageviewDefault: UIImageView!
}
