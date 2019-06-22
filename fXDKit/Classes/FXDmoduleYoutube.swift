

public let urlformatYoutubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&key=%@"

public let objkeyVideoId = "videoId"
public let objkeyVideoChannel = "channelTitle"
public let objkeyVideoPublishedAt = "publishedAt"
public let objkeyVideoThumbnail = "thumbnail"
public let objkeyVideoTitle = "title"

public let HOST_SHORT_YOUTUBE: String = "youtu.be/"


class FXDmoduleYoutube: NSObject {

	var apikeyGoogleForBrowser: String?


	func searchYouTubeUsing(artist: String?, song: String?, album: String?, callback:@escaping FXDcallback) {	fxd_log()

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
			(data:Data?, response:URLResponse?, error:Error?) in

			fxdPrint(data as Any)
			fxdPrint(response as Any)
			fxdPrint(error as Any)


			var results:Array<Any>?

			do {
				let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)

				results = (jsonObject as! Dictionary<String, Any>)["items"] as? Array<Any>;
			}
			catch {
				//MARK://TODO
			}

			callback(error == nil, results as Any)
		}

		searchTask.resume()
	}
}
