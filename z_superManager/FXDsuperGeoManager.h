//
//  FXDsuperGeoManager.h
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import "FXDAnnotationView.h"
#import "FXDMapView.h"

@interface FXDAnnotation : MKPointAnnotation
@property (strong, nonatomic) id addedObj;
@end


@interface FXDsuperGeoManager : FXDsuperManager <CLLocationManagerDelegate>

@property (nonatomic) BOOL initializedForAppLaunching;
@property (nonatomic) BOOL didStartSignificantMonitoring;

@property (nonatomic) UIBackgroundTaskIdentifier monitoringTask;
@property (nonatomic) UIBackgroundTaskIdentifier locationUpdatingTask;

@property (strong, nonatomic) CLLocationManager *mainLocationManager;

@property (strong, nonatomic) CLLocation *lastLocation;


#pragma mark - Initialization

#pragma mark - Public
- (void)startMainLocationManager;
- (void)pauseMainLocationManager;

- (void)configureUpdatingForApplicationState;
- (void)maximizeUpdatingForActiveState;
- (void)minimizeUpdatingForBackgroundState;

- (BOOL)isDistantEnoughFromLastLocation;

#warning //MARK: For testing significantMonitoring
- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation;
- (void)testWithGooglePlaceApiWithNewLocation:(CLLocation*)newLocation;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
