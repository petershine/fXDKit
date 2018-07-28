

import CoreLocation

import TwitterCore
import TwitterKit


//TODO: Prepare formatter function
//#define urlrootTwitterAPI			@"https://api.twitter.com/1.1/"
//#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]
//#define urlstringTwitterUserShow		urlstringTwitter(@"users/show.json")
//#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")
let objkeyTwitterScreenName = "screen_name"
let objkeyTwitterStatus = "status"
let objkeyTwitterLat = "lat"
let objkeyTwitterLong = "long"
let objkeyTwitterPlaceId = "place_id"
let objkeyTwitterDisplayCoordinates = "display_coordinates"


open class FXDmoduleTwitter: NSObject {
	
	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Twitter account", comment: "")

	@objc public var authenticatedSession: TWTRAuthSession? {
		return TWTRTwitter.sharedInstance().sessionStore.session()
	}


	@objc required public init(withTwitterKey twitterKey: String!, twitterSecret: String!) {	fxd_log_func()
		super.init()

		TWTRTwitter.sharedInstance().start(withConsumerKey: twitterKey!, consumerSecret: twitterSecret!)
	}

	@objc public func signInBySelectingAccount(presentingScene: UIViewController, callback: @escaping FXDcallback) {	fxd_log_func()

		fxdPrint(self.authenticatedSession?.authToken as Any)
		fxdPrint(self.authenticatedSession?.authTokenSecret as Any)
		fxdPrint(self.authenticatedSession?.userID as Any)

		guard TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() == false else {
			self.showActionSheet(presentingScene: presentingScene, callback: callback)
			return
		}


		TWTRTwitter.sharedInstance().logIn(completion: {
			[weak self] (session, error) in

			guard session == nil else {
				fxdPrint("signed in as \(String(describing: session?.userName))")

				UIAlertController.simpleAlert(withTitle: "Signed in as\n \"\(session!.userName)\"",
											  message: nil)

				callback(true, nil)
				return
			}


			fxdPrint("error: \(String(describing: error?.localizedDescription))")
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please grant Twitter access in Settings", comment: ""),
										  message: self?.reasonForConnecting)
			callback(false, nil)
		})
	}


	func showActionSheet(presentingScene: UIViewController, callback: @escaping FXDcallback) {	fxd_log_func()
		fxdPrint(self.authenticatedSession as Any)

		let sessionStore: TWTRSessionStore = TWTRTwitter.sharedInstance().sessionStore

		guard sessionStore.hasLoggedInUsers() == true else {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please sign up for a Twitter account", comment: ""),
			                              message: self.reasonForConnecting)

			callback(false, nil)
			return
		}


		fxdPrint("sessionStore.existingUserSessions: \(sessionStore.existingUserSessions())")
		fxdPrint("sessionStore.existingUserSessions().count: \(sessionStore.existingUserSessions().count)")

		var alertController: UIAlertController? = nil

		if sessionStore.existingUserSessions().count > 1 {
			alertController = UIAlertController(
				title: NSLocalizedString("Please select your Twitter Account", comment: ""),
				message: nil,
				preferredStyle: .actionSheet)
		}
		else {
			alertController = UIAlertController(
				title: NSLocalizedString("Do you want to Sign-out?", comment: ""),
				message: nil,
				preferredStyle: .alert)
		}

		let cancelAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Cancel", comment: ""),
			style: .cancel) {
				(action: UIAlertAction) in

				callback(false, nil)
		}
		
		
		let signOutAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				[weak self] (action: UIAlertAction) in

                guard let userID = self?.authenticatedSession?.userID else {
                    callback(false, nil)
                    return
                }

				sessionStore.logOutUserID(userID)
				callback(true, nil)
		}

		alertController?.addAction(cancelAction)
		alertController?.addAction(signOutAction)

		if sessionStore.existingUserSessions().count > 1 {
			//TODO: 'Could not cast value of type 'TWTRSession' (0x105c6e370) to 'TWTRSession' (0x1059a5cc8).'
			for account: TWTRSession in sessionStore.existingUserSessions() as! [TWTRSession] {

				let selectAction: UIAlertAction = UIAlertAction(
					title: String("@\(account.userName)"),
					style: .default,
					handler: {
						(action: UIAlertAction) in

						callback(true, nil)
				})

				alertController?.addAction(selectAction)
			}
		}

		presentingScene.present(alertController!, animated: true, completion: nil)
	}


	//MARK: Twitter specific
	func twitterUserShow(withScreenName screenName: String) {	fxd_log_func()

		fxdPrint(self.authenticatedSession as Any)

		guard TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() == true else {
			return
		}


		let method = "GET"
		let requestURL: URL = URL(string: "https://api.twitter.com/1.1/users/show.json")!
		let parameters: Dictionary = [objkeyTwitterScreenName: screenName]

		let client = TWTRAPIClient(userID: self.authenticatedSession?.userID)
		var clientError : NSError?

		let request = client.urlRequest(withMethod: method,
										urlString: requestURL.absoluteString,
										parameters: parameters,
										error: &clientError)

		client.sendTwitterRequest(request) {
			(response, data, connectionError) in
			
			if connectionError != nil {
				fxdPrint("Error: \(String(describing: connectionError))")
			}

			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				fxdPrint("json: \(json)")
			} catch let jsonError as NSError {
				fxdPrint("json error: \(jsonError.localizedDescription)")
			}

			fxdPrint(data as Any)
			fxdPrint(response as Any)
			fxdPrint(connectionError as Any)

			//TODO: Reconsider bringing evaluation to be more generic function
		}
	}

	@objc public func twitterStatusUpdate(withTweetText tweetText: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeId: String?, callback: @escaping FXDcallback) {	fxd_log_func()

		fxdPrint(self.authenticatedSession as Any)

		guard TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() == true else {
			callback(false, nil)
			return
		}


		let method = "POST"
		let requestURL: URL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!

		var parameters: Dictionary<String, Any> = [objkeyTwitterStatus: tweetText ?? ""]
		parameters[objkeyTwitterDisplayCoordinates] = "true"

		if latitude != 0.0 && longitude != 0.0 {
			parameters[objkeyTwitterLat] = String(latitude)
			parameters[objkeyTwitterLong] = String(longitude)
		}

		if placeId != nil {
			parameters[objkeyTwitterPlaceId] = placeId
		}


		let client = TWTRAPIClient(userID: self.authenticatedSession?.userID)
		var clientError : NSError?

		let request = client.urlRequest(withMethod: method,
										urlString: requestURL.absoluteString,
										parameters: parameters,
										error: &clientError)

		client.sendTwitterRequest(request) {
			(response, data, connectionError) in

			if connectionError != nil {
				fxdPrint("Error: \(String(describing: connectionError))")
			}

			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				fxdPrint("json: \(json)")
			} catch let jsonError as NSError {
				fxdPrint("json error: \(jsonError.localizedDescription)")
			}

			fxdPrint(data as Any)
			fxdPrint(response as Any)
			fxdPrint(connectionError as Any)

			//TODO: Reconsider bringing evaluation to be more generic function

			callback(connectionError == nil, nil)
		}
	}
}
