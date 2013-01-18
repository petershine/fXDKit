//
//  FXDsuperMapController.h
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


#import "FXDsuperTableController.h"

@interface FXDsuperMapController : FXDsuperTableController <MKMapViewDelegate> {
    // Primitives
	
	// Instance variables
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDMapView *mainMapview;


#pragma mark - IBActions


#pragma mark - Public
- (void)refreshMainMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)refreshMainMapviewWithAnnotationArray:(NSArray*)annotationArray;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - MKMapViewDelegate


@end
