

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {

	@Binding var displayedImage: UIImage?
	@Binding var contentMode: ContentMode

	public init(displayedImage: UIImage?, contentMode: ContentMode) {
		_displayedImage = Binding.constant(displayedImage)
		_contentMode =  Binding.constant(contentMode)
	}

	public var body: some View {
		Color(.black)
			.overlay {
				if let displayedImage {
					Image(uiImage: displayedImage)
						.resizable()
						.aspectRatio(contentMode: contentMode)
				}
			}
			.ignoresSafeArea()
	}
}
