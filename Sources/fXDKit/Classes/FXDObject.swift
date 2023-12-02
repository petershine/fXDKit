

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
}


import Combine

extension NSObject {
	public func cancelAsyncTask(identifier: String = #function) {
		let extendedIdentifier = String(describing: self) + identifier

		cancellables = cancellables?.filter({
			(key: String, value: AnyCancellable?) in
			if key == extendedIdentifier {
				value?.cancel()
				fxdPrint("cancel(): \(extendedIdentifier)")
			}
			return key != extendedIdentifier
		})
	}
	
	public func publisherForDelayedAsyncTask(identifier: String? = nil, afterDelay: TimeInterval = 0.0, attachedTask: (() -> Void?)? = nil) -> AnyPublisher<String, Error> {
		return Future<String, Error> { promise in
			DispatchQueue.global().asyncAfter(deadline: .now() + afterDelay) {
				attachedTask?()
				promise(.success(".success: \(String(describing: self) + String(describing: identifier)) attachedTask: \(String(describing: attachedTask))"))
			}
		}
		.eraseToAnyPublisher()
	}

	public func performAsyncTask(identifier: String = #function, afterDelay: TimeInterval = 0.0, attachedTask: (() -> Void?)?) {
		let extendedIdentifier = String(describing: self) + identifier

		let cancellable = publisherForDelayedAsyncTask(identifier: identifier, afterDelay: afterDelay, attachedTask: attachedTask)
			.sink(receiveCompletion: {
				[weak self] (completion) in
				switch completion {
					case .finished:
						fxdPrint(".finished: \(extendedIdentifier)")
						break

					case .failure(let error):
						fxdPrint(".failure: \(extendedIdentifier) : \(error)")
				}

				if var modified = self?.cancellables as? [String : AnyCancellable?] {
					modified[extendedIdentifier] = nil
					self?.cancellables = modified
				}

			}, receiveValue: { result in
				fxdPrint("promise: \(result)")
			})

		if cancellables == nil {
			cancellables = [String : AnyCancellable?]()
		}
		cancellables?[extendedIdentifier] = cancellable
	}
}
