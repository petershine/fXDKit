

import SwiftUI


public struct FXDswiftuiLaunching: View {
	@State var appDisplayedName: String
	@State var shouldHideStatusBar: Bool

	@State var backgroundImage: UIImage?

	@State var foregroundImage: UIImage?
	@State var foregroundSize: CGSize

	public init(appDisplayedName: String? = nil, shouldHideStatusBar: Bool = true, backgroundImage: UIImage?, foregroundImage: UIImage?, foregroundSize: CGSize = .zero) {
		self.appDisplayedName = appDisplayedName ?? "Hello, world!"
		self.shouldHideStatusBar = shouldHideStatusBar

		self.backgroundImage = backgroundImage
		
		self.foregroundImage = foregroundImage
		self.foregroundSize = foregroundSize
	}

	public var body: some View {
		ZStack {
			if backgroundImage != nil {
				Image(uiImage: backgroundImage!)
					.resizable().scaledToFill().ignoresSafeArea()
			}

			if foregroundImage != nil {
				if foregroundSize != .zero {
					Image(uiImage: foregroundImage!)
						.resizable().frame(width: foregroundSize.width, height: foregroundSize.height, alignment: .center)
				}
				else {
					Image(uiImage: foregroundImage!)
						.fixedSize()
				}
			}

			VStack {
				Spacer()
				ProgressView().controlSize(.large)
			}
		}
		.statusBarHidden(shouldHideStatusBar)
	}
}

#Preview {
	FXDswiftuiLaunching(backgroundImage: nil, foregroundImage: nil)
}


// Usage for hosted
open class FXDhostedLaunching: UIHostingController<FXDswiftuiLaunching> {
	 override open var preferredStatusBarStyle: UIStatusBarStyle {
		 return .default
	 }
	 override open var prefersStatusBarHidden: Bool {
		 return true
	 }
	 override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		 return .fade
	 }
	 override open var shouldAutorotate: Bool {
		 return false
	 }
}
