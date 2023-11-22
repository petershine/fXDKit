

import SwiftUI


open class FXDconfigurationInformation: ObservableObject {
	@Published open var shouldDismiss: Bool = false

	@Published open var overlayColor: UIColor? = nil
	@Published open var shouldIgnoreUserInteraction: Bool

	@Published open var informationTitle: String
	@Published open var message_0: String
	@Published open var message_1: String

	@Published open var sliderValue: Float
	@Published open var sliderTint: Color? = nil


	public init(overlayColor: UIColor? = nil, 
				shouldIgnoreUserInteraction: Bool? = false,
		
				informationTitle: String? = nil,
				message_0: String? = nil,
				message_1: String? = nil,
				
				sliderValue: Float? = nil,
				sliderTint: Color? = nil) {

		self.overlayColor = overlayColor
		self.shouldIgnoreUserInteraction = shouldIgnoreUserInteraction ?? false
		
		self.informationTitle = informationTitle ?? "TITLE"
		self.message_0 = message_0 ?? "MESSAGE 0"
		self.message_1 = message_1 ?? "MESSAGE 1"
		
		self.sliderValue = sliderValue ?? 0.5
		self.sliderTint = sliderTint ?? Color(uiColor: .systemBlue)
	}
}

public struct FXDswiftuiInformation: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var configuration: FXDconfigurationInformation


	public init(information: FXDconfigurationInformation = FXDconfigurationInformation()) {
		self.configuration = information
	}

    public var body: some View {
		VStack {
			Text(configuration.informationTitle)
				.font(.title)
				.fontWeight(.bold)

			Text(configuration.message_0)

			ProgressView()
				.controlSize(.large)
				.frame(alignment: .center)
				.padding()

			Slider(value: $configuration.sliderValue)
				.tint(configuration.sliderTint)
				.allowsHitTesting(false)

			Text(configuration.message_1)
		}
		.ignoresSafeArea(.all)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding([.leading, .trailing])
		.contentShape(Rectangle())
		.presentationBackground(
			Color(uiColor: configuration.overlayColor ?? (colorScheme == .dark ? .black : .white))
				.opacity(0.75)
		)
		.allowsHitTesting(!configuration.shouldIgnoreUserInteraction)
		.onTapGesture {
			configuration.shouldDismiss = true
		}
		.onChange(of: configuration.shouldDismiss, initial: false, {
			if configuration.shouldDismiss {
				dismiss()
			}
		})
    }
}


struct POPswiftuiSettings_Previews: PreviewProvider {
	static var previews: some View {
		FXDswiftuiInformation()
		FXDswiftuiInformation()
			.preferredColorScheme(.dark)
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
					testingConfiguration.sliderValue = Float(step) * 0.1
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

