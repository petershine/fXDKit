

import Combine
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


@Observable
public class FXDobservableOverlay: FXDprotocolOverlay, @unchecked Sendable {
	public var shouldDismiss: Bool = false

	public var progressSpinnerAlpha: CGFloat? = 1.0

	public var overlayColor: UIColor? = .black
	public var overlayAlpha: CGFloat? = 0.8
	public var allowUserInteraction: Bool? = false

	public var overlayTitle: String? = nil
	public var message_0: String? = nil
	public var message_1: String? = nil

	public var sliderValue: CGFloat? = 0.0
	public var sliderTint: Color? = Color(uiColor: .systemBlue)

	public var cancellableTask: Task<Void, Error>? = nil

	public init(
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

public struct fXDviewOverlay: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@Bindable var observable: FXDobservableOverlay


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

				SPACER_FIXED()

				FXDProgressBar(value: Binding.constant(observable.sliderValue ?? 0.0))
					.tint(observable.sliderTint)
					.opacity((observable.sliderValue ?? 0.0) > 0.0 ? 1.0 : 0.0)
					.allowsHitTesting(false)
					.padding()

				Text(observable.message_1 ?? "")
			}

			VStack {
				Spacer()
				HStack {
					Spacer()
					ProgressView()
						.controlSize(.large)
						.frame(alignment: .center)
						.opacity(observable.progressSpinnerAlpha ?? 1.0)
					Spacer()
				}
				Spacer()
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




public class FXDhostedOverlay: UIHostingController<fXDviewOverlay>, @unchecked Sendable {
	fileprivate var cancellableObservers: Set<AnyCancellable> = []

	override public func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)

		guard parent != nil else {
			return
		}


		view.frame.size = parent!.view.frame.size
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}

	override public func viewDidLoad() {
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
	}
}



// Example usage
extension FXDobservableOverlay {
	public class func exampleCountingUp() -> FXDobservableOverlay {
        let testingConfiguration = FXDobservableOverlay()

		let taskInterval = 1.0
        Task {	@MainActor in
			for step in 0...10 {
				//Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.

                testingConfiguration.overlayAlpha = 1.0 - (CGFloat(step)*0.1)
                testingConfiguration.sliderValue = CGFloat(step) * 0.1

				do {
					try await Task.sleep(nanoseconds: UInt64((taskInterval * 1_000_000_000).rounded()))
				}
			}

            testingConfiguration.shouldDismiss = true
		}

		return testingConfiguration
	}
}

