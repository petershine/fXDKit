

import SwiftUI


@available(iOS 17.0, *)
public struct FXDswiftuiMediaDisplay: View {
	@Environment(\.colorScheme) var colorScheme

	@Binding var diaplayedImage: UIImage?


	public init(displayedImage: UIImage? = nil) {
		_diaplayedImage = Binding.constant(displayedImage)
	}

	public var body: some View {
		Color(.black)
			.overlay {
				if let availableImage = diaplayedImage {
					Image(uiImage: availableImage)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.gesture(
							LongPressGesture().onEnded { _ in
								if let availableImage = diaplayedImage {
									showActivitySheet(items: [availableImage])
								}
							})
				}
			}
			.ignoresSafeArea()
	}
}

fileprivate extension FXDswiftuiMediaDisplay {
	func showActivitySheet(items: [Any]) {
		guard let rootViewController = UIApplication.shared.mainWindow()?.rootViewController else {
			return
		}


		let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
		if let popoverController = activityController.popoverPresentationController {
			let sourceRectCenter = CGPoint(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY)
			
			popoverController.sourceView = rootViewController.view
			popoverController.sourceRect = CGRect(origin: sourceRectCenter, size: CGSize(width: 1, height: 1))
			popoverController.permittedArrowDirections = []
		}
		
		rootViewController.present(activityController, animated: true)
	}
}


@available(iOS 17.0, *)
#Preview {
	FXDswiftuiMediaDisplay(displayedImage: UIImage())
}
