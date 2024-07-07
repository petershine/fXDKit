

import SwiftUI


public protocol FXDprotocolOverlay {
	var shouldDismiss: Bool { get set }

	var overlayColor: UIColor? { get set }
	var overlayAlpha: CGFloat? { get set }
	var allowUserInteraction: Bool? { get set }

	var overlayTitle: String? { get set }
	var message_0: String? { get set }
	var message_1: String? { get set }

	var sliderValue: CGFloat? { get set }
	var sliderTint: Color? { get set }

	var cancellableTask: Task<Void, Error>? { get set }
}

open class FXDobservableOverlay: NSObject, FXDprotocolOverlay, ObservableObject {
	@Published open var shouldDismiss: Bool = false

	@Published open var progressSpinnerAlpha: CGFloat? = 1.0

	@Published open var overlayColor: UIColor? = .black
	@Published open var overlayAlpha: CGFloat? = 0.8
	@Published open var allowUserInteraction: Bool? = false

	@Published open var overlayTitle: String? = nil
	@Published open var message_0: String? = nil
	@Published open var message_1: String? = nil

	@Published open var sliderValue: CGFloat? = 0.0
	@Published open var sliderTint: Color? = Color(uiColor: .systemBlue)

	open var cancellableTask: Task<Void, Error>? = nil

	public init(shouldDismiss: Bool = false,
		 progressSpinnerAlpha: CGFloat? = 1.0,
		 overlayColor: UIColor? = .black,
		 overlayAlpha: CGFloat? = 0.8,
		 allowUserInteraction: Bool? = false,
		 overlayTitle: String? = nil,
		 message_0: String? = nil,
		 message_1: String? = nil,
		 sliderValue: CGFloat? = 0.0,
		 sliderTint: Color? = Color(uiColor: .systemBlue),
		 cancellableTask: Task<Void, Error>? = nil) {

		super.init()

		self.shouldDismiss = shouldDismiss
		self.progressSpinnerAlpha = progressSpinnerAlpha
		self.overlayColor = overlayColor
		self.overlayAlpha = overlayAlpha
		self.allowUserInteraction = allowUserInteraction
		self.overlayTitle = overlayTitle
		self.message_0 = message_0
		self.message_1 = message_1
		self.sliderValue = sliderValue
		self.sliderTint = sliderTint
		self.cancellableTask = cancellableTask
	}
}

public struct fXDstackOverlay: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var observable: FXDobservableOverlay


	public init(observable: FXDobservableOverlay? = nil) {
		self.observable = observable ?? FXDobservableOverlay()
	}

    public var body: some View {
		ZStack {
			Color(observable.overlayColor ?? (colorScheme == .dark ? .black : .white))
				.opacity(observable.overlayAlpha ?? 0.8)

			VStack {
				Text(observable.overlayTitle ?? "")
					.font(.title)
					.fontWeight(.bold)

				Text(observable.message_0 ?? "")

				ProgressView()
					.controlSize(.large)
					.frame(alignment: .center)
					.opacity(observable.progressSpinnerAlpha ?? 1.0)

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
		.allowsHitTesting(!(observable.allowUserInteraction ?? false))
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

open class FXDhostedOverlay: UIHostingController<fXDstackOverlay> {
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

			self?.view.backgroundColor = self?.rootView.observable.overlayColor ?? (interfaceStyle == .dark ? UIColor.black : UIColor.white).withAlphaComponent(self?.rootView.observable.overlayAlpha ?? 0.8)
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

		let testingConfiguration = FXDobservableOverlay()


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

