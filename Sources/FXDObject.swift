import Foundation
import Combine

nonisolated(unsafe) private var cancellablesKey: UInt8 = 0

extension NSObject {
	fileprivate var cancellables: [String: AnyCancellable?]? {
		get {
			return objc_getAssociatedObject(self, &cancellablesKey) as? [String: AnyCancellable?]
		}
		set {
			objc_setAssociatedObject(self, &cancellablesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}

extension NSObject: @unchecked @retroactive Sendable {
    public func publisherForDelayedAsyncTask(identifier: String? = nil, afterDelay: TimeInterval = 0.0, attachedTask: (@Sendable () -> Void?)? = nil) -> AnyPublisher<String, Error> {
		return Future<String, Error> { promise in
//			DispatchQueue.global().asyncAfter(deadline: .now() + afterDelay) {
				attachedTask?()
                promise(.success(".success: \(String(describing: self) + String(describing: identifier)) attachedTask: \(String(describing: attachedTask))"))
//			}
		}
		.eraseToAnyPublisher()
	}

	public func cancellableForDelayedAsyncTask(identifier: String? = nil, afterDelay: TimeInterval = 0.0, attachedTask: (@Sendable () -> Void?)? = nil, afterCompletion: (() -> Void?)? = nil) -> AnyCancellable {

		let publisher = publisherForDelayedAsyncTask(identifier: identifier, afterDelay: afterDelay, attachedTask: attachedTask)
		let cancellable = publisher
			.sink(receiveCompletion: {
				(completion) in

				switch completion {
				case .finished:
						fxdPrint(".finished: ", identifier, quiet: true)

					case .failure(let error):
						fxdPrint(".failure: ", identifier, " : ", error, quiet: true)
				}

				afterCompletion?()

			}, receiveValue: { result in
				fxdPrint("promise: \(result)", quiet: true)
			})

		return cancellable
	}
}

extension NSObject {
	public func performAsyncTask(identifier: String = #function, afterDelay: TimeInterval = 0.0, attachedTask: (@Sendable () -> Void?)?) {
		let extendedIdentifier = String(describing: self) + identifier

		let cancellable = cancellableForDelayedAsyncTask(identifier: identifier, afterDelay: afterDelay, attachedTask: attachedTask) {
			[weak self] in

			if var modified = self?.cancellables as? [String: AnyCancellable?] {
				modified[extendedIdentifier] = nil
				self?.cancellables = modified
			}
		}

		if cancellables == nil {
			cancellables = [String: AnyCancellable?]()
		}

		cancellables?[extendedIdentifier] = cancellable
	}

	public func cancelAsyncTask(identifier: String = #function) {
		let extendedIdentifier = String(describing: self) + identifier

		cancellables = cancellables?.filter({
			(key: String, value: AnyCancellable?) in
			if key == extendedIdentifier {
				value?.cancel()
				fxdPrint("cancel(): \(extendedIdentifier)", quiet: true)
			}
			return key != extendedIdentifier
		})
	}
}
