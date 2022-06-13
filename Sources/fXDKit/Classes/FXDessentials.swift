

//MARK: Static constants
public let MARGIN_DEFAULT: CGFloat = 8.0
public let DIMENSION_TOUCHABLE: CGFloat = 44.0
public let DURATION_ANIMATION: TimeInterval = 0.3
public let DURATION_QUICK_ANIMATION: TimeInterval = (DURATION_ANIMATION/2.0)
public let DURATION_SLOW_ANIMATION: TimeInterval = (DURATION_ANIMATION*2.0)

public let DURATION_ONE_SECOND: TimeInterval = 1.0
public let DURATION_QUARTER: TimeInterval = (DURATION_ONE_SECOND/4.0)

public let DURATION_FULL_MINUTE: TimeInterval = (DURATION_ONE_SECOND*60.0)

public let LIMIT_CACHED_OBJ: Int = 1000

public let MAXIMUM_LENGTH_TWEET: Int = 140


//MARK: Closures
public typealias FXDcallback = (_ result: Bool, _ object: Any?) -> Void


//MARK: Protocols
@objc public protocol FXDprotocolObserver {
	func observedUIApplicationDidEnterBackground(_ notification: NSNotification)
	func observedUIApplicationDidBecomeActive(_ notification: NSNotification)
	func observedUIApplicationWillTerminate(_ notification: NSNotification)
	func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification)

	func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification)
	func observedUIDeviceOrientationDidChange(_ notification: NSNotification)
}

public protocol FXDprotocolAppConfig {
    var appStoreID: String { get }
    
    var URIscheme: String { get }

    var homeURL: String { get }
    var shortHomeURL: String { get }

	var facebookURIscheme: String { get }
    var twitterName: String { get }
    
    var contactEmail: String { get }

	var launchScene: String { get }
	var bundledSqliteFile: String { get }

	var delayBeforeClearForMemory: TimeInterval { get }
}

public protocol FXDrawRepresentable {	//}: RawRepresentable {	// until ready to remove ALL ObjC
	var stringValue: String { get }
}

public protocol FXDrawString {
	func stringValue(for enumCase: Int) -> String?
}


//MARK: Logging
import os.log

public func fxdPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    for item in items {
        if let variable = item as? CVarArg {
            os_log("%@", (String(describing: variable) as NSString))
        }
    }
    #endif
}

public func fxd_log(_ prefix: String? = nil, _ suffix: String? = nil, filename: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
	os_log(" ")
	os_log("\n\n    %@[%@ %@]%@", ((prefix == nil) ? "" : prefix!), (filename as NSString).lastPathComponent, function, ((suffix == nil) ? "" : suffix!))
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

