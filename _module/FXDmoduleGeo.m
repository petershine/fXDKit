

#import "FXDmoduleGeo.h"


@implementation FXDmoduleGeo

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (CLLocationManager*)mainLocationManager {
	if (_mainLocationManager) {
		return _mainLocationManager;
	}


	FXDLog_DEFAULT;

	_mainLocationManager = [[CLLocationManager alloc] init];
	_mainLocationManager.activityType = CLActivityTypeOther;
	_mainLocationManager.distanceFilter = kCLDistanceFilterNone;

	_mainLocationManager.pausesLocationUpdatesAutomatically = NO;

	_mainLocationManager.delegate = self;

	FXDLogObject(_mainLocationManager);

	return _mainLocationManager;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startMainLocationManagerWithLaunchOptions:(NSDictionary*)launchOptions {	FXDLog_DEFAULT;
	FXDLogObject(launchOptions[UIApplicationLaunchOptionsLocationKey]);

	FXDLogVariable([CLLocationManager authorizationStatus]);
	FXDLogBOOL([CLLocationManager locationServicesEnabled]);
	FXDLogBOOL([CLLocationManager deferredLocationUpdatesAvailable]);

	CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
	BOOL isAuthorized = YES;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		#ifdef __IPHONE_8_0
		if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways
			&& authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
			isAuthorized = NO;
		}
		#endif
	}
	else {
		if (authorizationStatus != kCLAuthorizationStatusAuthorized) {
			isAuthorized = NO;
		}
	}


	FXDLogBOOL(isAuthorized);
	FXDLogObject([UIDevice currentDevice].systemVersion);
	FXDLogObject([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"]);
	
#if	ForDEVELOPER
	NSAssert([[NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"] length] > 0, nil);
#endif

	if (isAuthorized == NO) {
		if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
			#if __IPHONE_8_0
			[self.mainLocationManager requestAlwaysAuthorization];
			#endif
			return;
		}
	}


	[self.mainLocationManager startUpdatingLocation];

	[self configureUpdatingForApplicationState];


	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidBecomeActive:)
	 name:UIApplicationDidBecomeActiveNotification
	 object:nil];
}

- (void)pauseMainLocationManager {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_mainLocationManager stopUpdatingLocation];
	[_mainLocationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark -
- (void)configureUpdatingForApplicationState {	FXDLog_DEFAULT;
	FXDLogVariable([UIApplication sharedApplication].applicationState);
	
	if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
		[self minimizeUpdatingForBackgroundState];
		return;
	}

	[self maximizeUpdatingForActiveState];
}

- (void)maximizeUpdatingForActiveState {	FXDLog_DEFAULT;
	self.mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	FXDLog(@"%@ %@", _Object(NSStringFromSelector(_cmd)), _Variable(self.mainLocationManager.desiredAccuracy));
}

- (void)minimizeUpdatingForBackgroundState {	FXDLog_DEFAULT;
	self.mainLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	FXDLog(@"%@ %@", _Object(NSStringFromSelector(_cmd)), _Variable(self.mainLocationManager.desiredAccuracy));
}

#pragma mark -
- (BOOL)isDistantEnoughFromLastLocation {

	if (self.lastLocation == nil) {
		self.lastLocation = self.mainLocationManager.location;
		return YES;
	}

	//TODO: Overridden by subclass

	return NO;
}

#pragma mark -
- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation {

	self.monitoringTask =
	[[UIApplication sharedApplication]
	 beginBackgroundTaskWithExpirationHandler:^{

		 [[UIApplication sharedApplication]
		  endBackgroundTask:self.monitoringTask];

		 self.monitoringTask = UIBackgroundTaskInvalid;
	 }];


	NSString *alertBody = nil;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSDate *lastTimestamp = [userDefaults objectForKey:@"LastTimestampObjKey"];
	NSNumber *lastLatitude = [userDefaults objectForKey:@"LastLatitudeObjKey"];
	NSNumber *lastLongitude = [userDefaults objectForKey:@"LastLongitudeObjKey"];

	if (lastTimestamp && lastLatitude && lastLongitude) {
		CLLocationCoordinate2D monitoredCoordinate = CLLocationCoordinate2DMake([lastLatitude doubleValue], [lastLongitude doubleValue]);

		CLLocation *monitoredLocation = [[CLLocation alloc]
										 initWithCoordinate:monitoredCoordinate
										 altitude:0.0
										 horizontalAccuracy:0.0
										 verticalAccuracy:0.0
										 timestamp:lastTimestamp];

		CLLocationDistance lastDistance = [newLocation distanceFromLocation:monitoredLocation];
		NSTimeInterval lastInterval = [[NSDate date] timeIntervalSinceDate:monitoredLocation.timestamp];

		alertBody = [NSString stringWithFormat:@"MONITORED: %ld m, %ld s",
					 (long)lastDistance,
					 (long)lastInterval];
	}


	[userDefaults setObject:newLocation.timestamp forKey:@"LastTimestampObjKey"];
	[userDefaults setObject:@(newLocation.coordinate.latitude) forKey:@"LastLatitudeObjKey"];
	[userDefaults setObject:@(newLocation.coordinate.longitude) forKey:@"LastLongitudeObjKey"];
	[userDefaults synchronize];

	FXDLogObject(alertBody);


	if ([alertBody length] > 0) {
		UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
		localNotifcation.repeatInterval = 0;
		localNotifcation.hasAction = YES;
		localNotifcation.alertBody = (alertBody) ? alertBody:[newLocation description];
		localNotifcation.soundName = UILocalNotificationDefaultSoundName;
		localNotifcation.applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber+1);

		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];
	}


	FXDLog_REMAINING;

	[[UIApplication sharedApplication]
	 endBackgroundTask:self.monitoringTask];

	self.monitoringTask = UIBackgroundTaskInvalid;
}


#pragma mark - Observer
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_OVERRIDE;
}
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification {	FXDLog_OVERRIDE;
}

#pragma mark - Delegate
//MARK: CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {	FXDLog_DEFAULT;
	FXDLogVariable(authorizationStatus);

	BOOL isAuthorized = YES;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		#ifdef __IPHONE_8_0
		if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways
			&& authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
			isAuthorized = NO;
		}
		#endif
	}
	else {
		if (authorizationStatus != kCLAuthorizationStatusAuthorized) {
			isAuthorized = NO;
		}
	}


	if (isAuthorized == NO) {
		[self pauseMainLocationManager];
		return;
	}


	[self startMainLocationManagerWithLaunchOptions:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {	FXDLog_OVERRIDE;
}

@end
