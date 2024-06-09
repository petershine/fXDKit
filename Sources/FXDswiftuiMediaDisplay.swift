

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {
	@Environment(\.colorScheme) var colorScheme

	@Binding var diaplayedImage: UIImage?
	@Binding var contentMode: ContentMode


	public init(displayedImage: Binding<UIImage?>, contentMode: Binding<ContentMode>) {
		_diaplayedImage = displayedImage
		_contentMode = contentMode
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
