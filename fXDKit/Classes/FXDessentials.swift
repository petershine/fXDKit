

//MARK: Static constants
public let MARGIN_DEFAULT: CGFloat = 8.0
public let DIMENSION_TOUCHABLE: CGFloat = 44.0
public let DURATION_ANIMATION: TimeInterval = 0.3
public let DURATION_QUICK_ANIMATION: TimeInterval = (DURATION_ANIMATION/2.0)
public let DURATION_SLOW_ANIMATION: TimeInterval = (DURATION_ANIMATION*2.0)

public let DURATION_ONE_SECOND: TimeInterval = 1.0
public let DURATION_QUARTER: TimeInterval = (DURATION_ONE_SECOND/4.0)


//MARK: Closures
public typealias FXDcallback = (_ result: Bool, _ object: Any?) -> Void


//MARK: Protocols
@objc protocol FXDprotocolObserver {
	func observedUIApplicationDidEnterBackground(_ notification: NSNotification)
	func observedUIApplicationDidBecomeActive(_ notification: NSNotification)
	func observedUIApplicationWillTerminate(_ notification: NSNotification)
	func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification)

	func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification)
	func observedUIDeviceOrientationDidChange(_ notification: NSNotification)
}


//MARK: Logging
import os.log

public func fxdPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    debugPrint(items, separator: separator, terminator: terminator)
    #endif
}

public func fxd_log_func(_ filename: String = #file, function: String = #function) {
    #if DEBUG
    os_log(" ")
    os_log("\n\n[%@ %@]", (filename as NSString).lastPathComponent, function)
    #endif
}
