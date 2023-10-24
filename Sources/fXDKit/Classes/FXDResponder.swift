

import SwiftUI
import Foundation


extension UIResponder {
	@objc public func executeOperations(for application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {	fxd_log()

		guard launchOptions != nil else {
			return
		}


		let url: URL? = launchOptions![.url] as? URL
		let sourceApplication = launchOptions![.sourceApplication]

		guard (url != nil
			|| sourceApplication != nil) else {
				return
		}


		let openOptions: [UIApplication.OpenURLOptionsKey : Any]
			= [.sourceApplication : sourceApplication!]
		
		if let appDelegate = self as? UIApplicationDelegate {
			_ = appDelegate.application!(application, open: url!, options: openOptions)
		}
	}


	@objc public func isUsable(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {	fxd_log()

		guard launchOptions != nil else {
			return false
		}


		let url = launchOptions![.url]
		let sourceApplication = launchOptions![.sourceApplication]
		let remoteNotification = launchOptions![.remoteNotification]

		guard (url != nil
			|| sourceApplication != nil
			|| remoteNotification != nil) else {
				return false
		}

		return true
	}
}


public protocol FXDAppDelegateProtocols: UIApplicationDelegate, ObservableObject {
	var sceneDelegateClass: AnyClass { get }
}

open class FXDAppDelegate: UIResponder, FXDAppDelegateProtocols {
	open var sceneDelegateClass: AnyClass = FXDSceneDelegate.self

	override init() {
		super.init()
		fxdPrint("\(#function) \(self)")
	}


	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		fxdPrint("\(#function) \(application) \(String(describing: launchOptions))")
		return true
	}

	open func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		fxdPrint("\(#function) \(application) \(String(describing: connectingSceneSession))")

		let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfig.delegateClass = self.sceneDelegateClass
		return sceneConfig
	}

	open func applicationWillTerminate(_ application: UIApplication) {
		fxdPrint("\(#function) \(application) state: \(application.applicationState)")
	}
}


public protocol FXDSceneDelegateProtocols: UIWindowSceneDelegate, ObservableObject {
	var isAppLaunching: Bool { get set }
	var didFinishLaunching: Bool { get set }

	func sceneFirstTimeBecameActiveAtLaunch(_ scene: UIScene)
}

open class FXDSceneDelegate: UIResponder, FXDSceneDelegateProtocols {
	@Published open var isAppLaunching: Bool = false
	@Published open var didFinishLaunching: Bool = false

	lazy open var launchingView: FXDswiftuiLaunching = {
		return FXDswiftuiLaunching(backgroundImagename: nil, foregroundImagename: nil)
	}()


	override init() {
		super.init()
		fxdPrint("\(#function) \(self)")
	}

	open func sceneDidBecomeActive(_ scene: UIScene) {
		guard isAppLaunching == false else {
			return
		}


		guard didFinishLaunching else {
			sceneFirstTimeBecameActiveAtLaunch(scene)
			return
		}


		fxdPrint("\(#function) \(scene) isAppLaunching: \(String(describing: isAppLaunching)) didFinishLaunching: \(String(describing: didFinishLaunching))")
	}

	open func sceneWillResignActive(_ scene: UIScene) {
		fxdPrint("\(#function) \(scene)")
	}

	open func sceneWillEnterForeground(_ scene: UIScene) {
		fxdPrint("\(#function) \(scene)")
	}

	open func sceneDidEnterBackground(_ scene: UIScene) {
		fxdPrint("\(#function) \(scene)")
	}

	open func sceneFirstTimeBecameActiveAtLaunch(_ scene: UIScene) {
		fxd_overridable()

		fxdPrint("\(#function) \(scene) isAppLaunching: \(String(describing: isAppLaunching))")

		isAppLaunching = true

		let sleepingInterval = 1.0
		Task {
			do {
				try await Task.sleep(nanoseconds: UInt64((sleepingInterval * 1_000_000_000).rounded()))
			}

			didFinishLaunching = true
			isAppLaunching = false

			fxdPrint("\(#function) \(scene) sleepingInterval: \(sleepingInterval) isAppLaunching: \(String(describing: isAppLaunching)) didFinishLaunching: \(String(describing: didFinishLaunching))")
		}
	}
}
