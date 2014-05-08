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

#pragma mark - Initialization

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

	
	FXDLogBOOL([CLLocationManager significantLocationChangeMonitoringAvailable]);
	FXDLogBOOL([CLLocationManager deferredLocationUpdatesAvailable]);

	[self.mainLocationManager startMonitoringSignificantLocationChanges];
	[self.mainLocationManager startUpdatingLocation];
}

- (void)pauseMainLocationManager {	FXDLog_DEFAULT;
	[_mainLocationManager stopMonitoringSignificantLocationChanges];
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


	return NO;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

	if (self.initializedForAppLaunching) {
		FXDLogBOOL(self.initializedForAppLaunching);
		FXDLog_REMAINING;

		LOGEVENT(@"SignificantLocationChanges: %@", [locations description]);

		//MARK: Let subclass to change boolean

#if ForDEVELOPER
		[[UIApplication sharedApplication]
		 localNotificationWithAlertBody:[locations lastObject]
		 afterDelay:0.0];
#endif
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
