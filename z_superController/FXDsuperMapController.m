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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// Instance variables
}

- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - Autorotating


#pragma mark - View Loading & Appearing
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.mainMapview setDelegate:self];
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


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)refreshDefaultMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate {	FXDLog_OVERRIDE;
	
}

- (void)refreshDefaultMapviewWithAnnotationArray:(NSArray*)annotationArray {	FXDLog_OVERRIDE;
	
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {	//FXDLog_DEFAULT;
	
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {	//FXDLog_DEFAULT;
	
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {	FXDLog_DEFAULT;
	
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {	FXDLog_OVERRIDE;
	FXDLog_ERROR;
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
	FXDLog(@"mode: %d animated: %d", mode, animated);
	
	
}


@end