

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {
	@Environment(\.colorScheme) var colorScheme

	@Binding var diaplayedImage: UIImage?


	public init(displayedImage: UIImage? = nil) {
		_diaplayedImage = Binding.constant(displayedImage)
	}

	public var body: some View {
		Color(.black)
			.overlay {
				if let availableImage = diaplayedImage {
					Image(uiImage: availableImage)
						.resizable()
						.aspectRatio(contentMode: .fill)
				}
			}
			.ignoresSafeArea()
	}
}


#Preview {
	FXDswiftuiMediaDisplay(displayedImage: UIImage())
}
