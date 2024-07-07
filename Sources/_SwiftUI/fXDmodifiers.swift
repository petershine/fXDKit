

import SwiftUI


struct fXDViewModifier: ViewModifier {
	@Binding var shouldHide: Bool?

	func body(content: Content) -> some View {
		if let shouldHide {
			content
				.opacity(shouldHide ? 0.0 : 1.0)
		}
		content
	}
}

extension View {
	func shouldHide(_ shouldHide: Binding<Bool?>) -> some View {
		modifier(fXDViewModifier(shouldHide: shouldHide))
	}
}
