

#import "FXDmoduleGeo.h"


@implementation FXDmoduleGeo

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (CLLocationManager*)mainLocationManager {
	if (_mainLocationManager == nil) {
		_mainLocationManager = [[CLLocationManager alloc] init];
		_mainLocationManager.activityType = CLActivityTypeOther;
		_mainLocationManager.distanceFilter = kCLDistanceFilterNone;

		_mainLocationManager.pausesLocationUpdatesAutomatically = NO;
		/*
		 *      With UIBackgroundModes set to include "location" in Info.plist, you must
		 *      also set this property to YES at runtime whenever calling
		 *      -startUpdatingLocation with the intent to continue in the background.
		 *
		 *      Setting this property to YES when UIBackgroundModes does not include
		 *      "location" is a fatal error.
		 */
		_mainLocationManager.allowsBackgroundLocationUpdates = YES;

		_mainLocationManager.delegate = self;
	}
	return _mainLocationManager;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startMainLocationManagerWithLaunchOptions:(NSDictionary*)launchOptions {	FXDLog_DEFAULT;
	FXDLogObject(launchOptions[UIApplicationLaunchOptionsLocationKey]);

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

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillTerminate:)
	 name:UIApplicationWillTerminateNotification
	 object:nil];

	[self startMainLocationManagerForAuthorizationStatus:[CLLocationManager authorizationStatus]];
}

- (void)startMainLocationManagerForAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {	FXDLog_DEFAULT;
	FXDLogVariable([CLLocationManager authorizationStatus]);
	FXDLogBOOL([CLLocationManager locationServicesEnabled]);
	FXDLogBOOL([CLLocationManager deferredLocationUpdatesAvailable]);

	FXDLogVariable(authorizationStatus);
	FXDLogBOOL(authorizationStatus == [CLLocationManager authorizationStatus]);

	FXDLogObject([UIDevice currentDevice].systemVersion);
	FXDLogObject([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"]);
	FXDLogObject([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"]);


	BOOL isAuthorized = YES;

	if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways
		&& authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
		isAuthorized = NO;
	}

	FXDLogBOOL(isAuthorized);

	if (isAuthorized == NO) {

		if ([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"]) {
			[self.mainLocationManager requestWhenInUseAuthorization];
		}
		else {
			[self.mainLocationManager requestAlwaysAuthorization];
		}

		return;
	}


	[self.mainLocationManager startUpdatingLocation];
	[self configureUpdatingForApplicationState];
}

#pragma mark -
- (void)configureUpdatingForApplicationState {	//FXDLog_DEFAULT;
	//FXDLogVariable([UIApplication sharedApplication].applicationState);
	
	if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
		[self minimizeUpdatingForBackgroundState];
		return;
	}

	[self maximizeUpdatingForActiveState];
}

- (void)maximizeUpdatingForActiveState {	//FXDLog_DEFAULT;
	_mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	//FXDLogVariable(_mainLocationManager.desiredAccuracy);

	[_mainLocationManager disallowDeferredLocationUpdates];
}

- (void)minimizeUpdatingForBackgroundState {	//FXDLog_DEFAULT;
	_mainLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	//FXDLogVariable(_mainLocationManager.desiredAccuracy);

	//MARK: Learn how to use deferred location updates
	FXDLogBOOL([CLLocationManager deferredLocationUpdatesAvailable]);
	if ([CLLocationManager deferredLocationUpdatesAvailable]) {
		[_mainLocationManager
		 allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax
		 timeout:CLTimeIntervalMax];
	}
}

- (void)pauseMainLocationManagerForAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {	//FXDLog_DEFAULT;
	//FXDLogVariable(authorizationStatus);

	[_mainLocationManager stopUpdatingLocation];
	[_mainLocationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark -
- (BOOL)isDistantEnoughFromLastLocation {

	if (self.lastLocation == nil) {
		self.lastLocation = _mainLocationManager.location;
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
		CLLocationCoordinate2D monitoredCoordinate = CLLocationCoordinate2DMake(lastLatitude.doubleValue, lastLongitude.doubleValue);

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


	//MARK: For future need to debug geomodule usage
	/*
	if (alertBody.length > 0) {
		UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
		localNotifcation.repeatInterval = 0;
		localNotifcation.hasAction = YES;
		localNotifcation.alertBody = (alertBody) ? alertBody:newLocation.description;
		localNotifcation.soundName = UILocalNotificationDefaultSoundName;
		localNotifcation.applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber+1);

		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];
	}
	 */


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
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_OVERRIDE;
}

#pragma mark - Delegate
//NOTE: CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {	FXDLog_DEFAULT;
	FXDLogVariable(authorizationStatus);

	BOOL isAuthorized = YES;

	if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways
		&& authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
		isAuthorized = NO;
	}

	if (isAuthorized == NO) {
		[self pauseMainLocationManagerForAuthorizationStatus:authorizationStatus];
		return;
	}


	[self startMainLocationManagerForAuthorizationStatus:authorizationStatus];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {	FXDLog_OVERRIDE;
}

- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(nullable NSError *)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;
}

@end


@implementation FXDmoduleTile

- (void)prepareTileModule {

	CGRect tileCGRect = [self tileCGRectForMinimumDimension:dimensionMinimumTile];
	MKMapRect tileMapRect = [self tileMapRectForMinimumDiagonalDistance:distanceDiagonalSatelliteMinimum];

	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(MKStringFromMapRect(tileMapRect)), _Rect(tileCGRect));

	CLLocationDistance diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
																   MKMapPointMake(tileMapRect.size.width,
																				  tileMapRect.size.height));
	FXDLogVariable(diagonalDistance);
	if (diagonalDistance) {}

	self.tileMapRect = tileMapRect;


	NSInteger multiplier = [UIScreen mainScreen].bounds.size.width/tileCGRect.size.width;
	FXDLogVariable(multiplier);

	Float64 aspectRatio = [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
	FXDLogVariable(aspectRatio);

	self.screenMapRect = MKMapRectMake(0,
									   0,
									   tileMapRect.size.width*multiplier,
									   tileMapRect.size.width*multiplier*aspectRatio);

	FXDLogObject(MKStringFromMapRect(self.screenMapRect));
}

#pragma mark -
- (CGRect)tileCGRectForMinimumDimension:(CGFloat)minimumDimension {	FXDLog_DEFAULT;
	Float64 dividedBy = 1.0;

	CGRect tileCGRect = [UIScreen mainScreen].bounds;
	FXDLog(@"%f: %@", dividedBy, _Rect(tileCGRect));

	do {
		dividedBy += 1.0;

		if ((NSUInteger)[UIScreen mainScreen].bounds.size.width % (NSUInteger)dividedBy != 0) {
			continue;
		}


		tileCGRect = [UIScreen mainScreen].bounds;
		tileCGRect.size.width /= dividedBy;
		tileCGRect.size.height /= dividedBy;

		FXDLog(@"%lu: %@", (unsigned long)dividedBy, _Rect(tileCGRect));

	} while (tileCGRect.size.width > minimumDimension && dividedBy < 100.0);

	return tileCGRect;
}

- (MKMapRect)tileMapRectForMinimumDiagonalDistance:(CLLocationDistance)minimumDiagonalDistance {	FXDLog_DEFAULT;
	Float64 dividedBy = 1.0;

	MKMapRect tileMapRect = MKMapRectWorld;

	CLLocationDistance diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
																   MKMapPointMake(tileMapRect.size.width,
																				  tileMapRect.size.height));

	FXDLog(@"%lux%lu: %@ %@", (unsigned long)dividedBy, (unsigned long)dividedBy, MKStringFromMapSize(tileMapRect.size), _Variable(diagonalDistance));

	do {
		dividedBy += 1.0;

		if ((NSUInteger)MKMapRectWorld.size.width % (NSUInteger)dividedBy != 0) {
			continue;
		}


		tileMapRect = MKMapRectWorld;
		tileMapRect.size.width /= dividedBy;
		tileMapRect.size.height /= dividedBy;

		diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
													MKMapPointMake(tileMapRect.size.width,
																   tileMapRect.size.height));

		FXDLog(@"%lux%lu = %lu: %@ %@", (unsigned long)dividedBy, (unsigned long)dividedBy, (unsigned long)(dividedBy*dividedBy), MKStringFromMapSize(tileMapRect.size), _Variable(diagonalDistance));

	} while ((NSUInteger)diagonalDistance > minimumDiagonalDistance);

	return tileMapRect;
}
@end
