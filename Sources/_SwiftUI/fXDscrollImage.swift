

import SwiftUI


public struct fXDscrollImage: View {
	@Binding var uiImage: UIImage?

	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize? = nil
	@State private var restrictedBouncing: Axis.Set = [.horizontal, .vertical]


    public init(
        uiImage: Binding<UIImage?>) {
            _uiImage = uiImage
        }

	public var body: some View {
		ScrollView([.horizontal, .vertical],
				   showsIndicators: false) {
			ZStack {
				Spacer()
					.containerRelativeFrame([.horizontal, .vertical])

				if let uiImage {
					Image(uiImage: uiImage)
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
            displaySize = uiImage?.size
            displayContentMode = UIDevice.current.userInterfaceIdiom == .phone ? .fill : .fit
        }
		.onTapGesture(count: 2, perform: {
			displayContentMode = (displayContentMode == .fit) ? .fill : .fit
		})
		.onChange(of: displayContentMode) {
			oldValue, newValue in

			updateScrollViewConfiguration(for: newValue)
		}
		.onChange(of: uiImage) {
			oldValue, newValue in

			updateScrollViewConfiguration(for: displayContentMode)
		}
        .onRotate{deviceOrientation in
            Task {
                updateScrollViewConfiguration(for: displayContentMode)
            }
        }
	}
}

fileprivate extension fXDscrollImage {
	func updateScrollViewConfiguration(for newContentMode: ContentMode) {
		guard let uiImage else {
			return
		}


		let containerSize = UIScreen.main.bounds.size
		let aspectSize = uiImage.aspectSize(for: displayContentMode, containerSize: containerSize)
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
