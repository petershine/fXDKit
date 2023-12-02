
import Combine


fileprivate var cancellablesKey: UInt8 = 0

extension NSObject {
	fileprivate var cancellables: [String : AnyCancellable?]? {
		get {
			return objc_getAssociatedObject(self, &cancellablesKey) as? [String : AnyCancellable?]
		}
		set {
			objc_setAssociatedObject(self, &cancellablesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	fileprivate func performAsyncTaskPublisher(identifier: String, afterDelay: TimeInterval, attachedTask: (() -> Void?)?) -> AnyPublisher<String, Error> {
		return Future<String, Error> { promise in
			DispatchQueue.global().asyncAfter(deadline: .now() + afterDelay) {
				attachedTask?()
				promise(.success("Completed: \(identifier) attachedTask: \(attachedTask)"))
			}
		}
		.eraseToAnyPublisher()
	}

	public func performAsyncTask(identifier: String = #function, afterDelay: TimeInterval = 0.0, attachedTask: (() -> Void?)?) {
		let cancellable = performAsyncTaskPublisher(identifier: identifier, afterDelay: afterDelay, attachedTask: attachedTask)
			.sink(receiveCompletion: { 
				[weak self] (completion) in
				switch completion {
					case .finished:
						fxdPrint(".finished: \(identifier)")
						break // Task completed successfully

					case .failure(let error):
						fxdPrint(".failure: \(identifier) : \(error)")
				}

				if var currentCancellables = self?.cancellables as? [String : AnyCancellable?] {
					currentCancellables[identifier] = nil
				}

			}, receiveValue: { result in
				fxdPrint("promise result: \(result)")
			})

		if cancellables == nil {
			cancellables = [String : AnyCancellable?]()
		}
		cancellables?[identifier] = cancellable
	}

	public func cancelAllAsyncTask() {
		cancellables?.forEach({ (key: String, value: AnyCancellable?) in
			value?.cancel()
		})
		cancellables?.removeAll()
		cancellables = nil
	}

	public func cancelAndRemoveAsyncTask(identifier: String = #function) {
		cancellables = cancellables?.filter({
			(key: String, value: AnyCancellable?) in
			if key == identifier {
				value?.cancel()
				fxdPrint("cancel(): \(identifier)")
			}
			return key != identifier
		})
	}
}
