

import SwiftUI


public protocol FXDprotocolInformation: ObservableObject {
	var shouldDismiss: Bool { get set }

	var overlayColor: UIColor? { get set }
	var overlayAlpha: CGFloat { get set }
	var shouldIgnoreUserInteraction: Bool { get set }

	var informationTitle: String? { get set }
	var message_0: String? { get set }
	var message_1: String? { get set }

	var sliderValue: CGFloat? { get set }
	var sliderTint: Color? { get set }

	var cancellableTask: Task<Void, Error>? { get set }
}

open class FXDconfigurationInformation: FXDprotocolInformation {
	@Published open var shouldDismiss: Bool = false

	@Published open var overlayColor: UIColor? = nil
	@Published open var overlayAlpha: CGFloat
	@Published open var shouldIgnoreUserInteraction: Bool = false

	@Published open var informationTitle: String? = nil
	@Published open var message_0: String? = nil
	@Published open var message_1: String? = nil

	@Published open var sliderValue: CGFloat? = nil
	@Published open var sliderTint: Color? = nil

	public var cancellableTask: Task<Void, Error>? = nil

	public init(overlayColor: UIColor? = nil,
				overlayAlpha: CGFloat? = 0.75,
				shouldIgnoreUserInteraction: Bool? = false,
				
				sliderValue: CGFloat? = nil,
				sliderTint: Color? = nil) {

		self.overlayColor = overlayColor
		self.overlayAlpha = overlayAlpha ?? 0.75
		self.shouldIgnoreUserInteraction = shouldIgnoreUserInteraction ?? false
		
		self.sliderValue = sliderValue ?? 0.0
		self.sliderTint = sliderTint ?? Color(uiColor: .systemBlue)
	}
}

public struct FXDswiftuiInformation: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var configuration: FXDconfigurationInformation


	public init(configuration: FXDconfigurationInformation = FXDconfigurationInformation()) {
		self.configuration = configuration
	}

    public var body: some View {
		VStack {
			Text(configuration.informationTitle ?? "")
				.font(.title)
				.fontWeight(.bold)

			Text(configuration.message_0 ?? "")

			ProgressView()
				.controlSize(.large)
				.frame(alignment: .center)

			FXDProgressBar(value: Binding.constant(configuration.sliderValue ?? 0.0))
				.tint(configuration.sliderTint)
				.opacity((configuration.sliderValue ?? 0.0) > 0.0 ? 1.0 : 0.0)
				.allowsHitTesting(false)
				.padding()

			Text(configuration.message_1 ?? "")
		}
		.ignoresSafeArea(.all)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding([.leading, .trailing])
		.contentShape(Rectangle())
		.presentationBackground(
			Color(uiColor: configuration.overlayColor ?? (colorScheme == .dark ? .black : .white))
				.opacity(configuration.overlayAlpha)
		)
		.allowsHitTesting(!configuration.shouldIgnoreUserInteraction)
		.onTapGesture {
			configuration.shouldDismiss = true
			configuration.cancellableTask?.cancel()
		}
		.onChange(of: configuration.shouldDismiss) {
			if configuration.shouldDismiss {
				dismiss()
			}
		}
    }
}


import Combine

public class FXDhostedInformation: UIHostingController<FXDswiftuiInformation> {
	fileprivate var cancellableObservers: Set<AnyCancellable> = []

	override public func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)

		guard parent != nil else {
			return
		}


		self.view.frame.size = parent!.view.frame.size
		self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}

	override public func viewDidLoad() {
		super.viewDidLoad()

		let reactToTraitChanges = {
			[weak self] in

			let interfaceStyle = self?.traitCollection.userInterfaceStyle

			self?.view.backgroundColor = self?.rootView.configuration.overlayColor ?? (interfaceStyle == .dark ? UIColor.black : UIColor.white).withAlphaComponent(self?.rootView.configuration.overlayAlpha ?? 0.75)
		}

		reactToTraitChanges()

		registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
			(self: Self, previousTraitCollection: UITraitCollection) in

			reactToTraitChanges()
		}


		self.rootView.configuration.$overlayAlpha.sink {
			(overlayAlpha) in

			reactToTraitChanges()
		}
		.store(in: &self.cancellableObservers)


		self.rootView.configuration.$shouldDismiss.sink(receiveValue: {
			[weak self] (shouldDismiss) in

			if shouldDismiss {
				UIApplication.shared.mainWindow()?.hideWaitingView(afterDelay: DURATION_QUARTER)
			}

			self?.cancellableObservers.forEach({ $0.cancel() })
			self?.cancellableObservers = []
		})
		.store(in: &self.cancellableObservers)
	}
}



// Example usage
extension FXDconfigurationInformation {
	public class func exampleCountingUp() -> FXDconfigurationInformation {

		let testingConfiguration = FXDconfigurationInformation(
			shouldIgnoreUserInteraction: false,
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

