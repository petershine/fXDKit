import SwiftUI

struct fXDViewModifierHide: ViewModifier {
	var shouldHide: Bool

	func body(content: Content) -> some View {
		content
			.opacity(shouldHide ? 0.0 : 1.0)
			.allowsHitTesting(shouldHide ? false : true)
	}
}

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-device-rotation
struct fXDViewModifierRotate: ViewModifier {
    let rotateReaction: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification)) {
                    _ in

                    rotateReaction(UIDevice.current.orientation)
                }
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

public struct fXDTextEditorModifier: ViewModifier {
    var backgroundStyle: Color
    var foregroundStyle: Color

    public init(backgroundStyle: Color? = nil, foregroundStyle: Color? = nil) {
        self.backgroundStyle = backgroundStyle ?? .black
        self.foregroundStyle = foregroundStyle ?? .white
    }

	public func body(content: Content) -> some View {
		content
			.scrollContentBackground(.hidden)
			.backgroundStyle(backgroundStyle)
			.foregroundStyle(foregroundStyle)
            .cornerRadius(4.0)
			.overlay {
				RoundedRectangle(cornerRadius: 4.0)
                    .stroke(.gray, lineWidth: 2.0)
			}
	}
}

public struct fXDTextRangeSelectableModifier: ViewModifier {
    public init() {
        // for external usage of fXDKit as module
    }

    public func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .textSelection(.enabled)
            .focusable(false)
    }
}
