

import CoreLocation
import MapKit


class FXDmoduleGeo: NSObject {

	var didStartLocationManager: Bool? = false
	
	var mainLocationManager: CLLocationManager?
    var lastLocation: CLLocation?


	deinit {	fxdFuncPrint()
		stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	fxdFuncPrint()
		fxdPrint(CLLocationManager.locationServicesEnabled().description)
		fxdPrint(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		fxdPrint(CLLocationManager.isRangingAvailable().description)
		fxdPrint(CLLocationManager.deferredLocationUpdatesAvailable().description)

		guard CLLocationManager.locationServicesEnabled() != false else {
			return
		}


		self.mainLocationManager = CLLocationManager()
		self.mainLocationManager?.delegate = self
		self.mainLocationManager?.distanceFilter = 100

		self.mainLocationManager?.pausesLocationUpdatesAutomatically = false
		/*
		*      With UIBackgroundModes set to include "location" in Info.plist, you must
		*      also set this property to YES at runtime whenever calling
		*      -startUpdatingLocation with the intent to continue in the background.
		*
		*      Setting this property to YES when UIBackgroundModes does not include
		*      "location" is a fatal error.
		*/
		self.mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		fxdPrint(String(status.rawValue))

		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(self.mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationAlwaysUsageDescription, NSLocationWhenInUseUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			self.mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	func startLocationManager(_ manager: CLLocationManager?) {	fxdFuncPrint()

		guard manager != nil else {
			return
		}
		

		fxdPrint(self.didStartLocationManager as Any)

		guard self.didStartLocationManager != true else {
			return
		}


		self.didStartLocationManager = true


		manager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.shared.applicationState == .background) {
			manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidBecomeActive(_:)),
		                                       name: NSNotification.Name.UIApplicationDidBecomeActive,
		                                       object: nil)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidEnterBackground(_:)),
		                                       name: NSNotification.Name.UIApplicationDidEnterBackground,
		                                       object: nil)
	}

	func stopLocationManager(_ manager: CLLocationManager?) {	fxdFuncPrint()

		NotificationCenter.default.removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}

	func updatePlacemarks() {	fxdFuncPrint()

		guard self.mainLocationManager?.location != nil else {
			return
		}


		let geocoder: CLGeocoder = CLGeocoder()

		geocoder.reverseGeocodeLocation((self.mainLocationManager?.location)!) {
			(placemarks, error) in

			fxdPrint(error as Any)
			fxdPrint(placemarks as Any)
		}
	}
}

extension FXDmoduleGeo: FXDprotocolObserver {

	func observedUIApplicationDidEnterBackground(_ notification: NSNotification) {	fxdFuncPrint()
		fxdPrint(notification)

		self.mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		fxdPrint(self.mainLocationManager?.desiredAccuracy as Any)
	}

	func observedUIApplicationDidBecomeActive(_ notification: NSNotification) {	fxdFuncPrint()
		fxdPrint(notification)
		
		self.mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		fxdPrint(self.mainLocationManager?.desiredAccuracy as Any)
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
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	fxdFuncPrint()

		fxdPrint(String(status.rawValue))


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		/*
		if (self.lastLocation == nil ||
		(locations.last?.distance(from: self.lastLocation!))! > 10.0 as CLLocationDistance) {
		*/

		self.lastLocation = locations.last
		fxdPrint(self.lastLocation as Any)
	}
}
