

import SwiftUI
import Foundation


public protocol FXDSceneDelegateProtocols: UIWindowSceneDelegate, ObservableObject {
	var isAppLaunching: Bool { get set }
	var didFinishLaunching: Bool { get set }

	var launchingView: AnyView? { get }

	func sceneFirstTimeBecameActiveAtLaunch(_ scene: UIScene)
}


open class FXDSceneDelegate: UIResponder, FXDSceneDelegateProtocols {
	
	@Published open var isAppLaunching: Bool = false
	@Published open var didFinishLaunching: Bool = false

	open var launchingView: AnyView? {
		get {
			fxd_overridable()
			fxdPrint(
"""
//MUST: subclass should specify what SwiftUI to be utilized as launchingView like:
class SubClassedSceneDelegate: FXDSceneDelegate {
 override var launchingView: AnyView? {
  get {
   return AnyView(OwnLaunchView())
  }
 }
}
"""
			)

			return AnyView(fXDstackLaunching(backgroundImage: nil, foregroundImage: nil))
		}
	}


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
		fxdPrint("scene: \(scene)")
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
		fxdPrint("isAppLaunching: ", isAppLaunching, "didFinishLaunching: ", didFinishLaunching)

		let taskInterval = 1.0
		fxdPrint("STARTED firstTime launched task \(Date.now) taskInterval: \(taskInterval)")
		Task {
			do {
				try await Task.sleep(nanoseconds: UInt64((taskInterval * 1_000_000_000).rounded()))
			}


			didFinishLaunching = true
			isAppLaunching = false


			fxdPrint("ENDED firstTime launched task \(Date.now)")
			fxdPrint("isAppLaunching: ", isAppLaunching, "didFinishLaunching: ", didFinishLaunching)
		}
	}
}
