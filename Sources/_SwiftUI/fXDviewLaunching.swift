

import SwiftUI


public struct fXDviewLaunching: View {
	@State var appDisplayedName: String
	@State var shouldHideStatusBar: Bool

	@State var overlayColor: UIColor?
	@State var backgroundImage: UIImage?

	@State var foregroundImage: UIImage?
	@State var foregroundSize: CGSize

	public init(appDisplayedName: String? = nil, 
				shouldHideStatusBar: Bool = true,
				overlayColor: UIColor? = nil,
				backgroundImage: UIImage?,
				foregroundImage: UIImage?,
				foregroundSize: CGSize = .zero) {
		
		self.appDisplayedName = appDisplayedName ?? "Hello, world!"
		self.shouldHideStatusBar = shouldHideStatusBar

		self.overlayColor = overlayColor
		self.backgroundImage = backgroundImage
		
		self.foregroundImage = foregroundImage
		self.foregroundSize = foregroundSize
	}

	public var body: some View {
		ZStack {
			Color(overlayColor ?? .black)
				.frame(maxWidth: .infinity, maxHeight: .infinity)

			if backgroundImage != nil {
				Image(uiImage: backgroundImage!)
					.resizable()
					.scaledToFill()
			}

			if foregroundImage != nil {
				if foregroundSize != .zero {
					Image(uiImage: foregroundImage!)
						.resizable()
						.frame(
							width: foregroundSize.width,
							height: foregroundSize.height,
							alignment: .center)
				}
				else {
					Image(uiImage: foregroundImage!)
						.fixedSize()
				}
			}

			VStack {
				Spacer()
				ProgressView().controlSize(.large).padding()
			}
		}
		.ignoresSafeArea()
		.statusBarHidden(shouldHideStatusBar)
	}
}


// Usage for hosted
open class FXDhostedLaunching: UIHostingController<fXDviewLaunching> {
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

	override open func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = rootView.overlayColor ?? UIColor.black
	}
}
