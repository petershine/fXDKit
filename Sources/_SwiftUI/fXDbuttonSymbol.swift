

import SwiftUI


public struct fXDbuttonSymbol: View {
	var systemName: String
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
    var shouldAnimate: Bool
    var action: () -> Void

    @State private var animatingOpacity: CGFloat = 1.0


	public init(
		_ systemName: String,
		touchableSize: CGSize = SIZE_TOUCHABLE_LARGE,
		foregroundStyle: Color = .white,
		backgroundStyle: Color = .black,
		strokeStyle: Color = .clear,
		hideShadow: Bool = false,
        shouldAnimate: Bool = false,
		action: @escaping () -> Void) {

			self.systemName = systemName
			self.touchableSize = touchableSize
			self.foregroundStyle = foregroundStyle
			self.backgroundStyle = backgroundStyle
			self.strokeStyle = strokeStyle
			self.hideShadow = hideShadow
            self.shouldAnimate = shouldAnimate
			self.action = action
	}
	
    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundStyle)
                .opacity(animatingOpacity)
                .blur(radius: 8.0)
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
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)) {
                            animatingOpacity = 0.8
                        }
            }
        }
    }
}
