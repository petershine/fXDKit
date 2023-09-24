

import SwiftUI


public struct FXDswiftuiLaunching: View {
	@State var shouldHideStatusBar: Bool

	@State var backgroundImagename: String
	
	@State var foregroundImagename: String
	@State var foregroundSize: CGSize

	public init(shouldHideStatusBar: Bool = true, backgroundImagename: String, foregroundImagename: String, foregroundSize: CGSize = .zero) {

		self.shouldHideStatusBar = shouldHideStatusBar

		self.backgroundImagename = backgroundImagename
		
		self.foregroundImagename = foregroundImagename
		self.foregroundSize = foregroundSize
	}

	public var body: some View {
		ZStack {
			Image(backgroundImagename, bundle: nil).resizable().scaledToFill().ignoresSafeArea()

			if foregroundSize != .zero {
				Image(foregroundImagename, bundle: nil).resizable().frame(width: foregroundSize.width, height: foregroundSize.height, alignment: .center)
			}
			else {
				Image(foregroundImagename, bundle: nil).fixedSize()
			}

			VStack {
				Spacer()
				if #available(iOS 15.0, *) {
					ProgressView().controlSize(.large).tint(.black)
				}
				else {
					ProgressView()
				}
			}
		}
		.statusBarHidden(shouldHideStatusBar)
	}
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


#Preview {
	FXDswiftuiLaunching(backgroundImagename: "backgroundImagename", foregroundImagename: "foregroundImagename")
}
