

import SwiftUI


public struct fXDsceneImageList: View {
	@Binding var selectedImageURL: URL?
	@Binding var imageURLs: [URL]

	@State var minDimension: CGFloat

	var action_LongPress: ((_ imageURL: URL?) -> Void)? = nil


	public init(minDimension: CGFloat? = nil, imageURLs: Binding<[URL]>, selectedImageURL: Binding<URL?>, action_LongPress: ((_ imageURL: URL?) -> Void)? = nil) {

		_selectedImageURL = selectedImageURL
		_imageURLs = imageURLs

		self.minDimension = minDimension ?? (UIDevice.current.userInterfaceIdiom == .phone ? 80.0 : 100.0)

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
				.frame(width: minDimension, height: minDimension, alignment: .center)
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
		.frame(width: minDimension)
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
