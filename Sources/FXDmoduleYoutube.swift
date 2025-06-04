import Foundation

public let ENDPOINT_YOUTUBE_SEARCH = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&key=%@"

public let NODE_YOUTUBE_ROOT = "items"

public let KEY_VIDEO_ID = "videoId"
public let KEY_VIDEO_CHANNEL = "channelTitle"
public let KEY_VIDEO_PUBLISHED_AT = "publishedAt"
public let KEY_VIDEO_TITLE = "title"
public let KEY_VIDEO_THUMBNAIL = "thumbnail"

class FXDmoduleYoutube: NSObject, @unchecked Sendable {

	var apikeyGoogleForBrowser: String?

	func searchYouTubeUsing(artist: String?, song: String?, album: String?, callback: @escaping (@Sendable (Bool, Any?) -> Void)) {	fxd_log()

		fxdPrint(artist as Any)
		fxdPrint(song as Any)
		fxdPrint(album as Any)

		let query: String = "\(artist ?? "") \(song ?? "") \(album ?? "")"
		fxdPrint(query)

		guard  query.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
			callback(false, nil)
			return
		}

		guard self.apikeyGoogleForBrowser != nil else {
			callback(false, nil)
			return
		}

		let percentEscaped = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		fxdPrint(percentEscaped)

		let formattedString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(percentEscaped))&key=\(self.apikeyGoogleForBrowser!)"
		fxdPrint(formattedString)

		let request = URLRequest(url: URL(string: formattedString)!)
		fxdPrint(request)

		let searchTask = URLSession.shared.dataTask(with: request) {
			(data: Data?, response: URLResponse?, error: Error?) in

			fxdPrint(data)
			fxdPrint(response)
			fxdPrint(error)

			var results: [Any]?

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				results = (jsonObject as! [String: Any])[NODE_YOUTUBE_ROOT] as? [Any]
			} catch {
				fxdPrint("\(error)")
			}

			callback(error == nil, results as Any)
		}

		searchTask.resume()
	}
}
