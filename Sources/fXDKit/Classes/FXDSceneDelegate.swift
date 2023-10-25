

import Foundation


public protocol FXDSceneDelegateProtocols: UIWindowSceneDelegate, ObservableObject {
	var isAppLaunching: Bool { get set }
	var didFinishLaunching: Bool { get set }

	func sceneFirstTimeBecameActiveAtLaunch(_ scene: UIScene)
}

open class FXDSceneDelegate: UIResponder, FXDSceneDelegateProtocols {
	@Published open var isAppLaunching: Bool = false
	@Published open var didFinishLaunching: Bool = false

	lazy public var fxdLaunchingView: FXDswiftuiLaunching = {
		fxd_overridable()
		fxdPrint(
"""
//MUST: subclass should specify what SwiftUI to be utilized as launchingView like:
class SubClassedSceneDelegate: FXDSceneDelegate {
 lazy var launchingView: ViewForLaunching = {
  return ViewForLaunching()
 }()
}
"""
		)
		
		return FXDswiftuiLaunching(backgroundImage: nil, foregroundImage: nil)
	}()


	override init() {
		super.init()
		fxd_overridable()
	}

	open func sceneDidBecomeActive(_ scene: UIScene) {
		guard isAppLaunching == false else {
			return
		}


		guard didFinishLaunching else {
			sceneFirstTimeBecameActiveAtLaunch(scene)
			return
		}


		fxd_overridable()
		fxdPrint("scene: \(scene) isAppLaunching: \(String(describing: isAppLaunching)) didFinishLaunching: \(String(describing: didFinishLaunching))")
	}

	open func sceneWillResignActive(_ scene: UIScene) {
		fxd_overridable()
		fxdPrint("scene: \(scene)")
	}

	open func sceneWillEnterForeground(_ scene: UIScene) {
		fxd_overridable()
		fxdPrint("scene: \(scene)")
	}

	open func sceneDidEnterBackground(_ scene: UIScene) {
		fxd_overridable()
		fxdPrint("scene: \(scene)")
	}

	open func sceneFirstTimeBecameActiveAtLaunch(_ scene: UIScene) {
		fxd_overridable()
		isAppLaunching = true

		fxdPrint("scene: \(scene)")
		fxdPrint("isAppLaunching: \(String(describing: isAppLaunching)) didFinishLaunching: \(String(describing: didFinishLaunching))")

		let taskInterval = 1.0
		fxdPrint("STARTED firstTime launched task \(Date.now) taskInterval: \(taskInterval)")
		Task {
			do {
				try await Task.sleep(nanoseconds: UInt64((taskInterval * 1_000_000_000).rounded()))
			}


			didFinishLaunching = true
			isAppLaunching = false


			fxdPrint("ENDED firstTime launched task \(Date.now)")
			fxdPrint("isAppLaunching: \(String(describing: isAppLaunching)) didFinishLaunching: \(String(describing: didFinishLaunching))")
		}
	}
}
