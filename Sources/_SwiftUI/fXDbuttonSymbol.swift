

import SwiftUI


public struct fXDbuttonSymbol: View {
	var systemName: String
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
	var action: () -> Void

	public init(
		_ systemName: String,
		touchableSize: CGSize = SIZE_TOUCHABLE,
		foregroundStyle: Color = .white,
		backgroundStyle: Color = .black,
		strokeStyle: Color = .clear,
		hideShadow: Bool = false,
		action: @escaping () -> Void) {

			self.systemName = systemName
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
}

// for using Button as spacing unit
public struct fXDbuttonAsSpacer: View {
	public init() {}

	public var body: some View {
		fXDbuttonSymbol("space", action: {}).hidden()
	}
}
