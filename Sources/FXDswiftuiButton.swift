

import SwiftUI


let touchableDimension: CGFloat = 50.0


@available(iOS 17.0, *)
struct FXDButtonModifier: ViewModifier {
	var frame: CGRect = CGRect(x: 0.0, y: 0.0, width: touchableDimension, height: touchableDimension)
	var foregroundStyle: Color = .black
	var backgroundStyle: Color = .white
	var cornerRadius: CGFloat = (touchableDimension/5.0)

	func body(content: Content) -> some View {
		content
			.frame(width: frame.size.width, height: frame.size.height)
			.foregroundStyle(foregroundStyle)
			.backgroundStyle(backgroundStyle)
			.cornerRadius(cornerRadius)
			.overlay {
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(foregroundStyle, lineWidth: (cornerRadius/2.0))
			}
	}
}


@available(iOS 17.0, *)
public struct FXDswiftuiButton: View {
	var systemImageName: String
	var foregroundStyle: Color
	var backgroundStyle: Color
	var action: () -> Void

	public init(systemImageName: String, foregroundStyle: Color = .black, backgroundStyle: Color = .white, action: @escaping () -> Void) {
		self.systemImageName = systemImageName
		self.foregroundStyle = foregroundStyle
		self.backgroundStyle = backgroundStyle
		self.action = action
	}
	
	public var body: some View {
		Button(action: action) {
			Image(systemName: systemImageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding(5.0)
		}
		.modifier(FXDButtonModifier(foregroundStyle: foregroundStyle, backgroundStyle: backgroundStyle))
	}
}
