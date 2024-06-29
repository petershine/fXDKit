

import MessageUI


open class FXDmoduleMessage: NSObject {
	func presentEmailScene(_ emailScene: MFMailComposeViewController?, forPresentingScene presentingScene: UIViewController?, using image: UIImage?, usingMessage message: String?, withRecipients recipients: [String]?) {	fxd_log()

		guard MFMailComposeViewController.canSendMail() else {
			//TODO: alert user
			return
		}


		var emailScene = emailScene
		if emailScene == nil {
			if (image != nil || message != nil) {
				emailScene = self.emailScene(forSharing: image, usingMessage: message)
			}
			else {
				emailScene = self.emailSceneWithMailBody(withRecipients: recipients)
			}
		}

		guard emailScene != nil else {
			//TODO: alert user
			return
		}


		var presentingScene = presentingScene
		if presentingScene == nil {
			presentingScene = UIApplication.shared.mainWindow()?.rootViewController
			fxdPrint(presentingScene as Any)
		}


		emailScene?.mailComposeDelegate = self

		presentingScene?.present(
			emailScene!,
			animated: true,
			completion: nil)
	}

	func emailSceneWithMailBody(withRecipients recipients: [String]?) -> MFMailComposeViewController! {	fxd_log()
#if DEBUG
		fxdPrint("Bundle.main.infoDictionary: ", Bundle.main.infoDictionary)
		fxdPrint("recipients: ", recipients)

		if let currentLanguage = (UserDefaults.standard.object(forKey: "AppleLanguages") as? Array<Any?>)?.first {
			fxdPrint("currentLanguage: ", currentLanguage)
		}
#endif


		let version = Bundle.bundleVersion()
		let displayName = Bundle.bundleDisplayName()

		let subjectLine = "[\(displayName ?? "")]"
		let lineSeparator = "_______________________________"
		let appVersionLine = "\(subjectLine) \(version ?? "")"
		let machineNameCode = UIDevice.machineNameCode()
		let machineNameLine = "\(machineNameCode ?? "") \(UIDevice.current.systemVersion)"
		let mailBody = "\n\n\n\n\n\(lineSeparator)\n\(appVersionLine)\n\(machineNameLine)\n"
		fxdPrint("mailBody: \(mailBody)")


		let emailScene = MFMailComposeViewController(navigationBarClass: nil, toolbarClass: nil)
		emailScene.setSubject(subjectLine)
		emailScene.setToRecipients(recipients ?? [])
		emailScene.setMessageBody(mailBody, isHTML: false)

		return emailScene
	}

	func emailScene(forSharing image: UIImage?, usingMessage message: String?) -> MFMailComposeViewController? {	fxd_log()

		let displayName = Bundle.bundleDisplayName()

		let subjectLine = "[\(displayName ?? "")]"


		let emailScene = MFMailComposeViewController(navigationBarClass: nil, toolbarClass: nil)
		emailScene.setSubject(subjectLine)

		if let jpegData = image?.jpegData(compressionQuality: 1.0) {
			emailScene.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "sharedImage")
		}

		if message != nil {
			emailScene.setMessageBody(message!, isHTML: false)
		}

		return emailScene
	}
}


extension FXDmoduleMessage: MFMailComposeViewControllerDelegate {
	public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {	fxd_log()

		fxdPrint(result)
		fxdPrint(error)

		controller.dismiss(animated: true, completion: nil)
	}
}
