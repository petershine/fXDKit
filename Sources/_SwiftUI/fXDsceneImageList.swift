

import SwiftUI


public struct fXDsceneImageList: View {
	@Binding var imageDimension: CGFloat
	@Binding var imageAlignment: Alignment

	@Binding var imageURLs: [URL]
	@Binding var selectedImageURL: URL?

	var action_LongPress: ((_ imageURL: URL?) -> Void)? = nil


	public init(imageDimension: Binding<CGFloat>,
				imageAlignment: Binding<Alignment>,
				imageURLs: Binding<[URL]>,
				selectedImageURL: Binding<URL?>,
				action_LongPress: ((_ imageURL: URL?) -> Void)? = nil) {

		_imageDimension = imageDimension
		_imageAlignment = imageAlignment

		_imageURLs = imageURLs
		_selectedImageURL = selectedImageURL

		self.action_LongPress = action_LongPress
	}


	public var body: some View {
		List(
			imageURLs,
			id:\.self
		) {
			imageURL in

			LazyVStack {
				AsyncImage(url: imageURL) { pngImage in
					pngImage
						.resizable()
						.aspectRatio(contentMode: .fit)
						.overlay(content: {
							if imageURL == selectedImageURL {
								Rectangle()
									.stroke(Color.white, lineWidth: 1.0)
							}
						})
				}
				placeholder: {
				}
				.frame(width: imageDimension, height: imageDimension, alignment: imageAlignment)
				.clipShape(Rectangle())
				.onTapGesture(perform: {
					selectedImageURL = imageURL
				})
				.onLongPressGesture {
					action_LongPress?(imageURL)
				}
			}
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
		}
		.shadow(color: .black, radius: 10.0)
		.scrollIndicators(.hidden)
		.listStyle(.plain)
		.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
