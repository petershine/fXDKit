

//MARK: Static constants
public let MARGIN_DEFAULT: CGFloat = 8.0
public let DIMENSION_TOUCHABLE: CGFloat = 44.0
public let DURATION_ANIMATION: TimeInterval = 0.3
public let DURATION_QUICK_ANIMATION: TimeInterval = (DURATION_ANIMATION/2.0)
public let DURATION_SLOW_ANIMATION: TimeInterval = (DURATION_ANIMATION*2.0)

public let DURATION_ONE_SECOND: TimeInterval = 1.0
public let DURATION_QUARTER: TimeInterval = (DURATION_ONE_SECOND/4.0)

public let DURATION_FULL_MINUTE: TimeInterval = (DURATION_ONE_SECOND*60.0)


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
    for item in items {
        if let variable = item as? CVarArg {
            os_log("%@", (String(describing: variable) as NSString))
        }
    }
    #endif
}

public func fxd_log(_ prefix: String? = nil, _ suffix: String? = nil, filename: String = #file, function: String = #function) {
	#if DEBUG
	os_log(" ")
	os_log("\n\n%@[%@ %@]%@", ((prefix == nil) ? "" : prefix!), (filename as NSString).lastPathComponent, function, ((suffix == nil) ? "" : suffix!))
	#endif
}

public func fxd_overridable(_ filename: String = #file, function: String = #function) {
	#if DEBUG
	fxd_log("OVERRIDABLE: ", nil)
	#endif
}

public func fxd_todo(_ filename: String = #file, function: String = #function) {
	#if DEBUG
	fxd_log("//TODO: ", nil)
	#endif
}

public func fxd_log_func(_ filename: String = #file, function: String = #function) {
    #if DEBUG
    fxd_log()
    #endif
}
