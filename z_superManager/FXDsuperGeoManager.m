//
//  FXDsuperGeoManager.m
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperGeoManager.h"


@implementation FXDAnnotation
@end


#pragma mark - Public implementation
@implementation FXDsuperGeoManager


#pragma mark - Memory management
- (void)dealloc {
	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self];
}

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(observedUIApplicationDidEnterBackground:)
		 name:UIApplicationDidEnterBackgroundNotification
		 object:nil];

		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(observedUIApplicationDidBecomeActive:)
		 name:UIApplicationDidBecomeActiveNotification
		 object:nil];
	}

	return self;
}

#pragma mark - Property overriding
- (CLLocationManager*)mainLocationManager {

	if (_mainLocationManager == nil) {	FXDLog_DEFAULT;
		_mainLocationManager = [CLLocationManager new];
		_mainLocationManager.activityType = CLActivityTypeOther;
		_mainLocationManager.distanceFilter = kCLDistanceFilterNone;
		
		_mainLocationManager.pausesLocationUpdatesAutomatically = NO;

		[_mainLocationManager setDelegate:self];

		FXDLogObject(_mainLocationManager);
	}

	return _mainLocationManager;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startMainLocationManager {	FXDLog_DEFAULT;
	FXDLogVariable([CLLocationManager authorizationStatus]);

	BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
	FXDLogBOOL(servicesEnabled);

	if (servicesEnabled == NO) {
		//TODO: alert user reminding location service is required"
	}


	FXDLogBOOL([CLLocationManager deferredLocationUpdatesAvailable]);

	[self.mainLocationManager startUpdatingLocation];
}

- (void)pauseMainLocationManager {	FXDLog_DEFAULT;
	[_mainLocationManager stopUpdatingLocation];
}

#pragma mark -
- (void)maximizeLocationAccuracy {
	self.mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	FXDLog(@"%@ %@", _Object(NSStringFromSelector(_cmd)), _Variable(self.mainLocationManager.desiredAccuracy));
}

- (void)minimizeLocationAccuracy {
#if	ForDEVELOPER
	UIDevice *currentDevice = [UIDevice currentDevice];
	FXDLog(@"%@ %@", _Variable(currentDevice.batteryState), _Variable(currentDevice.batteryLevel));
	;
#endif

	self.mainLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	FXDLog(@"1.%@", _Variable(self.mainLocationManager.desiredAccuracy));

	self.mainLocationManager.desiredAccuracy = (kCLLocationAccuracyThreeKilometers*2.0);
	FXDLog(@"2.%@", _Variable(self.mainLocationManager.desiredAccuracy));
}

#pragma mark -
- (BOOL)isDistantEnoughFromLastLocation {

	if (self.lastLocation == nil) {
		self.lastLocation = self.mainLocationManager.location;
		return YES;
	}

#warning //TODO: Overridden by subclass

	return NO;
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_OVERRIDE;
}

- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification {	FXDLog_OVERRIDE;
}


//MARK: - Delegate implementation
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

	if (self.initializedForAppLaunching) {	FXDLog_DEFAULT;
		FXDLogBOOL(self.initializedForAppLaunching);
		FXDLog_REMAINING;

		LOGEVENT(@"SignificantLocationChanges: %@", [locations description]);

		//MARK: Let subclass to change boolean
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {	FXDLog_DEFAULT;
	FXDLogVariable(status);

#if	USE_Flurry
	NSDictionary *parameters = @{@"authorizationStatus": @(status)};
	LOGEVENT_FULL(@"didChangeAuthorizationStatus", parameters, NO);
#endif
}

@end
