

import Foundation
import UIKit


@MainActor fileprivate var rotatedIndex: Int = 0

extension UIColor {
	class var allPresetColors: [UIColor] {
		return [
			.systemRed,
			.systemBlue,
			.systemGreen,
			.systemOrange,
			.systemYellow,
			.systemPink,
			.systemTeal,
			.systemIndigo,
			.systemPurple,
			
			.red,
			.blue,
			.green,
			.orange,
			.yellow,
			.magenta,
			.brown,
			.cyan,
			.purple,

			.black,
			.darkGray,
			.gray,
			.lightGray,
			.white,

			.systemGray,
			.systemGray2,
			.systemGray3,
			.systemGray4,
			.systemGray5,
			.systemGray6
		]
	}

    @MainActor class func nextColor() -> UIColor {
		let nextColor = Self.allPresetColors[rotatedIndex]
		rotatedIndex += 1
		rotatedIndex = rotatedIndex % Self.allPresetColors.count
		return nextColor
	}
}
