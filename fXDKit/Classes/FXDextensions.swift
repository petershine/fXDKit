
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

extension UIApplication {
	@objc public class func mainWindow() -> UIWindow? {
		var mainWindow: UIWindow? = nil

		let appDelegate = self.shared.delegate

		if (appDelegate?.responds(to: #selector(getter: UIApplicationDelegate.window)))! {
			mainWindow = (appDelegate?.window)!
		}

		return mainWindow
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

		if presentingScene == nil {

			// Traverse to find the right presentingScene (live rootViewController in the most front window)
			for window in UIApplication.shared.windows.reversed() {
				if window != UIApplication.shared.keyWindow {
					continue
				}

				
				if window.rootViewController != nil {
					presentingScene = window.rootViewController!
					break
				}
			}
		}

		DispatchQueue.main.async {
			presentingScene?.present(alert,
			                         animated: true,
			                         completion: nil)
		}
	}
}
