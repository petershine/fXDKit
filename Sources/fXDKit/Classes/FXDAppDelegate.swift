

import Foundation


public protocol FXDAppDelegateProtocols: UIApplicationDelegate, ObservableObject {
	var sceneDelegateClass: AnyClass? { get }
}


open class FXDAppDelegate: UIResponder, FXDAppDelegateProtocols {
	open var sceneDelegateClass: AnyClass? {
		get {
			fxd_overridable()
			fxdPrint(
"""
//MUST: specify what class to be utilized, by overriding \"sceneDelegateClass\", like:
class SubClassedAppDelegate: FXDAppDelegate {
 override lazy var sceneDelegateClass: AnyClass? = {
   return SubClassedSceneDelegate.self
 }()
}
"""
			)

			return FXDSceneDelegate.self
		}
	}


	override init() {
		super.init()
		fxd_overridable()
	}


	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		fxd_overridable()
		fxdPrint("launchOptions: \(String(describing: launchOptions))")
		return true
	}

	open func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		fxd_overridable()
		fxdPrint("connectingSceneSession: \(String(describing: connectingSceneSession))")


		let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfig.delegateClass = self.sceneDelegateClass
		fxdPrint("sceneConfig.delegateClass: \(String(describing: sceneConfig.delegateClass))")
		fxdPrint("sceneConfig: \(sceneConfig)")

		return sceneConfig
	}

	open func applicationWillTerminate(_ application: UIApplication) {
		fxd_overridable()
		fxdPrint("applicationState: \(application.applicationState)")
	}
}
