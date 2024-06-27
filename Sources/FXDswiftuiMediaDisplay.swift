

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {
	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize?

	@Binding var displayImage: UIImage?


	public init(displayImage: UIImage?) {
		_displayImage = Binding.constant(displayImage)

		displaySize = displayImage?.size
	}

	public var body: some View {
		ScrollView([.horizontal, .vertical],
				   showsIndicators: false) {
			if let displayImage {
				Image(uiImage: displayImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: displaySize?.width, height: displaySize?.height, alignment: .center)
			}
		}
		.background {
			Color(.black)
		}
		.ignoresSafeArea()
		.onTapGesture(count: 2) {
			displayContentMode = (displayContentMode == .fit) ? .fill : .fit
		}
		.onChange(of: displayContentMode) {
			oldValue, newValue in

			updateDisplayImage(for: newValue)
		}
		.onChange(of: displayImage) {
			oldValue, newValue in

			updateDisplayImage(for: displayContentMode)
		}
		.onReceive(NotificationCenter.default.publisher(
			for: UIDevice.orientationDidChangeNotification)) { _ in
				DispatchQueue.main.async {
					updateDisplayImage(for: displayContentMode)
				}
			}
	}
}

extension FXDswiftuiMediaDisplay {
	func updateDisplayImage(for newContentMode: ContentMode) {
		guard let displayImage else {
			return
		}


		let newSize = displayImage.aspectSize(for: displayContentMode, containerSize: UIScreen.main.bounds.size)
		withAnimation {
			displaySize = newSize
		}
	}
}
