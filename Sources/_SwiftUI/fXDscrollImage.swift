import SwiftUI

public struct fXDscrollImage: View {
	@Binding var uiImage: UIImage?
    @Binding var backgroundColor: Color?

	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize?
	@State private var restrictedBouncing: Axis.Set = [.horizontal, .vertical]

    public init(uiImage: Binding<UIImage?>, backgroundColor: Binding<Color?> = .constant(.clear)) {
        _uiImage = uiImage
        _backgroundColor = backgroundColor
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
            backgroundColor
		}
		.ignoresSafeArea()
		.scrollBounceBehavior(.basedOnSize, axes: restrictedBouncing)
        .task {
            displaySize = uiImage?.size
            displayContentMode = UIDevice.current.userInterfaceIdiom == .phone ? .fill : .fit

            updateScrollViewConfiguration(for: displayContentMode)
        }
		.onTapGesture(count: 2, perform: {
			displayContentMode = (displayContentMode == .fit) ? .fill : .fit
		})
		.onChange(of: displayContentMode) {
			_, newValue in

			updateScrollViewConfiguration(for: newValue)
		}
		.onChange(of: uiImage) {
			_, _ in

			updateScrollViewConfiguration(for: displayContentMode)
		}
        .onRotate {_ in
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
        withAnimation(.easeInOut(duration: 0.3)) {
            displaySize = aspectSize
        }

        var newAxisSet = restrictedBouncing
		if newContentMode == .fit
			|| (aspectSize.width <= containerSize.width && aspectSize.height <= containerSize.height) {

            newAxisSet = [.horizontal, .vertical]
		} else if aspectSize.width > containerSize.width {
            newAxisSet = [.vertical]
		} else if aspectSize.height > containerSize.height {
            newAxisSet = [.horizontal]
		}

        restrictedBouncing = newAxisSet
	}
}
