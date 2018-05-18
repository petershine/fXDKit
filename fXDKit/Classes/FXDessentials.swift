

//MARK: Static constants
public let MARGIN_DEFAULT: CGFloat = 8.0


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

func fxdPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    debugPrint(items, separator: separator, terminator: terminator)
    #endif
}

func fxdFuncPrint(_ filename: String = #file, function: String = #function) {
    #if DEBUG
    os_log(" ")
    os_log("\n\n[%@ %@]", (filename as NSString).lastPathComponent, function)
    #endif
}
