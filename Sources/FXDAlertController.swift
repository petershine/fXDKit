

import AVKit


extension UIAlertController {
    @objc public class func errorAlert(error: Error?, title: String? = nil, message: String? = nil) {
        guard error != nil else {
            return
        }

        let failureReason: String = (error as? NSError)?.userInfo[NSLocalizedFailureReasonErrorKey] as? String ?? error?.localizedDescription ?? ""
        let alertMessage = message ?? failureReason
        let alertTitle = title ?? error?.localizedDescription ?? ""

        guard !alertTitle.isEmpty || !alertMessage.isEmpty else {
            return
        }

        self.simpleAlert(withTitle: alertTitle, message: alertMessage)
    }

    @objc public class func simpleAlert(
        withTitle title: String?,
        message: String?,
        soundNumber: Int = 0,
        fromScene: UIViewController? = nil,
        destructiveText: String? = nil,
        cancelText: String? = NSLocalizedString("OK", comment: ""),
        destructiveHandler: ((UIAlertAction) -> Void)? = nil,
        cancelHandler: ((UIAlertAction) -> Void)? = nil) {

            let alert = Self(title: title,
                             message: message,
                             preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: cancelText,
                                             style: .cancel,
                                             handler: cancelHandler)
            alert.addAction(cancelAction)


            if !(destructiveText?.isEmpty ?? true)
                && destructiveHandler != nil {
                let destructiveAction = UIAlertAction(title: destructiveText,
                                                      style: .destructive,
                                                      handler: destructiveHandler)
                alert.addAction(destructiveAction)
            }



            var presentingScene: UIViewController? = fromScene

            if presentingScene == nil,
               let mainWindow = UIApplication.shared.mainWindow(),
               mainWindow.rootViewController != nil {
                presentingScene = mainWindow.rootViewController
            }

            DispatchQueue.main.async {
                if soundNumber != 0 {
                    AudioServicesPlaySystemSound(SystemSoundID(soundNumber))
                }
                presentingScene?.present(alert,
                                         animated: true,
                                         completion: nil)
            }
        }

    public class func asyncAlert<T>(
        withTitle title: String?,
        message: String? = nil,
        soundNumber: Int = 0,
        fromScene: UIViewController? = nil,
        cancelText: String? = NSLocalizedString("OK", comment: ""),
        cancelHandler: ((UIAlertAction) -> (T, Error?))? = nil,
        destructiveText: String? = nil,
        destructiveHandler: ((UIAlertAction) -> (T, Error?))? = nil
    ) async throws -> sending T? {

        let didProceed = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<T?, any Error>) in

            let alert = Self(title: title,
                             message: message,
                             preferredStyle: .alert)

            let cancelAction = UIAlertAction(
                title: cancelText,
                style: .cancel,
                handler: {
                    action in

                    guard let cancelHandler else {
                        continuation.resume(returning: nil)
                        return
                    }


                    let (result, error) = cancelHandler(action)
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    else {
                        continuation.resume(returning: result)
                    }
                })
            alert.addAction(cancelAction)


            if !(destructiveText?.isEmpty ?? true),
               let destructiveHandler {
                let destructiveAction = UIAlertAction(
                    title: destructiveText,
                    style: .destructive,
                    handler: {
                        action in

                        let (result, error) = destructiveHandler(action)
                        if let error {
                            continuation.resume(throwing: error)
                        }
                        else {
                            continuation.resume(returning: result)
                        }
                    })
                alert.addAction(destructiveAction)
            }


            var presentingScene: UIViewController? = fromScene

            if presentingScene == nil,
               let mainWindow = UIApplication.shared.mainWindow(),
               mainWindow.rootViewController != nil {
                presentingScene = mainWindow.rootViewController
            }

            if soundNumber != 0 {
                AudioServicesPlaySystemSound(SystemSoundID(soundNumber))
            }
            presentingScene?.present(alert,
                                     animated: true,
                                     completion: nil)
        }

        return didProceed
    }
}
