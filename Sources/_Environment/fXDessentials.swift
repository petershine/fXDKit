

import Foundation
import UIKit


//MARK: Static constants
public let MARGIN_DEFAULT: CGFloat = 8.0
public let DIMENSION_TOUCHABLE: CGFloat = 40.0
public let DURATION_ANIMATION: TimeInterval = 0.3
public let DURATION_QUICK_ANIMATION: TimeInterval = (DURATION_ANIMATION/2.0)
public let DURATION_SLOW_ANIMATION: TimeInterval = (DURATION_ANIMATION*2.0)

public let DURATION_ONE_SECOND: TimeInterval = 1.0
public let DURATION_QUARTER: TimeInterval = (DURATION_ONE_SECOND/4.0)

public let DURATION_FULL_MINUTE: TimeInterval = (DURATION_ONE_SECOND*60.0)

public let LIMIT_CACHED_OBJ: Int = 1000

public let MAXIMUM_LENGTH_TWEET: Int = 140

public let HOST_SHORT_YOUTUBE: String = "youtu.be/"

@MainActor public let SIZE_TOUCHABLE: CGSize = (UIDevice.current.userInterfaceIdiom == .phone ? CGSizeMake(DIMENSION_TOUCHABLE*0.75, DIMENSION_TOUCHABLE*0.75) : CGSizeMake(DIMENSION_TOUCHABLE, DIMENSION_TOUCHABLE))
@MainActor public let SIZE_TOUCHABLE_LARGE: CGSize = (UIDevice.current.userInterfaceIdiom == .phone ? CGSizeMake(DIMENSION_TOUCHABLE, DIMENSION_TOUCHABLE) : CGSizeMake(DIMENSION_TOUCHABLE*1.2, DIMENSION_TOUCHABLE*1.2))

@MainActor public let DIMENSION_PREVIEW: CGFloat = {
	let minDimension = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

	var maxDimension = minDimension*0.4
	if UIDevice.current.userInterfaceIdiom == .phone {
		maxDimension = minDimension*0.5
	}

	return maxDimension
}()

@MainActor public let DIMENSION_MINIMUM_IMAGE: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone ? 80.0 : 140.0)


//MARK: Closures
public typealias FXDcallback = (@Sendable (_ result: Bool, _ object: Any?) -> Void)


//MARK: Protocols
@MainActor
@objc public protocol FXDobserverApplication {
	func observedUIApplicationDidEnterBackground(_ notification: NSNotification)
	func observedUIApplicationDidBecomeActive(_ notification: NSNotification)
	func observedUIApplicationWillTerminate(_ notification: NSNotification)
	func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification)

	func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification)
	func observedUIDeviceOrientationDidChange(_ notification: NSNotification)
}

@MainActor
public protocol FXDobserverNSManagedObject {
	func observedUIDocumentStateChanged(_ notification: Notification?)

	func observedNSPersistentStoreDidImportUbiquitousContentChanges(_ notification: Notification?)

	func observedNSManagedObjectContextObjectsDidChange(_ notification: Notification?)
	func observedNSManagedObjectContextWillSave(_ notification: Notification?)
	func observedNSManagedObjectContextDidSave(_ notification: Notification?)
}

public protocol FXDprotocolAppConfig {
	var appStoreID: String { get }

	var URIscheme: String { get }

	var homeURL: String { get }
	var shortHomeURL: String { get }

	var facebookURIscheme: String { get }
	var twitterName: String { get }

	var contactEmail: String { get }

	var launchingBackgroundImagename: String { get }
	var launchingForegroundImagename: String { get }
	var launchingForegroundSize: CGSize { get }

	var bundledSqliteFile: String { get }

	var delayBeforeClearForMemory: TimeInterval { get }

	var minimumDeviceBatteryLevel: Float { get }
	var badgeCountKeyName: String { get }
}

public protocol FXDrawRepresentable {
	var stringValue: String { get }
}

public protocol FXDrawString {
	func stringValue(for enumCase: Int) -> String?
}


//MARK: Logging
import os.log

public func fxdPrint(_ items: Any?..., separator: String = " ", terminator: String = "\n", quiet: Bool = false) {
	#if DEBUG
	// Instead of just not using this function, "quiet=" can keep it in the source, and later control its function as needed.
	guard !quiet else {
		return
	}


	let unwrapped: [Any] = items.map { ($0 != nil ? ($0)! : ($0) as Any) }
	
	debugPrint(unwrapped, separator: separator, terminator: terminator)
	#endif
}

public func fxdPrint(name: String? = nil, dictionary: Dictionary<String, Any?>?) {
	#if DEBUG
	if let dictionary {
		os_log("[%@]:\n%@\n\n", (name ?? "dictionary"), dictionary)
	}
	else {
		fxdPrint("[\(name ?? "dictionary")]", dictionary)
	}
	#endif
}

public func fxd_log(_ prefix: String? = nil, _ suffix: String? = nil, filename: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
	os_log(" ")
	os_log("%@[%@ %@]%@", ((prefix == nil) ? "" : prefix!), (filename as NSString).lastPathComponent, function, ((suffix == nil) ? "" : suffix!))
	#endif
}

public func fxd_overridable(_ filename: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
	fxd_log("OVERRIDABLE: ", nil, filename: filename, function: function, line: line)
	#endif
}

public func fxd_todo(_ filename: String = #file, function: String = #function, line: Int = #line, message: String? = nil) {
	#if DEBUG
	let suffix = "\(message ?? "") (at \(line))"
	fxd_log("//TODO: ", suffix, filename: filename, function: function, line: line)
	#endif
}

