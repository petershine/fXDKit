

import SwiftUI


struct FXDButtonModifier: ViewModifier {
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var cornerRadius: CGFloat = 5.0

	func body(content: Content) -> some View {
		content
			.frame(width: touchableSize.width, height: touchableSize.height)
			.foregroundStyle(foregroundStyle)
			.backgroundStyle(backgroundStyle)
			.cornerRadius(cornerRadius)
			.overlay {
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(foregroundStyle, lineWidth: (cornerRadius/2.0))
			}
	}
}


public struct FXDswiftuiButton: View {
	var systemImageName: String
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var action: () -> Void

	public init(
		systemImageName: String,
		touchableSize: CGSize = CGSize(width: 40.0, height: 40.0),
		foregroundStyle: Color = .black,
		backgroundStyle: Color = .white,
		action: @escaping () -> Void) {
		self.systemImageName = systemImageName
		self.touchableSize = touchableSize
		self.foregroundStyle = foregroundStyle
		self.backgroundStyle = backgroundStyle
		self.action = action
	}
	
	public var body: some View {
		Button(action: action) {
			Image(systemName: systemImageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
		}
		.modifier(FXDButtonModifier(
			touchableSize: touchableSize,
			foregroundStyle: foregroundStyle,
			backgroundStyle: backgroundStyle))
	}
}
