

import CoreLocation
import MapKit


class FXDmoduleGeo: NSObject {

	var didStartLocationManager: Bool? = false
	
	var mainLocationManager: CLLocationManager?
    var lastLocation: CLLocation?


	deinit {	fxd_log()
		stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	fxd_log()
		fxdPrint(CLLocationManager.locationServicesEnabled().description)
		fxdPrint(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		fxdPrint(CLLocationManager.isRangingAvailable().description)

		guard CLLocationManager.locationServicesEnabled() != false else {
			return
		}


		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self
		mainLocationManager?.distanceFilter = 100

		mainLocationManager?.pausesLocationUpdatesAutomatically = false
		/*
		*      With UIBackgroundModes set to include "location" in Info.plist, you must
		*      also set this property to YES at runtime whenever calling
		*      -startUpdatingLocation with the intent to continue in the background.
		*
		*      Setting this property to YES when UIBackgroundModes does not include
		*      "location" is a fatal error.
		*/
		mainLocationManager?.allowsBackgroundLocationUpdates = true


		var authorizationStatus: CLAuthorizationStatus
		if #available(iOS 14.0, *) {
			authorizationStatus = (mainLocationManager?.authorizationStatus)!
		} else {
			authorizationStatus = CLLocationManager.authorizationStatus()
		}
		fxdPrint(String(describing: authorizationStatus))

		if (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse) {
			startLocationManager(mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationAlwaysUsageDescription, NSLocationWhenInUseUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	func startLocationManager(_ manager: CLLocationManager?) {	fxd_log()

		guard manager != nil else {
			return
		}
		

		fxdPrint(didStartLocationManager as Any)

		guard didStartLocationManager != true else {
			return
		}


		didStartLocationManager = true


		manager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.shared.applicationState == .background) {
			manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidBecomeActive(_:)),
		                                       name: UIApplication.didBecomeActiveNotification,
		                                       object: nil)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidEnterBackground(_:)),
		                                       name: UIApplication.didEnterBackgroundNotification,
		                                       object: nil)
	}

	func stopLocationManager(_ manager: CLLocationManager?) {	fxd_log()

		NotificationCenter.default.removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}

	func updatePlacemarks() {	fxd_log()

		guard mainLocationManager?.location != nil else {
			return
		}


		let geocoder: CLGeocoder = CLGeocoder()

		geocoder.reverseGeocodeLocation((mainLocationManager?.location)!) {
			(placemarks, error) in

			fxdPrint(error as Any)
			fxdPrint(placemarks as Any)
		}
	}
}

extension FXDmoduleGeo: FXDprotocolObserver {

	func observedUIApplicationDidEnterBackground(_ notification: NSNotification) {	fxd_log()
		fxdPrint(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		fxdPrint(mainLocationManager?.desiredAccuracy as Any)
	}

	func observedUIApplicationDidBecomeActive(_ notification: NSNotification) {	fxd_log()
		fxdPrint(notification)
		
		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		fxdPrint(mainLocationManager?.desiredAccuracy as Any)
	}

	func observedUIApplicationWillTerminate(_ notification: NSNotification) {

	}

	func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification) {

	}

	func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification) {

	}

	func observedUIDeviceOrientationDidChange(_ notification: NSNotification) {

	}
}

extension FXDmoduleGeo: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	fxd_log()

		fxdPrint(String(status.rawValue))


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			startLocationManager(manager)
		}
		else {
			stopLocationManager(manager)
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		/*
		if (lastLocation == nil ||
		(locations.last?.distance(from: lastLocation!))! > 10.0 as CLLocationDistance) {
		*/

		lastLocation = locations.last
		fxdPrint(lastLocation as Any)
	}
}
