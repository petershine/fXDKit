

import Foundation
import UIKit


public protocol FXDAppDelegateProtocols: UIApplicationDelegate, ObservableObject {
	var sceneDelegateClass: AnyClass? { get }
    var backgroundCompletionHandler: (() -> Void)? { get set }
}


open class FXDAppDelegate: UIResponder, FXDAppDelegateProtocols {
	open var sceneDelegateClass: AnyClass? {
		get {
			fxd_overridable()
			fxdPrint(
"""
//MUST: specify what class to be utilized, by overriding \"sceneDelegateClass\", like:
class SubClassedAppDelegate: FXDAppDelegate {
 override var sceneDelegateClass: AnyClass? {
  get {
   return SubClassedSceneDelegate.self
  }
 }
}
"""
			)

			return FXDSceneDelegate.self
		}
	}

    open var backgroundCompletionHandler: (() -> Void)? = nil

    
	override init() {
		super.init()
		fxd_overridable()
	}


	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		fxd_overridable()
		fxdPrint("launchOptions: ", launchOptions)
		return true
	}

	open func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		fxd_overridable()
		fxdPrint("connectingSceneSession: ", connectingSceneSession)


		let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfig.delegateClass = self.sceneDelegateClass
		fxdPrint("sceneConfig.delegateClass: ", sceneConfig.delegateClass)
		fxdPrint("sceneConfig: \(sceneConfig)")

		return sceneConfig
	}

	open func applicationWillTerminate(_ application: UIApplication) {
		fxd_overridable()
		fxdPrint("applicationState: ", application.applicationState)
	}
}
