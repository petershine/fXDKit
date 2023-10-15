

import Foundation


extension URLSession {
	public func cancellableRandomImageRetrieving(imageURL: URL, asyncOperation: BlockOperation?) -> UIImage? {

		assert((Thread.isMainThread == false || asyncOperation == nil), "\(#function) : Thread.isMainThread : \(Thread.isMainThread), asyncOperation == nil : \(asyncOperation == nil)")
		guard (Thread.isMainThread == false || asyncOperation == nil) else {
			return nil	// while this operation is synchronous, it should be run inside non-mainThread, for data transferring and data transforming
		}


		var randomImageData: Data? = nil

		let synchronousRequestSemaphore = DispatchSemaphore(value: 0)
		self.dataTask(with: URLRequest(url: imageURL)) {
			(received, response, error) in
			randomImageData = received

			synchronousRequestSemaphore.signal()
		}.resume()
		let result = synchronousRequestSemaphore.wait(timeout: .distantFuture)
		fxdPrint("[\(#function)] semaphore result : \(result)")

		guard (asyncOperation == nil || asyncOperation!.isCancelled == false)
			else {
			fxdPrint("[\(#function)] cancelled during transferring: \(!(asyncOperation == nil || asyncOperation!.isCancelled == false))")
				return nil
		}

		guard randomImageData != nil else {
			fxdPrint("[\(#function)] randomArtData : \(String(describing: randomImageData))")
			return nil
		}


		let  randomImage: UIImage? = UIImage(data: randomImageData!)
		
		guard (asyncOperation == nil || asyncOperation!.isCancelled == false)
			else {
			fxdPrint("[\(#function)] cancelled during transforming : \(!(asyncOperation == nil || asyncOperation!.isCancelled == false))")
				return nil
		}


		return randomImage
	}
}
