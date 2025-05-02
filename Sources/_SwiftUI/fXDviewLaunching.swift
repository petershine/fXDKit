

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
                .overlay {
                    if backgroundImage != nil {
                        Image(uiImage: backgroundImage!)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .ignoresSafeArea()

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
                ZStack {
                    Circle()
                        .fill(.black)
                        .opacity(0.6)
                        .blur(radius: 10.0)
                        .frame(width: UNIT_TOUCHABLE, height: UNIT_TOUCHABLE)

                    ProgressView().controlSize(.large).padding()
                }
                SPACER_FIXED()
			}
		}
		.statusBarHidden(shouldHideStatusBar)
	}
}


// Usage for hosted
open class FXDhostedLaunching: UIHostingController<fXDviewLaunching>, @unchecked Sendable {
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
