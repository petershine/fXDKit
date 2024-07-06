

import SwiftUI


struct FXDButtonModifier: ViewModifier {
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
	var cornerRadius: CGFloat = 5.0

	func body(content: Content) -> some View {
		content
			.frame(width: touchableSize.width, height: touchableSize.height)
			.foregroundStyle(foregroundStyle)
			.backgroundStyle(backgroundStyle)
			.cornerRadius(cornerRadius)
			.shadow(radius: hideShadow ? 0.0 : 10.0)
			.overlay {
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(strokeStyle, lineWidth: (cornerRadius/2.0))
			}
	}
}


public struct fXDbuttonSymbol: View {
	var systemName: String
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
	var action: () -> Void

	public init(
		_ systemImageName: String,
		touchableSize: CGSize = SIZE_TOUCHABLE,
		foregroundStyle: Color = .white,
		backgroundStyle: Color = .black,
		strokeStyle: Color = .clear,
		hideShadow: Bool = false,
		action: @escaping () -> Void) {

			self.systemName = systemImageName
			self.touchableSize = touchableSize
			self.foregroundStyle = foregroundStyle
			self.backgroundStyle = backgroundStyle
			self.strokeStyle = strokeStyle
			self.hideShadow = hideShadow
			self.action = action
	}
	
	public var body: some View {
		Button(action: action) {
			Image(systemName: systemName)
				.resizable()
				.aspectRatio(contentMode: .fit)
		}
		.modifier(FXDButtonModifier(
			touchableSize: touchableSize,
			foregroundStyle: foregroundStyle,
			backgroundStyle: backgroundStyle,
			strokeStyle: strokeStyle,
			hideShadow: hideShadow))
	}
}

// for using Button as spacing unit
public struct fXDbuttonAsSpacer: View {
	public init() {

	}

	public var body: some View {
		fXDbuttonSymbol("space", action: {}).hidden()
	}
}
