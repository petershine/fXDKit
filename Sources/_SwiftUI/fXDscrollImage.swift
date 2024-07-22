

import SwiftUI


public struct fXDscrollImage: View {
	@Binding var displayImage: UIImage?

	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize? = nil
	@State private var restrictedBouncing: Axis.Set = [.horizontal, .vertical]


    public init(displayImage: Binding<UIImage?>) {
        _displayImage = displayImage
    }

	public var body: some View {
		ScrollView([.horizontal, .vertical],
				   showsIndicators: false) {
			ZStack {
				Spacer()
					.containerRelativeFrame([.horizontal, .vertical])

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
		.scrollBounceBehavior(.basedOnSize, axes: restrictedBouncing)
        .task {
            displaySize = displayImage?.size
        }
		.onTapGesture(count: 2, perform: {
			displayContentMode = (displayContentMode == .fit) ? .fill : .fit
		})
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

fileprivate extension fXDscrollImage {
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

			restrictedBouncing = [.horizontal, .vertical]
		}
		else if aspectSize.width > containerSize.width {
			restrictedBouncing = [.vertical]
		}
		else if aspectSize.height > containerSize.height {
			restrictedBouncing = [.horizontal]
		}
	}
}
