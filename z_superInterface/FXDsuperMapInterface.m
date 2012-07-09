//
//  FXDsuperMapInterface.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperMapInterface.h"


#pragma mark - Private interface
@interface FXDsuperMapInterface (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperMapInterface

#pragma mark Synthesizing
// Properties

// IBOutlets
@synthesize defaultMapview;


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// IBOutlets
	self.defaultMapview = nil;
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.defaultMapview setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)refreshDefaultMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate {	FXDLog_OVERRIDE;
	
}

#pragma mark -
- (void)refreshDefaultMapviewWithAnnotationArray:(NSArray*)annotationArray {	FXDLog_OVERRIDE;
	
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate
#if ForDEVELOPER
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {	//FXDLog_DEFAULT;
	
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {	//FXDLog_DEFAULT;
	
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {	//FXDLog_DEFAULT;
	
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {	//FXDLog_DEFAULT;
	
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {	FXDLog_OVERRIDE;
	if (error) {
		FXDLog_ERROR;
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	FXDLog_OVERRIDE;
	
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
	if (error) {
		FXDLog_ERROR;
	}
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
	
}
#endif


@end
