//
//  FXDsuperGeoManager.h
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDsuperGeoManager : FXDsuperManager <CLLocationManagerDelegate>

@property (nonatomic) BOOL initializedForAppLaunching;

@property (strong, nonatomic) CLLocationManager *mainLocationManager;

@property (strong, nonatomic) CLLocation *lastLocation;


#pragma mark - Initialization

#pragma mark - Public
- (void)startMainLocationManager;

- (void)maximizeLocationAccuracy;
- (void)minimizeLocationAccuracy;

- (BOOL)isDistantEnoughFromLastLocation;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end