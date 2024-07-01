

import SwiftUI


public struct fXDsceneImageScrollview: View {
	@Binding var displayImage: UIImage?

	@State private var displayContentMode: ContentMode = .fit
	@State private var displaySize: CGSize?
	@State private var displayAxisSet: Axis.Set = []

	var action_OnTap: (() -> Void)? = nil


	public init(displayImage: Binding<UIImage?>, action_OnTap: (() -> Void)? = nil) {
		_displayImage = displayImage

		displaySize = displayImage.wrappedValue?.size

		self.action_OnTap = action_OnTap
	}

	public var body: some View {
		ScrollView(displayAxisSet,
				   showsIndicators: false) {
			ZStack {
				Spacer()
					.containerRelativeFrame([.horizontal, .vertical])
					.ignoresSafeArea()

				if let displayImage {
					Image(uiImage: displayImage)
						.resizable()
						.frame(width: displaySize?.width, height: displaySize?.height, alignment: .center)
						.ignoresSafeArea()
				}
			}
		}
		.background {
			Color(.black)
		}
		.ignoresSafeArea()
		.scrollBounceBehavior(.basedOnSize)
		.gesture(
			TapGesture(count: 2).onEnded {
				displayContentMode = (displayContentMode == .fit) ? .fill : .fit
			}.exclusively(before: TapGesture(count: 1).onEnded {
				action_OnTap?()
			})
		)
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

fileprivate extension fXDsceneImageScrollview {
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
