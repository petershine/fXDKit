

import SwiftUI


open class FXDobservableInformation: NSObject, ObservableObject {
	@Published var overlayColor: UIColor? = nil

	@Published var informationTitle: String
	@Published var message_0: String
	@Published var message_1: String

	@Published var sliderValue: Float

	public init(overlayColor: UIColor? = nil, informationTitle: String? = nil, message_0: String? = nil, message_1: String? = nil, sliderValue: Float? = nil) {
		self.overlayColor = overlayColor
		self.informationTitle = informationTitle ?? "TITLE"
		self.message_0 = message_0 ?? "MESSAGE 0"
		self.message_1 = message_1 ?? "MESSAGE 1"
		self.sliderValue = sliderValue ?? 0.5
	}
}

public struct FXDswiftuiInformation: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var information: FXDobservableInformation


	public init(information: FXDobservableInformation = FXDobservableInformation()) {
		self.information = information
	}

    public var body: some View {
		VStack {
			Text(information.informationTitle)
				.font(.title)
				.fontWeight(.bold)

			Text(information.message_0)

			ProgressView()
				.controlSize(.large)
				.padding()

			Slider(value: $information.sliderValue)
			
			Text(information.message_1)
		}
		.ignoresSafeArea(.all)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding([.leading, .trailing])
		.contentShape(Rectangle())
		.presentationBackground(
			Color(uiColor: information.overlayColor ?? (colorScheme == .dark ? .black : .white))
				.opacity(0.75)
		)
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
