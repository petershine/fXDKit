//
//  FXDsuperMapController.m
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperMapController.h"


#pragma mark - Public implementation
@implementation FXDsuperMapController


#pragma mark - Memory management
- (void)dealloc {
    //TODO: Remove observer, Deallocate timer, Nilify delegates, etc
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	//TODO: Initialize BEFORE LOADING View
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.mainMapview.delegate == nil) {
		[self.mainMapview setDelegate:self];
	}
	
	[self resumeTrackingUser];
}


#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public
- (void)refreshMainMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate {
	FXDLog_OVERRIDE;
}

- (void)refreshMainMapviewWithAnnotationArray:(NSArray*)annotationArray {
	FXDLog_OVERRIDE;
}

#pragma mark -
- (void)resumeTrackingUser {	FXDLog_DEFAULT;
	if (self.initialTrackingMode != MKUserTrackingModeNone) {
		[self.mainMapview setUserTrackingMode:self.initialTrackingMode animated:YES];
	}
}

//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {	//FXDLog_DEFAULT;
	
	if (self.shouldResumeTracking) {	//MARK: Keep canceling until scrolling is stopped
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	if (self.shouldResumeTracking) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeTrackingUser) object:nil];
		[self performSelector:@selector(resumeTrackingUser) withObject:nil afterDelay:delayOneSecond inModes:@[NSRunLoopCommonModes]];
	}
}

#warning "//MARK: Make following is properly implemented by subclasses"
/*
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {	//FXDLog_DEFAULT;
	
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {	FXDLog_DEFAULT;
	
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {	FXDLog_OVERRIDE;
	FXDLog_ERROR;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {	FXDLog_OVERRIDE;
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {	FXDLog_OVERRIDE;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {	FXDLog_OVERRIDE;
	
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {	FXDLog_OVERRIDE;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {	FXDLog_OVERRIDE;
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {	FXDLog_OVERRIDE;
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {	FXDLog_OVERRIDE;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {	//FXDLog_OVERRIDE;
	
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {	FXDLog_OVERRIDE;
	FXDLog_ERROR;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState {	FXDLog_OVERRIDE;
	
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {	FXDLog_OVERRIDE;
	return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews {	FXDLog_OVERRIDE;
	
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {	FXDLog_OVERRIDE;
	FXDLog(@"mode: %d animated: %d self.initialTrackingMode: %d self.shouldResumeTracking: %d", mode, animated, self.initialTrackingMode, self.shouldResumeTracking);
}
 */


@end
