

import Foundation


extension URLSession {
	public func synchronousURLRequest(urlRequest: URLRequest, asyncOperation: BlockOperation?, synchronousDataHandling:((Data?)->Void)?) {
		assert((Thread.isMainThread == false || asyncOperation == nil), "\(#function) : Thread.isMainThread : \(Thread.isMainThread), asyncOperation == nil : \(asyncOperation == nil)")
		guard (Thread.isMainThread == false || asyncOperation == nil) else {
			return	// while this operation is synchronous, it should be run inside non-mainThread, for data transferring and data transforming, without blocking mainThread
		}


		var retrievedData: Data? = nil

		let synchronousRequestSemaphore = DispatchSemaphore(value: 0)
		self.dataTask(with: urlRequest) {
			(data, response, error) in
			retrievedData = data

			if error != nil {
				fxdPrint("[\(#function)] error: \(String(describing: error))\nresponse: \(String(describing: response))")
			}

			synchronousRequestSemaphore.signal()
		}.resume()
		let result = synchronousRequestSemaphore.wait(timeout: .distantFuture)
		fxdPrint("[\(#function)] semaphore result : \(result)")

		fxdPrint("[\(#function)] cancelled during transferring: \(asyncOperation?.isCancelled ?? true)")
		fxdPrint("[\(#function)] retrievedData : \(String(describing: retrievedData))")

		synchronousDataHandling?(retrievedData)
	}


	public func synchronousImageRequest(urlRequest: URLRequest, asyncOperation: BlockOperation?) -> UIImage? {
		assert((Thread.isMainThread == false || asyncOperation == nil), "\(#function) : Thread.isMainThread : \(Thread.isMainThread), asyncOperation == nil : \(asyncOperation == nil)")
		guard (Thread.isMainThread == false || asyncOperation == nil) else {
			return nil	// while this operation is synchronous, it should be run inside non-mainThread, for data transferring and data transforming, without blocking mainThread
		}


		var retrievedImage: UIImage? = nil

		URLSession.shared.synchronousURLRequest(
			urlRequest: urlRequest,
			asyncOperation: asyncOperation,
			synchronousDataHandling: {
				(imageData) in
				guard imageData != nil else {
					return
				}

				guard (asyncOperation == nil || asyncOperation!.isCancelled == false) else {
					return
				}

				retrievedImage = UIImage(data: imageData!)
			})

		guard (asyncOperation == nil || asyncOperation!.isCancelled == false) else {
			fxdPrint("[\(#function)] cancelled during transforming : \(asyncOperation?.isCancelled ?? true)")
			return nil
		}

		return retrievedImage
	}
}


extension URLSession {
	public func startSerializedURLRequest(urlRequests: [URLRequest], progressConfiguration: FXDconfigurationInformation? = nil) async -> [(Data, URLResponse)] {
		guard urlRequests.count > 0 else {
			return []
		}

		var dataAndResponseArray: [(Data, URLResponse)] = []

		for (index, urlRequest) in urlRequests.enumerated() {
			do {
				let (data, response) = try await self.data(for: urlRequest)
				if (response as? HTTPURLResponse)?.statusCode == 200 {
					dataAndResponseArray.append((data, response))
				}

				DispatchQueue.main.async {
					progressConfiguration?.sliderValue = CGFloat(Float(index+1)/Float(urlRequests.count))
				}
			}
			catch {
				fxdPrint("\(error)")
			}
		}

		return dataAndResponseArray
	}
}
