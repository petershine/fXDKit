import Foundation
import UIKit

let userdefaultObjSavedUbiquityIdentityToken = "SavedUbiquityIdentityTokenObjKey"
let userdefaultStringSavedUbiquityContainerURL = "SavedUbiquityContainerURLstringKey"

class FXDmoduleCloud: NSObject, @unchecked Sendable {
	var statusCallback: FXDcallback?

	var containerIdentifier: String?
	var containerURL: URL?

	deinit {
		statusCallback = nil
	}

    @MainActor open func prepareContainerURLwithIdentifier(_ containerIdentifier: String?, withStatusCallback statusCallback: FXDcallback?) {	fxd_log()
		fxdPrint("containerIdentifier: ", containerIdentifier)
		fxdPrint("statusCallback: ", statusCallback)

		self.containerIdentifier = containerIdentifier
		self.statusCallback = statusCallback

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(
			self,
			selector: #selector(observedNSUbiquityIdentityDidChange(_:)),
			name: NSNotification.Name.NSUbiquityIdentityDidChange,
			object: nil)

		observedNSUbiquityIdentityDidChange(nil)
	}

    @MainActor open func notifyCallback(withContainerURL containerURL: URL?, withAlertBody alertBody: String?) {	fxd_log()
		if alertBody?.isEmpty ?? false {
			UIAlertController.simpleAlert(
				withTitle: alertBody,
				message: nil)
		}

		statusCallback?((containerURL != nil), containerURL)
	}

    @MainActor @objc open func observedNSUbiquityIdentityDidChange(_ notification: Notification?) {	fxd_log()
		fxdPrint("notification: ", notification)

		fxdPrint("FileManager.default.ubiquityIdentityToken: ", FileManager.default.ubiquityIdentityToken)

		guard FileManager.default.ubiquityIdentityToken != nil else {
			notifyCallback(
				withContainerURL: nil,
				withAlertBody: NSLocalizedString("Please enable iCloud", comment: ""))
			return
		}

		let savedIdentityTokenData = UserDefaults.standard.object(forKey: userdefaultObjSavedUbiquityIdentityToken) as? Data

		var identityToken: (NSCoding & NSCopying & NSObjectProtocol)?
		do {
			identityToken = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSCoding.self, NSCopying.self, NSObjectProtocol.self], from: savedIdentityTokenData!) as? any NSCoding & NSCopying & NSObjectProtocol
		} catch {
			fxdPrint("\(error)")
		}

		fxdPrint("identityToken: ", identityToken)
		fxdPrint("identityToken?.isEqual(fileManager.ubiquityIdentityToken): ", identityToken?.isEqual(FileManager.default.ubiquityIdentityToken))

		if identityToken == nil
			|| identityToken!.isEqual(FileManager.default.ubiquityIdentityToken) == false {

			do {
				let defaultIdentityToken: Any = FileManager.default.ubiquityIdentityToken as Any
				let defaultIdentityTokenData = try NSKeyedArchiver.archivedData(withRootObject: defaultIdentityToken, requiringSecureCoding: false)

				UserDefaults.standard.setValue(defaultIdentityTokenData, forKey: userdefaultObjSavedUbiquityIdentityToken)
				UserDefaults.standard.synchronize()
			} catch {
				fxdPrint("\(error)")
			}
		}

		let savedContainerURL = UserDefaults.standard.object(forKey: userdefaultStringSavedUbiquityContainerURL) as? String
		containerURL = NSURL.evaluatedURLforPath(savedContainerURL)
		fxdPrint("containerURL: ", containerURL)

		let containerURLupdatingQueue = OperationQueue.newSerialQueue(withName: #function)

		containerURLupdatingQueue?.addOperation {	fxd_log()
			fxdPrint("containerIdentifier: ", self.containerIdentifier)

			let ubiquityContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: self.containerIdentifier)
			fxdPrint("ubiquityContainerURL: ", ubiquityContainerURL)

			DispatchQueue.main.async {	fxd_log()
				guard ubiquityContainerURL != nil
						|| self.containerURL != nil
				else {
					self.notifyCallback(
						withContainerURL: nil,
						withAlertBody: NSLocalizedString("iCloud cannot be activated currently", comment: ""))
					return
				}

				UserDefaults.standard.setValue(ubiquityContainerURL?.absoluteString, forKey: userdefaultStringSavedUbiquityContainerURL)
				UserDefaults.standard.synchronize()

				self.containerURL = ubiquityContainerURL
				fxdPrint("", FileManager.default.infoDictionary(forFolderURL: self.containerURL))

				self.notifyCallback(
					withContainerURL: self.containerURL,
					withAlertBody: nil)
			}
		}
	}
}
