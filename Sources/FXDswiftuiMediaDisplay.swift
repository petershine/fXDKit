

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {

	@Binding var diaplayedImage: UIImage?
	@Binding var contentMode: ContentMode

	public init(displayedImage: UIImage?, contentMode: ContentMode) {
		_diaplayedImage = Binding.constant(displayedImage)
		_contentMode =  Binding.constant(contentMode)
	}

	public var body: some View {
		Color(.black)
			.overlay {
				if let availableImage = diaplayedImage {
					Image(uiImage: availableImage)
						.resizable()
						.aspectRatio(contentMode: contentMode)
				}
			}
			.ignoresSafeArea()
	}
}
