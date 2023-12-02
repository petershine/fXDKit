
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
				[weak self] in
				if self?.cancellables?.first(where: {
					(key: String, value: AnyCancellable?) in
					return key == identifier
				}) == nil {
					fxdPrint("Cancellable \(identifier) is already cancelled.")
					return
				}

				attachedTask?()
				promise(.success("Task completed \(identifier)"))

				self?.cancellables = self?.cancellables?.filter({
					(key: String, value: AnyCancellable?) in
					return key != identifier
				})
			}
		}
		.eraseToAnyPublisher()
	}

	public func performAsyncTask(identifier: String = #function, afterDelay: TimeInterval = 0.0, attachedTask: (() -> Void?)?) {
		let cancellable = performAsyncTaskPublisher(identifier: identifier, afterDelay: afterDelay, attachedTask: attachedTask)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break // Task completed successfully
				case .failure(let error):
					fxdPrint("Task failed with error: \(error)")
				}
			}, receiveValue: { result in
				fxdPrint("Task result: \(result)")
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

	public func cancelAsyncTask(identifier: String = #function) {
		cancellables?.forEach({ (key: String, value: AnyCancellable?) in
			if key == identifier {
				value?.cancel()
			}
		})

		cancellables = cancellables?.filter({
			(key: String, value: AnyCancellable?) in
			return key != identifier
		})
	}
}
