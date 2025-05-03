import UIKit

import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebasePerformance


@Observable
open class fXDmoduleFirebase: NSObject, MessagingDelegate, @unchecked Sendable {
    public static let shared: fXDmoduleFirebase = {
        fXDmoduleFirebase()
    }()

    public var process: ((RemoteConfig?)-> Bool) = { _ in return true }
    @MainActor public var didUpdateConfig: Bool = false

    fileprivate var remoteConfig: RemoteConfig? = nil

    
    override init() {
        super.init()
        FirebaseApp.configure()

        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.configSettings = RemoteConfigSettings()
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self

        Task {
            try await fetchRemoteConfig()
        }

        return true
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension fXDmoduleFirebase {
    fileprivate func fetchRemoteConfig() async throws {
        do {
            let _ = try await remoteConfig?.fetchAndActivate()
        }
        catch {
            fxd_log()
            fxdPrint(error)
            throw error
        }

        guard process(remoteConfig) else{
            return try await fetchRemoteConfig()
        }


        await MainActor.run {
            didUpdateConfig = true
        }
    }
}
