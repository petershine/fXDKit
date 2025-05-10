

import SwiftUI
import Foundation


public struct FXDProgressBar: View {
    @Binding var value: CGFloat

    fileprivate var maxValue: CGFloat = 1.0
    fileprivate var barHeight: CGFloat = 4.0


	init(value: Binding<CGFloat>) {
		_value = value
	}

	public var body: some View {
		ZStack {
			GeometryReader{ proxy in
				Capsule()
					.fill(.secondary)

				Capsule()
					.fill(.tint)
					.frame(width: proxy.size.width * (value / maxValue), 
						   height: proxy.size.height,
						   alignment: .leading)
			}
		}
		.frame(height: barHeight)
	}
}
