

import SwiftUI


public struct FXDswiftuiLaunching: View {
	@State var shouldHideStatusBar: Bool = true

	@State var backgroundImagename: String
	@State var foregroundImagename: String

	public init(backgroundImagename: String, foregroundImagename: String) {
		self.backgroundImagename = backgroundImagename
		self.foregroundImagename = foregroundImagename
	}

	public var body: some View {
		ZStack {
			Image(backgroundImagename, bundle: nil).resizable().scaledToFill().ignoresSafeArea()
			Image(foregroundImagename, bundle: nil).fixedSize()

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
open class FXDhostingLaunching: UIHostingController<FXDswiftuiLaunching> {
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
