

import SwiftUI


public struct fXDsceneImageList<Content: View>: View {
	@Binding var didMaximize: Bool

	@Binding var imageDimension: CGFloat

	@Binding var imageURLs: [URL]
	@Binding var selectedImageURL: URL?

	var action_LongPress: ((_ imageURL: URL?) -> Void)? = nil
	var attachedForMaximized: ((_ imageURL: URL?) -> Content)


	public init(didMaximize: Binding<Bool>,
				imageDimension: Binding<CGFloat>,
				imageURLs: Binding<[URL]>,
				selectedImageURL: Binding<URL?>,
				action_LongPress: ((_ imageURL: URL?) -> Void)? = nil,
				@ViewBuilder attachedForMaximized: @escaping ((_ imageURL: URL?) -> Content)) {

		_didMaximize = didMaximize

		_imageDimension = imageDimension

		_imageURLs = imageURLs
		_selectedImageURL = selectedImageURL

		self.action_LongPress = action_LongPress
		
		self.attachedForMaximized = attachedForMaximized
	}


	public var body: some View {
		List(
			imageURLs,
			id:\.self
		) {
			imageURL in

			LazyVStack {
				HStack {
					if didMaximize {
						attachedForMaximized(imageURL)
					}

					AsyncImage(
						url: imageURL,
						content: {
							pngImage in
							pngImage
								.resizable()
								.aspectRatio(contentMode: .fit)
								.overlay(content: {
									if imageURL == selectedImageURL {
										Rectangle()
											.stroke(Color.white, lineWidth: 1.0)
									}
								})
						},
						placeholder: {
						})
					.frame(width: imageDimension, height: imageDimension, alignment: .trailing)
					.clipShape(Rectangle())
					.onTapGesture(perform: {
						selectedImageURL = imageURL
					})
					.onLongPressGesture {
						action_LongPress?(imageURL)
					}
				}
			}
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
		}
		.shadow(color: .black, radius: 10.0)
		.scrollIndicators(.hidden)
		.listStyle(.plain)
		.onAppear(perform: {
			if selectedImageURL == nil,
			   let latest = imageURLs.first {
				selectedImageURL = latest
			}
		})
		.onChange(of: imageURLs, {
			oldValue, newValue in

			if let latest = newValue.first {
				selectedImageURL = latest
			}
		})
	}
}
