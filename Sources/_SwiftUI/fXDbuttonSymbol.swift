

import SwiftUI


public struct fXDbuttonSymbol: View {
	var systemName: String
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
    var shouldAnimate: Bool
    @State var shadowOpacity: CGFloat
    var action: () -> Void



	public init(
		_ systemName: String,
		touchableSize: CGSize = SIZE_TOUCHABLE_LARGE,
		foregroundStyle: Color = .white,
		backgroundStyle: Color = .black,
		strokeStyle: Color = .clear,
		hideShadow: Bool = false,
        shouldAnimate: Bool = false,
        shadowOpacity: CGFloat = 0.6,
		action: @escaping () -> Void) {

			self.systemName = systemName
			self.touchableSize = touchableSize
			self.foregroundStyle = foregroundStyle
			self.backgroundStyle = backgroundStyle
			self.strokeStyle = strokeStyle
			self.hideShadow = hideShadow
            self.shouldAnimate = shouldAnimate
            self.shadowOpacity = shadowOpacity
			self.action = action
	}
	
    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundStyle)
                .opacity(shadowOpacity)
                .blur(radius: 24.0)
                .frame(width: touchableSize.width, height: touchableSize.height)

            Button(action: action) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .modifier(
                fXDButtonModifier(
                    touchableSize: touchableSize,
                    foregroundStyle: foregroundStyle,
                    backgroundStyle: backgroundStyle,
                    strokeStyle: strokeStyle,
                    hideShadow: hideShadow,
                    cornerRadius: 5.0)
            )
        }
        .onAppear {
            if shouldAnimate {
                withAnimation(
                    Animation.easeInOut(duration: 0.3)
                        .repeatForever(autoreverses: true)) {
                            shadowOpacity *= 0.5
                        }
            }
        }
    }
}
