import UIKit

import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebasePerformance


@Observable
class fXDmoduleFirebase: NSObject, MessagingDelegate, @unchecked Sendable {
    static let shared: fXDmoduleFirebase = {
        fXDmoduleFirebase()
    }()

    var remoteConfig: RemoteConfig? = nil
    var process: ((RemoteConfig?)-> Bool) = { _ in return true }
    @MainActor public var didUpdateConfig: Bool = false

    override init() {
        super.init()
        FirebaseApp.configure()

        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.configSettings = RemoteConfigSettings()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self

        Task {
            try await fetchRemoteConfig()
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
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
