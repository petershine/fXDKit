

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
		ScrollView([.horizontal, .vertical]) {
			if let displayImage {
				Image(uiImage: displayImage)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: displaySize?.width, height: displaySize?.height, alignment: .center)
			}
		}
		.ignoresSafeArea()
		.backgroundStyle(.black)
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
		fxdPrint(newContentMode)
		guard let displayImage else {
			return
		}


		let aspectRatio = min(displayImage.size.width, displayImage.size.height)/max(displayImage.size.width, displayImage.size.height)

		let isPortraitImage = displayImage.size.width < displayImage.size.height
		let isPortraitScreen = UIScreen.main.bounds.width < UIScreen.main.bounds.height


		var newSize: CGSize = displaySize ?? displayImage.size

		if newContentMode == .fit {
			let minDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

			if (isPortraitImage && isPortraitScreen)
				|| (!isPortraitImage && isPortraitScreen) {
				newSize = CGSize(width: minDimension, height: minDimension/aspectRatio)
			}
			else if (isPortraitImage && !isPortraitScreen)
						|| (!isPortraitImage && !isPortraitScreen) {
				newSize = CGSize(width: minDimension*aspectRatio, height: minDimension)
			}
		}
		else {
			let maxDimension = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

			if (isPortraitImage && isPortraitScreen)
				|| (!isPortraitImage && isPortraitScreen) {
				newSize = CGSize(width: maxDimension*aspectRatio, height: maxDimension)
			}
			else if (isPortraitImage && !isPortraitScreen)
						|| (!isPortraitImage && !isPortraitScreen) {
				newSize = CGSize(width: maxDimension, height: maxDimension/aspectRatio)
			}
		}

		fxdPrint(newSize)
		withAnimation {
			displaySize = newSize
		}
	}
}
