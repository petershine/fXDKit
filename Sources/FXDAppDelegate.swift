

import Foundation
import UIKit


public protocol FXDAppDelegateProtocols: UIApplicationDelegate, ObservableObject {
	var sceneDelegateClass: AnyClass? { get }
    var backgroundCompletionHandler: (() -> Void)? { get set }
}


open class FXDAppDelegate: UIResponder, FXDAppDelegateProtocols, @unchecked Sendable {
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


    public override init() {
        super.init()
        fxd_overridable()
    }


    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        fxd_overridable()
        fxdPrint("launchOptions:", launchOptions)

        UNUserNotificationCenter.current().delegate = self
        Task {
            let (_, _) = await UNUserNotificationCenter.attemptAuthorization()
        }
        
        return true
    }

    open func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        fxd_overridable()
        fxdPrint("connectingSceneSession:", connectingSceneSession)


        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = self.sceneDelegateClass
        fxdPrint("sceneConfig.delegateClass:", sceneConfig.delegateClass)
        fxdPrint("sceneConfig: \(sceneConfig)")

        return sceneConfig
    }

    open func applicationWillTerminate(_ application: UIApplication) {
        fxd_overridable()
        fxdPrint("applicationState:", application.applicationState)
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        fxd_overridable()
        fxdPrint("deviceToken:", deviceToken)

        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0)}.joined()
        fxdPrint("deviceTokenString", deviceTokenString)
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        fxd_overridable()
        fxdPrint("error:", error)
    }

    open func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        fxd_overridable()
        fxdPrint("identifier:", identifier)
        fxdPrint("completionHandler:", completionHandler)
    }
}

extension FXDAppDelegate: UNUserNotificationCenterDelegate {
    nonisolated open func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        fxd_overridable()
        fxdPrint("notification:", notification)
        fxdPrint("completionHandler:", completionHandler)
        completionHandler([.badge, .sound, .list, .banner])
    }
}
