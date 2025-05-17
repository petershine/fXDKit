import UIKit

import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebasePerformance


@Observable
open class fXDmoduleFirebase: NSObject, MessagingDelegate, @unchecked Sendable {
    public var process: ((RemoteConfig?)-> Bool) = { _ in return true }
    @MainActor public var didUpdateConfig: Bool = false

    fileprivate var remoteConfig: RemoteConfig? = nil

    
    public override init() {
        super.init()
        FirebaseApp.configure()

        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.configSettings = RemoteConfigSettings()

        remoteConfig?.addOnConfigUpdateListener {
            configUpdate, error in

            guard let configUpdate, error == nil else {
                fxdPrint("Error listening for config updates: \(String(describing: error))")
                return
            }

            fxdPrint("Updated keys: \(configUpdate.updatedKeys)")
            self.remoteConfig?.activate {
                changed, error in

                if changed,
                   self.process(self.remoteConfig) {
                    DispatchQueue.main.async {
                        self.didUpdateConfig = true
                    }
                }
            }
        }
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self

        let mainAttempt = Task {
            try await fetchRemoteConfig(reAttemptLimit: 5)
        }

        Task {
            try await Task.sleep(nanoseconds: UInt64((10.0 * 1_000_000_000).rounded()))
            if !(await didUpdateConfig) {
                mainAttempt.cancel()

                let forceProcessing = process(remoteConfig)
                fxd_log()
                fxdPrint("forceProcessing: \(forceProcessing)")
                
                await MainActor.run {
                    self.didUpdateConfig = true
                }
            }
        }

        return true
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension fXDmoduleFirebase {
    fileprivate func fetchRemoteConfig(reAttemptLimit: Int) async throws {
        var fetchError: Error? = nil
        do {
            let _ = try await remoteConfig?.fetchAndActivate()
        }
        catch {
            fetchError = error
        }

        guard fetchError == nil,
              process(remoteConfig) else{
            fxd_log()
            fxdPrint(fetchError)
            fxdPrint("reAttemptLimit: \(reAttemptLimit)")

            if reAttemptLimit == 0 {
                await MainActor.run {
                    didUpdateConfig = true
                }
                return
            }


            try await Task.sleep(nanoseconds: UInt64((1.0 * 1_000_000_000).rounded()))
            return try await fetchRemoteConfig(reAttemptLimit: reAttemptLimit-1)
        }


        await MainActor.run {
            didUpdateConfig = true
        }
    }
}

extension Analytics {
    public class func nonDebugLogEvent(_ name: String, parameters: [String:Any]) {
#if !DEBUG
        Self.logEvent(name, parameters: parameters)
#endif
    }
}
