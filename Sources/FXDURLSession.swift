import Foundation
import UIKit

extension URLSession {
	public func synchronousURLRequest(urlRequest: URLRequest, asyncOperation: BlockOperation?, synchronousDataHandling: ((Data?) -> Void)?) {
		guard Thread.isMainThread == false || asyncOperation != nil else {
			fxd_log()
			fxdPrint("while this operation is synchronous, it should be running inside non-mainThread, for data transferring and data transforming, without blocking mainThread")
			fxdPrint((Thread.isMainThread == false || asyncOperation != nil), "\(#function) : Thread.isMainThread : \(Thread.isMainThread), asyncOperation != nil : \(asyncOperation != nil)")
			synchronousDataHandling?(nil)
			return
		}

        actor FXDretrievedActor {
            nonisolated(unsafe) var data: Data?
        }

        let retrievedActor = FXDretrievedActor()

		let synchronousRequestSemaphore = DispatchSemaphore(value: 0)
		self.dataTask(with: urlRequest) {
			(data, response, error) in
            retrievedActor.data = data	// Mutation of captured var 'retrievedData' in concurrently-executing code

			if error != nil {
				fxdPrint("[\(#function)] error: ", error, "\nresponse: ", response)
			}

			synchronousRequestSemaphore.signal()
		}.resume()
		let result = synchronousRequestSemaphore.wait(timeout: .distantFuture)
		fxdPrint("[\(#function)] semaphore result : \(result)")

		fxdPrint("[\(#function)] cancelled during transferring: \(asyncOperation?.isCancelled ?? true)")
        fxdPrint("[\(#function)] retrievedData : ", retrievedActor.data)

        synchronousDataHandling?(retrievedActor.data)
	}

	public func synchronousImageRequest(urlRequest: URLRequest, asyncOperation: BlockOperation?) -> UIImage? {
		var retrievedImage: UIImage?

		self.synchronousURLRequest(
			urlRequest: urlRequest,
			asyncOperation: asyncOperation,
			synchronousDataHandling: {
				(imageData) in
				guard imageData != nil else {
					return
				}

				guard asyncOperation == nil || asyncOperation!.isCancelled == false else {
					return
				}

				retrievedImage = UIImage(data: imageData!)
			})

		guard asyncOperation == nil || asyncOperation!.isCancelled == false else {
			fxdPrint("[\(#function)] cancelled during transforming : \(asyncOperation?.isCancelled ?? true)")
			return nil
		}

		return retrievedImage
	}
}

public let TIMEOUT_DEFAULT = 60.0	// ... "The default timeout interval is 60 seconds." ...
public let TIMEOUT_LONGER = (TIMEOUT_DEFAULT*2.0)

public enum SerializedURLRequestError: Error {
	case noRequests
	case userCancelled
	case timeoutExpired
}

public actor DataAndResponseActor {
	public var dataAndResponseTuples: [(Data, URLResponse)] = []

	func assign(_ newArray: [(Data, URLResponse)]) {
		dataAndResponseTuples = newArray
	}
	func append(_ newElement: (Data, URLResponse)) {
		dataAndResponseTuples.append(newElement)
	}
	func count() -> Int {
		return dataAndResponseTuples.count
	}

	public var caughtError: Error?
	func assignError(_ newError: Error?) {
		caughtError = newError
	}
}

extension URLSession {
	public func startSerializedURLRequest(urlRequests: [URLRequest], progressConfiguration: FXDobservableOverlay? = nil) async throws -> DataAndResponseActor? {
		guard urlRequests.count > 0 else {
			throw SerializedURLRequestError.noRequests
		}

		let safeDataAndResponse = DataAndResponseActor()
		func requesting(urlRequest: URLRequest, reattemptedRequests: [URLRequest] = []) async throws {
			guard !(progressConfiguration?.cancellableTask?.isCancelled ?? false) else {
				fxdPrint("[\(#function)] isCancelled: \((progressConfiguration?.cancellableTask?.isCancelled ?? false))")
				throw SerializedURLRequestError.userCancelled
			}

			let (data, response) = try await self.data(for: urlRequest)
			guard (response as? HTTPURLResponse)?.statusCode == 200 else {
				throw SerializedURLRequestError.timeoutExpired
			}

			await safeDataAndResponse.append((data, response))

			let finishedCount = await safeDataAndResponse.count()
			let progressValue: CGFloat = CGFloat(Float(finishedCount)/Float(urlRequests.count+reattemptedRequests.count))
            progressConfiguration?.sliderValue = progressValue
		}

		var reattemptedRequests: [URLRequest] = []
		for urlRequest in urlRequests {
			do {
				try await requesting(urlRequest: urlRequest)
			} catch {
				guard let urlError = error as? URLError,
					  urlError.code.rawValue == NSURLErrorTimedOut else {
					fxdPrint("[\(#function)] \(error)")
					throw error
				}

				var modifiedRequest = urlRequest
				modifiedRequest.timeoutInterval = TIMEOUT_LONGER
				reattemptedRequests.append(modifiedRequest)
			}
		}

		// using recursive could be considered, however, it's unnecessary complication.
		fxdPrint("[\(#function)] \(reattemptedRequests.count)")
		for reattempted in reattemptedRequests {
			do {
				try await requesting(urlRequest: reattempted, reattemptedRequests: reattemptedRequests)
			} catch {
				fxdPrint("[\(#function)] reattempted: \(error)")
				throw error
			}
		}

		return safeDataAndResponse
	}
}
