

import SwiftUI


open class FXDconfigurationInformation: NSObject, ObservableObject {
	@Published var overlayColor: UIColor? = nil
	@Published var shouldIgnoreUserInteraction: Bool

	@Published var informationTitle: String
	@Published var message_0: String
	@Published var message_1: String

	@Published var sliderValue: Float
	@Published var sliderTint: Color? = nil

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
			dismiss()
		}
    }
}


struct POPswiftuiSettings_Previews: PreviewProvider {
	static var previews: some View {
		FXDswiftuiInformation()
		FXDswiftuiInformation()
			.preferredColorScheme(.dark)
	}
}
