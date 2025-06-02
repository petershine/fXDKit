

import UIKit


extension UIViewController {
	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {	fxd_log()

		let resourceBundle = Bundle.init(for: self.classForCoder)

		let nib: UINib? = UINib.init(nibName: nibName ?? String(describing: self), bundle: resourceBundle)

		let views: [UIView]? = nib?.instantiate(withOwner: self, options: nil) as? [UIView]

		fxdPrint("nibName: ", nibName ?? self)
		fxdPrint("resourceBundle: ", resourceBundle)
		fxdPrint("nib: ", nib)
		fxdPrint("views: ", views)
		fxdPrint("views?.first: ", views?.first)

		return views?.first
	}
}

extension UIViewController {
	func lastChildScene(ofClass sceneClass: AnyClass?) -> UIViewController? {
		guard sceneClass != nil else {
			return nil
		}


		var lastChildScene: UIViewController? = nil

		for childScene in self.children.reversed() {
			if childScene.isKind(of: sceneClass!) {
				lastChildScene = childScene
				break
			}
		}

		return lastChildScene
	}

	public func addChildForScaleFit(child: UIViewController?) -> Bool {
		guard let child else {
			return false
		}


		addChild(child)
		view.addSubview(child.view)

		child.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			child.view.topAnchor.constraint(equalTo: view.topAnchor),
			child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		child.didMove(toParent: self)

		return true
	}
}

extension UIViewController {
    @IBAction func dismissSceneForEventSender(sender: Any) {  fxd_log()
		fxdPrint(self.parent, self.presentingViewController)

		if (self.parent != nil) {
			self.parent?.dismiss(animated: true, completion: nil)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}

    public func dismissFadingOut(duration: TimeInterval? = nil) async -> Bool {
        var didDismiss: Bool = false

        await withCheckedContinuation {
            [weak self] continuation in

            UIView.animate(
                withDuration: duration ?? DURATION_ONE_SECOND,
                delay: 0.0,
                options: .curveEaseIn,
                animations: {
                    [weak self] in

                    self?.view.alpha = 0.0
                }
            ) {
                [weak self] (finished: Bool) in

                self?.willMove(toParent: nil)
                self?.view.removeFromSuperview()
                self?.removeFromParent()

                didDismiss = finished

                continuation.resume()
            }
        }

        return didDismiss
    }
}
