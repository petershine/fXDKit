

open class FXDsceneMap: FXDsceneTable {
	open var initialTrackingMode: MKUserTrackingMode = MKUserTrackingMode.none
	open var shouldResumeTracking: Bool = false

	@IBOutlet open var mainMapview: FXDMapView?


	open func refreshMapview(coordinate: CLLocationCoordinate2D) {
		fxd_overridable()
	}

	open func refreshMapview(annotationArray: NSArray) {
		fxd_overridable()
	}

	@objc func resumeTrackingUser() {
		if initialTrackingMode != .none {	fxd_log_func()
			mainMapview?.setUserTrackingMode(initialTrackingMode, animated: true)
		}
	}
}


extension FXDsceneMap: MKMapViewDelegate {
	open func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
		if shouldResumeTracking {
			//MARK: Keep canceling until scrolling is stopped
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTrackingUser), object: nil)
		}
	}

	open func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		if shouldResumeTracking {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTrackingUser), object: nil)
			perform(#selector(resumeTrackingUser), with: nil, afterDelay: DURATION_ONE_SECOND, inModes: [RunLoopMode.commonModes])
		}
	}
}
