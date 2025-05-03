

import Foundation
import UIKit

import SwiftUI


extension CharacterSet {
    public static var urlQueryValueAllowed: CharacterSet {
        var queryValueAllowed = Self.urlQueryAllowed
        queryValueAllowed.remove(charactersIn: ";/?:@&=+$, ")
        return queryValueAllowed
    }
}


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

extension Encodable {
	public func encoded() -> Data? {
		var encoded: Data? = nil
		do {
			encoded = try JSONEncoder().encode(self)
		}
		catch {	fxd_log()
			fxdPrint(error)
		}

		return encoded
	}
}


import UniformTypeIdentifiers

extension FileManager {
	public func fileURLs(contentType: UTType) -> [URL]? {
		guard  let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}

		var fileURLs: [URL]? = nil
		do {
			let contents = try FileManager.default.contentsOfDirectory(
				at: documentDirectory,
				includingPropertiesForKeys: [.contentModificationDateKey, .contentTypeKey],
				options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])

			fileURLs = try contents
				.filter {
					let resourceValues: URLResourceValues = try $0.resourceValues(forKeys: [.contentTypeKey])
					return resourceValues.contentType == contentType
				}
				.sorted {
					let resourceValues_0: URLResourceValues = try $0.resourceValues(forKeys: [.contentModificationDateKey])
					let resourceValues_1: URLResourceValues = try $1.resourceValues(forKeys: [.contentModificationDateKey])
					return resourceValues_0.contentModificationDate  ?? Date.now > resourceValues_1.contentModificationDate ?? Date.now
				}
		}
		catch {	fxd_log()
			fxdPrint(error)
		}

		return fileURLs
	}
}


extension IndexPath {
	public var stringKey: String {
		return "\(row)_\(section)"
	}
}


extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: Bool.Type, otherType: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        if let boolValue = try? self.decodeIfPresent(type, forKey: key) {
            return boolValue
        }

        if let stringValue = try? self.decodeIfPresent(otherType, forKey: key) {
            return stringValue.lowercased() == "true"
        }

        
        let debugDescription = "Could not decode Bool or String"
        let error = DecodingError.Context(codingPath: self.codingPath + [key], debugDescription: debugDescription)
        fxdPrint(error)
        throw DecodingError.dataCorrupted(error)
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

	public func jsonDictionary() -> Dictionary<String, Any?>? {
		var jsonDictionary: [String:Any?] = [:]
		
		let parameters = self.components(separatedBy: ",")
		for parameter in parameters {
			let key_value = parameter.components(separatedBy: ":")

			let key: String = key_value.first?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
			if !key.isEmpty {
				let value: String = key_value.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
				if let doubleValue = Double(value) {
					jsonDictionary[key] = doubleValue
				}
				else if let integerValue = Int(value) {
					jsonDictionary[key] = integerValue
				}
				else if let boolValue = Bool(value.lowercased()) {
					jsonDictionary[key] = boolValue
				}
				else {
					jsonDictionary[key] = value
				}
			}
		}

		return (jsonDictionary.count == 0) ? nil : jsonDictionary
	}

	public func condensed() -> String? {
		var condensed = self.trimmingCharacters(in: .whitespacesAndNewlines)
		condensed = condensed.replacingOccurrences(of: " +", with: " ", options: String.CompareOptions.regularExpression, range: nil)
		condensed = condensed.replacingOccurrences(of: "\n", with: "")
		return condensed
	}

	//https://stackoverflow.com/a/56706114/259765
	public func removingAllWhitespaces() -> String? {
		return removingCharacters(from: .whitespacesAndNewlines)
	}

	public func removingCharacters(from set: CharacterSet) -> String? {
		var newString = self
		newString.removeAll { char -> Bool in
			guard let scalar = char.unicodeScalars.first else { return false }
			return set.contains(scalar)
		}
		return newString
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
	@MainActor public class func show(items: [Any]) {
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
                ptr in String(validatingCString: ptr)
			}
		}

		return machineNameCode
	}
}


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


extension URL {
    public static func newFileURL(prefix: String, index: Int? = nil, contentType: UTType) -> URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH_mm_ss"

        let fileName = dateFormatter.string(from: Date.now)
        let fileSuffix = "\(index != nil ? "_\(index ?? 0)" : "")"
        let fileExtension = "\(contentType.preferredFilenameExtension ?? contentType.identifier.components(separatedBy: ".").last ?? "data")"
        
        let filePath = "\(prefix)_\(fileName)\(fileSuffix).\(fileExtension)"
        let fileURL = documentDirectory?.appendingPathComponent(filePath)
        return fileURL
    }

    public func pairedFileURL(inSubPath: String? = nil, contentType: UTType) -> URL {
        var pairedFile = self.deletingPathExtension()
        let filenameComponent = pairedFile.lastPathComponent
        pairedFile.deleteLastPathComponent()
        if let inSubPath {
            pairedFile.append(component: inSubPath)
        }
        pairedFile.append(components: filenameComponent)
        pairedFile.appendPathExtension(contentType.preferredFilenameExtension ?? contentType.identifier.components(separatedBy: ".").last ?? "data")

        return pairedFile
    }

    public var jsonURL: URL {
        return self.pairedFileURL(inSubPath: nil, contentType: .json)
    }

    public var thumbnailURL: URL {
        let thumbnail = self.pairedFileURL(inSubPath: "_thumbnail", contentType: .png)

        return thumbnail
    }
}


extension UNUserNotificationCenter {
    public static func attemptAuthorization() async -> (UNAuthorizationStatus, Error?) {
        var authorized: Bool = false
        var authorizationError: Error? = nil
        do {
            authorized = try await Self.current().requestAuthorization(options: [.badge, .sound, .alert])
        }
        catch {
            authorizationError = error
        }

        if authorized {
            fxd_log()
            await fxdPrint("UIApplication.shared.isRegisteredForRemoteNotifications:", UIApplication.shared.isRegisteredForRemoteNotifications)
            await UIApplication.shared.registerForRemoteNotifications()
        }


        let settings = await Self.current().notificationSettings()
        return (settings.authorizationStatus, authorizationError)
    }

    public static func attemptLocalNotification(content: UNNotificationContent) {
        let completionHandler: @Sendable (Bool, (any Error)?) -> Void = {
            (success, error) in

            fxd_log()
            guard success else {
                fxdPrint(error)
                return
            }


            fxdPrint(content)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            fxdPrint(trigger)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            fxdPrint(request)

            Self.current().add(request)
        }


        Task {
            let (authorized, authorizationError) = await Self.attemptAuthorization()
            completionHandler(authorized == .authorized, authorizationError)
        }
    }
}
