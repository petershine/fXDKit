//
//  FXDsuperMapInterface.h
//  PopTooUniversal
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperTableInterface.h"

#import <MapKit/MapKit.h>


@interface FXDsuperMapInterface : FXDsuperTableInterface <MKMapViewDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDMapView *defaultMapview;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - at loadView

#pragma mark - at autoRotate

#pragma mark - at viewDidLoad


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)refreshDefaultMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)refreshDefaultMapviewWithAnnotationArray:(NSArray*)annotationArray;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate


@end
