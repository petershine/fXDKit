

import SwiftUI


public struct FXDswiftuiMediaDisplay: View {
	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize?
	@State private var displayAxisSet: Axis.Set = []

	@Binding var displayImage: UIImage?


	public init(displayImage: UIImage?) {
		_displayImage = Binding.constant(displayImage)

		displaySize = displayImage?.size
	}

	public var body: some View {
		ScrollView(displayAxisSet,
				   showsIndicators: false) {
			ZStack {
				Spacer().containerRelativeFrame([.horizontal, .vertical])
				
				if let displayImage {
					Image(uiImage: displayImage)
						.resizable()
						.frame(width: displaySize?.width, height: displaySize?.height, alignment: .center)
				}
			}
		}
		.background {
			Color(.black)
		}
		.ignoresSafeArea()
		.scrollBounceBehavior(.basedOnSize)
		.onTapGesture(count: 2) {
			displayContentMode = (displayContentMode == .fit) ? .fill : .fit
		}
		.onChange(of: displayContentMode) {
			oldValue, newValue in

			updateScrollViewConfiguration(for: newValue)
		}
		.onChange(of: displayImage) {
			oldValue, newValue in

			updateScrollViewConfiguration(for: displayContentMode)
		}
		.onReceive(NotificationCenter.default.publisher(
			for: UIDevice.orientationDidChangeNotification)) { _ in
				DispatchQueue.main.async {
					updateScrollViewConfiguration(for: displayContentMode)
				}
			}
	}
}

fileprivate extension FXDswiftuiMediaDisplay {
	func updateScrollViewConfiguration(for newContentMode: ContentMode) {
		guard let displayImage else {
			return
		}


		let containerSize = UIScreen.main.bounds.size
		let aspectSize = displayImage.aspectSize(for: displayContentMode, containerSize: containerSize)
		withAnimation {
			displaySize = aspectSize
		}

		if newContentMode == .fit
			|| (aspectSize.width <= containerSize.width && aspectSize.height <= containerSize.height) {

			displayAxisSet = []
		}
		else if aspectSize.width > containerSize.width {
			displayAxisSet = [.horizontal]
		}
		else if aspectSize.height > containerSize.height {
			displayAxisSet = [.vertical]
		}
	}
}
