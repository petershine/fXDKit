

import SwiftUI


struct fXDViewModifier: ViewModifier {
	var shouldHide: Bool

	func body(content: Content) -> some View {
		content
			.opacity(shouldHide ? 0.0 : 1.0)
			.allowsHitTesting(shouldHide ? true : false)
	}
}


struct fXDButtonModifier: ViewModifier {
	var touchableSize: CGSize
	var foregroundStyle: Color
	var backgroundStyle: Color
	var strokeStyle: Color
	var hideShadow: Bool
	var cornerRadius: CGFloat

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


struct fXDTextEditorModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.scrollContentBackground(.hidden)
			.backgroundStyle(.black)
			.foregroundStyle(.white)
			.cornerRadius(10.0)
			.overlay {
				RoundedRectangle(cornerRadius: 10.0)
					.stroke(.black, lineWidth:4.0)
			}
			.padding()
	}
}
