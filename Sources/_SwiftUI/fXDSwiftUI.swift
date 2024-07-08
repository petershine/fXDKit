

import SwiftUI


extension View {
	public func shouldHide(_ shouldHide: Bool) -> some View {
		modifier(fXDViewModifier(shouldHide: shouldHide))
	}
}


@ViewBuilder public func SPACER_FIXED(_ maxDimension: CGFloat = max(SIZE_TOUCHABLE.width, SIZE_TOUCHABLE.height)) -> some View {
	Spacer().frame(width: maxDimension, height: maxDimension, alignment: .center)
}
