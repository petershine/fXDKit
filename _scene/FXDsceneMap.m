

#import "FXDsceneMap.h"

#import "FXDMapView.h"


@implementation FXDsceneMap

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (void)refreshMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate {	FXDLog_OVERRIDE;
}

- (void)refreshMapviewWithAnnotationArray:(NSArray*)annotationArray {	FXDLog_OVERRIDE;
}

#pragma mark -
- (void)resumeTrackingUser {
	if (self.initialTrackingMode != MKUserTrackingModeNone) {	FXDLog_DEFAULT;
		[self.mainMapview setUserTrackingMode:self.initialTrackingMode animated:YES];
	}
}

#pragma mark - Observer

#pragma mark - Delegate
//NOTE: MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	
	if (self.shouldResumeTracking) {	//NOTE: Keep canceling until scrolling is stopped
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	
	if (self.shouldResumeTracking) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
		[self performSelector:@selector(resumeTrackingUser) withObject:nil afterDelay:delayOneSecond inModes:@[NSRunLoopCommonModes]];
	}
}

@end
