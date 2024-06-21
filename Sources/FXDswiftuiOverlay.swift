

import SwiftUI


public protocol FXDprotocolOverlay {
	var shouldDismiss: Bool { get set }

	var overlayColor: UIColor? { get set }
	var overlayAlpha: CGFloat { get set }
	var allowUserInteraction: Bool { get set }

	var overlayTitle: String? { get set }
	var message_0: String? { get set }
	var message_1: String? { get set }

	var sliderValue: CGFloat? { get set }
	var sliderTint: Color? { get set }

	var cancellableTask: Task<Void, Error>? { get set }
}

open class FXDobservableOverlay: FXDprotocolOverlay, ObservableObject {
	@Published open var shouldDismiss: Bool = false

	@Published open var overlayColor: UIColor? = nil
	@Published open var overlayAlpha: CGFloat
	@Published open var allowUserInteraction: Bool = true

	@Published open var overlayTitle: String? = nil
	@Published open var message_0: String? = nil
	@Published open var message_1: String? = nil

	@Published open var sliderValue: CGFloat? = nil
	@Published open var sliderTint: Color? = nil

	open var cancellableTask: Task<Void, Error>? = nil

	public init(overlayColor: UIColor? = nil,
				overlayAlpha: CGFloat? = nil,
				allowUserInteraction: Bool? = nil,

				sliderValue: CGFloat? = nil,
				sliderTint: Color? = nil) {

		self.overlayColor = overlayColor
		self.overlayAlpha = overlayAlpha ?? 0.5
		self.allowUserInteraction = allowUserInteraction ?? true

		self.sliderValue = sliderValue ?? 0.0
		self.sliderTint = sliderTint ?? Color(uiColor: .systemBlue)
	}
}

public struct FXDswiftuiOverlay: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var observable: FXDobservableOverlay


	public init(observable: FXDobservableOverlay? = nil) {
		self.observable = observable ?? FXDobservableOverlay()
	}

    public var body: some View {
		ZStack {
			Color(observable.overlayColor ?? (colorScheme == .dark ? .black : .white))
				.opacity(observable.overlayAlpha)

			VStack {
				Text(observable.overlayTitle ?? "")
					.font(.title)
					.fontWeight(.bold)

				Text(observable.message_0 ?? "")

				ProgressView()
					.controlSize(.large)
					.frame(alignment: .center)

				FXDProgressBar(value: Binding.constant(observable.sliderValue ?? 0.0))
					.tint(observable.sliderTint)
					.opacity((observable.sliderValue ?? 0.0) > 0.0 ? 1.0 : 0.0)
					.allowsHitTesting(false)
					.padding()

				Text(observable.message_1 ?? "")
			}
		}
		.ignoresSafeArea()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.allowsHitTesting(!observable.allowUserInteraction)
		.onTapGesture {
			observable.shouldDismiss = true
			observable.cancellableTask?.cancel()
		}
		.onChange(of: observable.shouldDismiss) {
			if observable.shouldDismiss {
				dismiss()
			}
		}
    }
}


import Combine

open class FXDhostedOverlay: UIHostingController<FXDswiftuiOverlay> {
	fileprivate var cancellableObservers: Set<AnyCancellable> = []

	override open func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)

		guard parent != nil else {
			return
		}


		view.frame.size = parent!.view.frame.size
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}

	override open func viewDidLoad() {
		super.viewDidLoad()

		let reactToTraitChanges = {
			[weak self] in

			let interfaceStyle = self?.traitCollection.userInterfaceStyle

			self?.view.backgroundColor = self?.rootView.observable.overlayColor ?? (interfaceStyle == .dark ? UIColor.black : UIColor.white).withAlphaComponent(self?.rootView.observable.overlayAlpha ?? 0.75)
		}

		reactToTraitChanges()

		registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
			(self: Self, previousTraitCollection: UITraitCollection) in

			reactToTraitChanges()
		}


		rootView.observable.$shouldDismiss.sink(receiveValue: {
			[weak self] (shouldDismiss) in

			if shouldDismiss {
				UIApplication.shared.mainWindow()?.hideOverlay(afterDelay: DURATION_QUARTER)
			}

			self?.cancellableObservers.forEach({ $0.cancel() })
			self?.cancellableObservers = []
		})
		.store(in: &cancellableObservers)
	}
}



// Example usage
extension FXDobservableOverlay {
	public class func exampleCountingUp() -> FXDobservableOverlay {

		let testingConfiguration = FXDobservableOverlay(
			allowUserInteraction: false,
			sliderValue: 0.0)


		let taskInterval = 1.0
		Task {
			for step in 0...10 {
				//Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.

				DispatchQueue.main.async {
					testingConfiguration.overlayAlpha = 1.0 - (CGFloat(step)*0.1)
					testingConfiguration.sliderValue = CGFloat(step) * 0.1
				}

				do {
					try await Task.sleep(nanoseconds: UInt64((taskInterval * 1_000_000_000).rounded()))
				}
			}

			DispatchQueue.main.async {
				testingConfiguration.shouldDismiss = true
			}
		}

		return testingConfiguration
	}
}

