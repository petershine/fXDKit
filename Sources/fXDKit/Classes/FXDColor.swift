

import Foundation
import UIKit


fileprivate var rotatedIndex: Int = 0

extension UIColor {
	class var allPresetColors: [UIColor] {
		return [
//			.black,
			.darkGray,
			.lightGray,
//			.white,
			.gray,
			.red,
			.green,
			.blue,
			.cyan,
			.yellow,
			.magenta,
			.orange,
			.purple,
			.brown,
//			.clear,
			.systemRed,
			.systemBlue,
			.systemGreen,
			.systemOrange,
			.systemYellow,
			.systemPink,
			.systemTeal,
			.systemIndigo,
			.systemPurple,
			.systemGray,
			.systemGray2,
			.systemGray3,
			.systemGray4,
			.systemGray5,
			.systemGray6
		]
	}

	class func nextColor() -> UIColor {
		let nextColor = Self.allPresetColors[rotatedIndex]
		rotatedIndex += 1
		rotatedIndex = rotatedIndex % Self.allPresetColors.count
		return nextColor
	}
}
