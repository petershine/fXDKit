//
//  FXDsuperGeoManager.h
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@import CoreLocation;
@import MapKit;


@interface FXDsuperGeoManager : FXDsuperModule <CLLocationManagerDelegate>

@property (nonatomic) BOOL didStartSignificantMonitoring;

@property (nonatomic) UIBackgroundTaskIdentifier monitoringTask;
@property (nonatomic) UIBackgroundTaskIdentifier locationUpdatingTask;

@property (strong, nonatomic) CLLocationManager *mainLocationManager;

@property (strong, nonatomic) CLLocation *lastLocation;


#pragma mark - Initialization

#pragma mark - Public
- (void)startMainLocationManagerWithLaunchOptions:(NSDictionary*)launchOptions;
- (void)pauseMainLocationManager;

- (void)configureUpdatingForApplicationState;
- (void)maximizeUpdatingForActiveState;
- (void)minimizeUpdatingForBackgroundState;

- (BOOL)isDistantEnoughFromLastLocation;

//MARK: For testing significantMonitoring
- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
