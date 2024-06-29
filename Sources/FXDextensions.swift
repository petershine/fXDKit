

import Foundation
import UIKit


extension Data {
	public func decode<T>(_ type: T.Type) -> T? where T : Decodable {
		var decoded: T? = nil
		do {
			decoded = try JSONDecoder().decode(type, from: self)
		}
		catch {	fxd_log()
			fxdPrint(error)
		}

		return decoded
	}

	public func jsonDictionary(quiet: Bool = false) -> Dictionary<String, Any?>? {
		let jsonDictionary: Dictionary<String, Any?>? = self.jsonObject(quiet: quiet) as? Dictionary<String, Any?>
		return jsonDictionary
	}

	public func jsonObject(quiet: Bool = false) -> Any? {
		var jsonObject: Any? = nil
		do {
			jsonObject = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
		}
		catch {	fxd_log()
			if let stringObject = String(data: self, encoding: .utf8) {
				fxdPrint(stringObject)
			}
			fxdPrint(error)
		}

		return jsonObject
	}
}


extension Date {
	public func formattedAgeText(since: Date = Date.init()) -> String? {

		let age = Int((since.timeIntervalSince1970) - timeIntervalSince1970)
		let days = Int(age/60/60/24)

		var ageText: String? = nil

		if days > 7 {
			ageText = description.components(separatedBy: " ").first
		}
		else if days > 0 && days <= 7 {
			ageText = "\(days) day"

			if (days > 1) {
				ageText = ageText! + "s"
			}
		}
		else {
			let seconds = age % 60
			let minutes = (age/60) % 60
			let hours = (age/60/60) % 24

			ageText = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
		}

		return ageText
	}
}

extension Double {
	public func formattedDistanceText(format: String = "%0.1f") -> String? {
		var distanceText: String? = nil

		if self >= 1000.0 {
			distanceText = String(format: format + " km", self/1000.0)
		}
		else {
			distanceText = String(format: format + " m", self)
		}

		//TODO: use miles for US users

		return distanceText
	}
}

extension IndexPath {
	public var stringKey: String {
		return "\(row)_\(section)"
	}
}

extension String {
	public func sharableMessageWith(videoId: String?) -> String? {
		var formatted = self

		let videoPath = (videoId != nil && (videoId?.count)! > 0) ? "\(HOST_SHORT_YOUTUBE)\(videoId!)" : ""

		guard let swiftrange = formatted.range(of: HOST_SHORT_YOUTUBE) else {
			return "\(formatted) \(videoPath)".trimmingCharacters(in: .whitespacesAndNewlines)
		}


		var replacingRange = NSRange(swiftrange, in: formatted)
		replacingRange.length = videoPath.count //MARK: Assume every short url is same length
		if let swiftrange = Range(replacingRange, in: formatted) {
			formatted = formatted.replacingCharacters(in: swiftrange, with: videoPath).trimmingCharacters(in: .whitespacesAndNewlines)
		}

		return formatted
	}

	public func sharableMessageWith(appConfig: FXDprotocolAppConfig) -> String? {
		var formatted = self

		let appendedLinkArray = [
			" via \(appConfig.homeURL)",
			" \(appConfig.homeURL)",

			" via \(appConfig.shortHomeURL)",
			" \(appConfig.shortHomeURL)",

			" via \(appConfig.twitterName)",
			" \(appConfig.twitterName)",
		]

		for appendedLink in appendedLinkArray {
			if formatted.count + appendedLink.count <= MAXIMUM_LENGTH_TWEET {
				formatted = formatted + appendedLink
				break
			}
		}

		return formatted
	}

	public func processedJSONData() -> Data? {
		var resultString = ""
		var isInQuotes = false
		var previousCharacter: Character?

		for character in self {
			switch character {
			case "\"":
				if previousCharacter != "\\" {
					isInQuotes = !isInQuotes
				}
				resultString.append(character)
			case "\n", "\r":
				if isInQuotes {
					resultString.append("\\n")
				} else {
					resultString.append(character)
				}
			default:
				resultString.append(character)
			}
			previousCharacter = character
		}

		return resultString.isEmpty ? nil : resultString.data(using: .utf8)
	}

	public func lineReBroken() -> String {
		guard self.contains("\\n") else {
			return self
		}

		let reBroken = self.replacingOccurrences(of: "\\n", with: "\n")
		return reBroken.lineReBroken()
	}

	public func decodedImage() -> UIImage? {
		guard let imageData = Data(base64Encoded: self) else {
			return nil
		}

		guard let decoded = UIImage(data: imageData) else {
			return nil
		}

		return decoded
	}
}

extension Bundle {
	@objc public class func bundleVersion() -> String? {
		return self.main.infoDictionary?["CFBundleVersion"] as? String
	}

	@objc public class func bundleDisplayName() -> String? {
		return self.main.infoDictionary?["CFBundleDisplayName"] as? String
	}
}


extension UIActivityViewController {
	public class func show(items: [Any]) {
		guard let rootViewController = UIApplication.shared.mainWindow()?.rootViewController else {
			return
		}


		let activityController = Self(activityItems: items, applicationActivities: nil)
		if let popoverController = activityController.popoverPresentationController {
			let sourceRectCenter = CGPoint(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY)

			popoverController.sourceView = rootViewController.view
			popoverController.sourceRect = CGRect(origin: sourceRectCenter, size: CGSize(width: 1, height: 1))
			popoverController.permittedArrowDirections = []
		}

		rootViewController.present(activityController, animated: true)
	}
}

extension UIAlertController {
	@objc public class func errorAlert(error: Error?, title: String? = nil, message: String? = nil) {
		let failureReason: String = (error as? NSError)?.userInfo[NSLocalizedFailureReasonErrorKey] as? String ?? error?.localizedDescription ?? ""
		let alertMessage = message ?? failureReason
		let alertTitle = title ?? error?.localizedDescription ?? ""

		guard !alertTitle.isEmpty && !alertMessage.isEmpty else {
			return
		}

		self.simpleAlert(withTitle: alertTitle, message: alertMessage)
	}

	@objc public class func simpleAlert(withTitle title: String?, 
										message: String?,
										fromScene: UIViewController? = nil,
										destructiveText: String? = nil,
										cancelText: String? = NSLocalizedString("OK", comment: ""),
										destructiveHandler: ((UIAlertAction) -> Swift.Void)? = nil,
										cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil) {

		let alert = UIAlertController(title: title,
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
			presentingScene?.present(alert,
									 animated: true,
									 completion: nil)
		}
	}
}



extension UIApplication {
	@objc public func mainWindow() -> UIWindow? {
		return connectedScenes
			.flatMap {($0 as? UIWindowScene)?.windows ?? [] }
			.first {$0.isKeyWindow }
	}

	@objc public func openContactEmail(email: String) {
		let mailToPath = "mailto:\(email)"

		let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "(unknown bundlen name)"
		let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "(unknown bundle version)"

		var body: String = "\n\n\n\n\n_______________________________\n"
		body += "\(displayName) \(appVersion)\n"
		body += "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)\n"

		if let mailToURL = URL(string: mailToPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
			Self.shared.open(mailToURL, options: [:], completionHandler: nil)
		}
	}
}


extension UIDevice {
	@objc public class func machineNameCode() -> String? {
		/*
		struct utsname systemInfo;
		uname(&systemInfo);

		NSString *machineName = @(systemInfo.machine);
		*/

		var systemInfo = utsname()
		uname(&systemInfo)
		let machineNameCode = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}

		return machineNameCode
	}
}


import SwiftUI

extension UIImage {
	public func aspectSize(for contentMode: ContentMode, containerSize: CGSize) -> CGSize {

		let aspectRatio = self.size.width/self.size.height

		let isVerticalImage = self.size.width < self.size.height
		let isVerticalContainer = containerSize.width < containerSize.height


		var aspectSize: CGSize = self.size

		if contentMode == .fit {
			let minDimension = min(containerSize.width, containerSize.height)

			if (isVerticalImage && isVerticalContainer)
				|| (!isVerticalImage && isVerticalContainer) {
				aspectSize = CGSize(width: minDimension, height: minDimension/aspectRatio)
			}
			else if (isVerticalImage && !isVerticalContainer)
						|| (!isVerticalImage && !isVerticalContainer) {
				aspectSize = CGSize(width: minDimension*aspectRatio, height: minDimension)
			}
		}
		else {
			let maxDimension = max(containerSize.width, containerSize.height)

			if (isVerticalImage && isVerticalContainer)
				|| (!isVerticalImage && isVerticalContainer) {
				aspectSize = CGSize(width: maxDimension*aspectRatio, height: maxDimension)
			}
			else if (isVerticalImage && !isVerticalContainer)
						|| (!isVerticalImage && !isVerticalContainer) {
				aspectSize = CGSize(width: maxDimension, height: maxDimension/aspectRatio)
			}
		}

		return aspectSize
	}
}
