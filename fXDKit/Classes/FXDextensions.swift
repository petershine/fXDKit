
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
}

extension UIStoryboardSegue {
	@objc public func fullDescription() -> Dictionary<String, Any>? {
		var fullDescription: Dictionary<String, Any>? = [:]

		if (self.identifier?.count)! > 0 {
			fullDescription!["identifier"] = self.identifier!
		}

		fullDescription!["source"] = self.source
		fullDescription!["destination"] = self.destination
		fullDescription!["class"] = self.description
		
		return fullDescription
	}
}

extension UIAlertController {
	@objc public class func simpleAlert(withTitle title: String?, message: String?) {
		self.simpleAlert(withTitle: title,
		                 message: message,
		                 cancelText: nil,
		                 fromScene: nil,
		                 handler: nil)
	}

	@objc public class func simpleAlert(withTitle title: String?, message: String?,
	                             cancelText: String?,
	                             fromScene: UIViewController?,
	                             handler: ((UIAlertAction) -> Swift.Void)?) {

		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: ((cancelText != nil) ? cancelText! : NSLocalizedString("OK", comment: "")),
		                                 style: .cancel,
		                                 handler: handler)

		alert.addAction(cancelAction)


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
		let foundWindow: UIWindow? = windows.filter {
			(window) -> Bool in
			return window.isKeyWindow
		}.first

		return foundWindow
	}

	@objc public static func openContactEmail(email: String) {
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
