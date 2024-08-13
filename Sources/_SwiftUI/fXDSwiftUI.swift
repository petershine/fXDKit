

import SwiftUI


extension View {
	public func shouldHide(_ shouldHide: Bool) -> some View {
		modifier(fXDViewModifier(shouldHide: shouldHide))
	}

    public func base64EncodedImage(result: (Result<URL, any Error>)?) throws -> String? {	fxd_log()
        fxdPrint("result:", result)
        guard let imageURL = try result?.get() else {
            return nil
        }

        return try base64EncodedImage(imageURL: imageURL)
    }

    public func base64EncodedImage(imageURL: URL?) throws -> String? {	fxd_log()
        fxdPrint("imageURL: ", imageURL)
        guard let imageURL else {
            return nil
        }

        var base64Encoded: String? = nil
        if imageURL.startAccessingSecurityScopedResource() {
            let imageData = try Data(contentsOf: imageURL)
            imageURL.stopAccessingSecurityScopedResource()

            fxdPrint("imageData: ", imageData)
            base64Encoded = imageData.base64EncodedString()
        }

        fxdPrint("base64Encoded?.count:", base64Encoded?.count)

        return base64Encoded
    }
}


@ViewBuilder public func SPACER_FIXED(_ maxDimension: CGFloat = max(SIZE_TOUCHABLE.width, SIZE_TOUCHABLE.height)) -> some View {
	Spacer().frame(width: maxDimension, height: maxDimension, alignment: .center)
}


@ViewBuilder public func ASYNC_IMAGE(_ imageURL: URL?) -> some View {
	AsyncImage(
		url: imageURL,
		content: {
			pngImage in
			pngImage
				.resizable()
				.aspectRatio(contentMode: .fit)
		},
		placeholder: {
		})
	.frame(width: DIMENSION_PREVIEW, height: DIMENSION_PREVIEW, alignment: .center)
	.clipShape(Rectangle())
}
