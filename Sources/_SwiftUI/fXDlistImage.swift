

import SwiftUI


public struct fXDlistImage<Content: View>: View {
    @Binding var didMaximize: Bool

    @Binding var imageDimension: CGFloat

    @Binding var imageURLs: [URL]?
    @Binding var selectedImageURL: URL?

    var action_LongPress: ((_ imageURL: URL?) -> Void)? = nil
    var attachedForMaximized: ((_ imageURL: URL?) -> Content)? = nil


    public init(
        didMaximize: Binding<Bool>,
        imageDimension: Binding<CGFloat>,
        imageURLs: Binding<[URL]?>,
        selectedImageURL: Binding<URL?>,
        
        action_LongPress: ((_: URL?) -> Void)? = nil,
        attachedForMaximized: @escaping ((_: URL?) -> Content)) {

            _didMaximize = didMaximize
            _imageDimension = imageDimension
            _imageURLs = imageURLs
            _selectedImageURL = selectedImageURL

            self.action_LongPress = action_LongPress
            self.attachedForMaximized = attachedForMaximized
        }

    public var body: some View {
        List(
            imageURLs ?? [],
            id:\.self
        ) {
            imageURL in

            LazyVStack {
                HStack {
                    if didMaximize {
                        attachedForMaximized?(imageURL)
                    }

                    AsyncImage(
                        url: imageURL.thumbnailURL,
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
            .listRowInsets(EdgeInsets(top: MARGIN_DEFAULT, leading: 0, bottom: MARGIN_DEFAULT, trailing: 0))
        }
        .shadow(color: .black, radius: 10.0)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .onChange(of: imageURLs ?? [], {
            oldValue, newValue in

            if let latest = newValue.first {
                selectedImageURL = latest
            }
        })
        .task {
            if selectedImageURL == nil,
               let latest = imageURLs?.first {
                selectedImageURL = latest
            }
        }
    }
}
