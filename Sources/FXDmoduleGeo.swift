import fXDObjC

import CoreLocation
import MapKit


open class FXDmoduleGeo: NSObject, @unchecked Sendable {
	private var monitoringTask: UIBackgroundTaskIdentifier? = nil
	
	open var lastLocation: CLLocation? = nil
	open var didStartSignificantMonitoring: Bool = false

	public var mainLocationManager: CLLocationManager? = {
		let locationManager = CLLocationManager()
		locationManager.activityType = .other
		locationManager.distanceFilter = kCLDistanceFilterNone

		locationManager.pausesLocationUpdatesAutomatically = false
		/*
		*      With UIBackgroundModes set to include "location" in Info.plist, you must
		*      also set this property to YES at runtime whenever calling
		*      -startUpdatingLocation with the intent to continue in the background.
		*
		*      Setting this property to YES when UIBackgroundModes does not include
		*      "location" is a fatal error.
		*/
		locationManager.allowsBackgroundLocationUpdates = true

		return locationManager
	}()

	open var distantEnoughFromLastLocation: Bool {
		get {
			if lastLocation == nil {	fxd_overridable()
				lastLocation = mainLocationManager?.location
				return true
			}

			return false
		}
		set { }
	}

	open var didUserAuthorize: Bool {
		get {
			let authorizationStatus: CLAuthorizationStatus = mainLocationManager?.authorizationStatus ?? .notDetermined

			guard authorizationStatus == .authorizedAlways
					|| authorizationStatus == .authorizedWhenInUse
			else {	fxd_log()
				fxdPrint(authorizationStatus)
				fxdPrint(mainLocationManager?.location)

				return false
			}


			return true
		}
		set { }
	}


	deinit {	fxd_log()
		NotificationCenter.default.removeObserver(self)
		mainLocationManager?.stopUpdatingLocation()
	}

	override public init() {
		super.init()

		mainLocationManager?.delegate = self
	}

	
    open func startMainLocationManager(launchOptions: [AnyHashable : Any]! = [:]) {	fxd_log()
		fxdPrint(launchOptions ?? [:])

		let authorizationStatus: CLAuthorizationStatus = (mainLocationManager?.authorizationStatus)!
		fxdPrint(String(describing: authorizationStatus))

		startMainLocationManager(for: authorizationStatus)
	}

    func startMainLocationManager(for authorizationStatus: CLAuthorizationStatus) {	fxd_log()
		fxdPrint(authorizationStatus)

		Task {
			//This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first.
			fxdPrint(CLLocationManager.locationServicesEnabled().description)
		}

        DispatchQueue.main.async {
            fxdPrint(UIDevice.current.systemVersion)
            fxdPrint(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
            fxdPrint(CLLocationManager.isRangingAvailable().description)
            fxdPrint(Bundle.main.infoDictionary?["NSLocationAlwaysAndWhenInUseUsageDescription"] ?? "")
            fxdPrint(Bundle.main.infoDictionary?["NSLocationAlwaysUsageDescription"] ?? "")
            fxdPrint(Bundle.main.infoDictionary?["NSLocationWhenInUseUsageDescription"] ?? "")
        }

		guard authorizationStatus == .authorizedAlways
				|| authorizationStatus == .authorizedWhenInUse
		else {
			mainLocationManager?.requestAlwaysAuthorization()
			return
		}


		mainLocationManager?.startUpdatingLocation()
		configureUpdatingForApplicationState()
	}

    func configureUpdatingForApplicationState() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self,
									   selector: #selector(observedUIApplicationDidBecomeActive(_:)),
									   name: UIApplication.didBecomeActiveNotification,
									   object: nil)

		notificationCenter.addObserver(self,
									   selector: #selector(observedUIApplicationDidEnterBackground(_:)),
									   name: UIApplication.didEnterBackgroundNotification,
									   object: nil)

		notificationCenter.addObserver(self,
									   selector: #selector(observedUIApplicationWillTerminate(_:)),
									   name: UIApplication.willTerminateNotification,
									   object: nil)


        DispatchQueue.main.async {	[weak self] in
            if UIApplication.shared.applicationState != .active {
                self?.minimizeUpdatingForBackgroundState()
                return
            }
        }

		maximizeUpdatingForActiveState()
	}

	open func maximizeUpdatingForActiveState() {
		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
	}

	open func minimizeUpdatingForBackgroundState() {
		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
	}

	func pauseMainLocationManager(for authorizationStatus: CLAuthorizationStatus) {
		mainLocationManager?.stopUpdatingLocation()
		mainLocationManager?.stopMonitoringSignificantLocationChanges()
	}
}

extension FXDmoduleGeo {
    @MainActor func notifySignificantChange(withNewLocation newLocation: CLLocation!) {
		monitoringTask = UIApplication.shared.beginBackgroundTask(
			expirationHandler: {
				[weak self] in

				if let monitoringTask = self?.monitoringTask {
					UIApplication.shared.endBackgroundTask(monitoringTask)
				}
				self?.monitoringTask = .invalid
			})

		persisteMonitoredLocation(newLocation: newLocation)

		fxdPrint("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")

		if let monitoringTask = monitoringTask {
			UIApplication.shared.endBackgroundTask(monitoringTask)
		}
		monitoringTask = .invalid
	}

	func persisteMonitoredLocation(newLocation: CLLocation) {
#if DEBUG
		let userDefaults = UserDefaults.standard
		if let lastTimestamp = userDefaults.object(forKey: "LastTimestampObjKey") as? Date,
			let lastLatitude = userDefaults.object(forKey: "LastLatitudeObjKey") as? Double,
			let lastLongitude = userDefaults.object(forKey: "LastLongitudeObjKey") as? Double {

			let monitoredCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lastLatitude, longitude: lastLongitude)

			let monitoredLocation = CLLocation(coordinate: monitoredCoordinate, altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, timestamp: lastTimestamp)

			let lastDistance = newLocation.distance(from: monitoredLocation)
			let lastInterval = Date.now.timeIntervalSince(monitoredLocation.timestamp)

			let alertBody: String = "MONITORED: \(lastDistance) m,  \(lastInterval) s"

			fxdPrint(alertBody)
		}

		userDefaults.setValue(newLocation.timestamp, forKey: "LastTimestampObjKey")
		userDefaults.setValue(newLocation.coordinate.latitude, forKey: "LastLatitudeObjKey")
		userDefaults.setValue(newLocation.coordinate.longitude, forKey: "LastLongitudeObjKey")


		//MARK: For future need to debug geomodule usage
		/*
		if (alertBody.length > 0) {
			UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
			localNotifcation.repeatInterval = 0;
			localNotifcation.hasAction = YES;
			localNotifcation.alertBody = (alertBody) ? alertBody:newLocation.description;
			localNotifcation.soundName = UILocalNotificationDefaultSoundName;
			localNotifcation.applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber+1);

			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];
		}
		 */
#endif
	}
}


extension FXDmoduleGeo: @preconcurrency CLLocationManagerDelegate {
    @MainActor open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	fxd_log()
		fxdPrint(String(status.rawValue))
		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			pauseMainLocationManager(for: status)
		}
		else {
			startMainLocationManager(for: status)
		}
	}

	open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {	fxd_overridable()
		/*
		if (lastLocation == nil ||
		(locations.last?.distance(from: lastLocation!))! > 10.0 as CLLocationDistance) {
		*/

		lastLocation = locations.last
		fxdPrint(lastLocation as Any)
	}

	open func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {	fxd_overridable()
		fxdPrint(error)
	}
}


extension FXDmoduleGeo: FXDobserverApplication {
	@objc public func observedUIApplicationDidEnterBackground(_ notification: NSNotification) {	fxd_overridable()
		fxdPrint(notification)
		minimizeUpdatingForBackgroundState()
	}

	@objc public func observedUIApplicationDidBecomeActive(_ notification: NSNotification) {	fxd_overridable()
		fxdPrint(notification)
		maximizeUpdatingForActiveState()
	}

	@objc public func observedUIApplicationWillTerminate(_ notification: NSNotification) {
	}

	@objc public func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification) {
	}

	@objc public func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification) {
	}

	@objc public func observedUIDeviceOrientationDidChange(_ notification: NSNotification) {
	}
}
