//
//  FXDsuperMapScene.h
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


#import "FXDsuperTableScene.h"

@interface FXDsuperMapScene : FXDsuperTableScene <MKMapViewDelegate> {
	FXDMapView *_mainMapview;
}

// Properties
@property (nonatomic) MKUserTrackingMode initialTrackingMode;
@property (nonatomic) BOOL shouldResumeTracking;

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDMapView *mainMapview;


#pragma mark - IBActions

#pragma mark - Public
- (void)refreshMapviewWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)refreshMapviewWithAnnotationArray:(NSArray*)annotationArray;

- (void)resumeTrackingUser;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
