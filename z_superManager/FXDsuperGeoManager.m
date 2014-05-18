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

#pragma mark -
- (void)notifySignificantChangeWithNewLocation:(CLLocation*)newLocation {

	self.monitoringTask =
	[[UIApplication sharedApplication]
	 beginBackgroundTaskWithExpirationHandler:^{

		 [[UIApplication sharedApplication] endBackgroundTask:self.monitoringTask];
		 self.monitoringTask = UIBackgroundTaskInvalid;
	 }];


	NSString *alertBody = nil;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSDate *lastTimestamp = [userDefaults objectForKey:@"LastTimestampObjKey"];
	NSNumber *lastLatitude = [userDefaults objectForKey:@"LastLatitudeObjKey"];
	NSNumber *lastLongitude = [userDefaults objectForKey:@"LastLongitudeObjKey"];

	if (lastTimestamp && lastLatitude && lastLongitude) {
		CLLocation *lastMonitoredLocation = [[CLLocation alloc]
											 initWithCoordinate:CLLocationCoordinate2DMake([lastLatitude doubleValue], [lastLongitude doubleValue])
											 altitude:0.0
											 horizontalAccuracy:0.0
											 verticalAccuracy:0.0
											 timestamp:lastTimestamp];

		CLLocationDistance lastDistance = [newLocation distanceFromLocation:lastMonitoredLocation];
		NSTimeInterval lastInterval = [[NSDate date] timeIntervalSinceDate:lastMonitoredLocation.timestamp];

		alertBody = [NSString stringWithFormat:@"TEST: MONITORED: %d m, %d s", (NSInteger)lastDistance, (NSInteger)lastInterval];
	}


	[userDefaults setObject:newLocation.timestamp forKey:@"LastTimestampObjKey"];
	[userDefaults setObject:@(newLocation.coordinate.latitude) forKey:@"LastLatitudeObjKey"];
	[userDefaults setObject:@(newLocation.coordinate.longitude) forKey:@"LastLongitudeObjKey"];
	[userDefaults synchronize];

	FXDLogObject(alertBody);
	LOGEVENT(@"%@", _Object(alertBody));


	if ([alertBody length] > 0) {
		UILocalNotification *localNotifcation = [UILocalNotification new];
		localNotifcation.repeatInterval = 0;
		localNotifcation.hasAction = YES;
		localNotifcation.alertBody = (alertBody) ? alertBody:[newLocation description];
		localNotifcation.soundName = UILocalNotificationDefaultSoundName;
		localNotifcation.applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber+1);
		LOGEVENT(@"%@", _Variable(localNotifcation.applicationIconBadgeNumber));

		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];
	}


	FXDLog_REMAINING;

	[[UIApplication sharedApplication] endBackgroundTask:self.monitoringTask];
	self.monitoringTask = UIBackgroundTaskInvalid;
}

- (void)testWithGooglePlaceApiWithNewLocation:(CLLocation*)newLocation {

	self.monitoringTask =
	[[UIApplication sharedApplication]
	 beginBackgroundTaskWithExpirationHandler:^{

		 [[UIApplication sharedApplication] endBackgroundTask:self.monitoringTask];
		 self.monitoringTask = UIBackgroundTaskInvalid;
	 }];


	void (^NotifyingLocationUpdating)(id, NSError*) = ^(NSDictionary *responseObject, NSError *error){
		FXDLog_ERROR;

		NSMutableArray *unsortedPlaceArray = [[NSMutableArray alloc] initWithCapacity:0];

		for (NSDictionary *placeResult in responseObject[@"results"]) {
			CLLocation *placeLocation =
			[[CLLocation alloc]
			 initWithLatitude:[placeResult[@"geometry"][@"location"][@"lat"] doubleValue]
			 longitude:[placeResult[@"geometry"][@"location"][@"lng"] doubleValue]];

			CLLocationDistance placeDistance = [newLocation distanceFromLocation:placeLocation];

			[unsortedPlaceArray addObject:@{@"name":	placeResult[@"name"],
											@"distance": @(placeDistance)}];
		}


		NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
		NSArray *sortedPlaceArray = [unsortedPlaceArray sortedArrayUsingDescriptors:sortDescriptors];


		NSString *alertBody = nil;

		if ([sortedPlaceArray count] > 0) {
			NSDictionary *nearestPlaceDictionary = [sortedPlaceArray firstObject];
			alertBody = [NSString stringWithFormat:@"TEST: %@: %@", nearestPlaceDictionary[@"name"], nearestPlaceDictionary[@"distance"]];
			FXDLogObject(alertBody);
		}


		FXDLogObject(alertBody);
		LOGEVENT(@"%@", _Object(alertBody));


		UILocalNotification *localNotifcation = [UILocalNotification new];
		localNotifcation.repeatInterval = 0;
		localNotifcation.hasAction = YES;
		localNotifcation.alertBody = (alertBody) ? alertBody:[newLocation description];
		localNotifcation.soundName = UILocalNotificationDefaultSoundName;

		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];


		FXDLog_REMAINING;

		[[UIApplication sharedApplication] endBackgroundTask:self.monitoringTask];
		self.monitoringTask = UIBackgroundTaskInvalid;
	};


	static NSString * const apiFormat = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=1000&sensor=true&key=***REMOVED***";


	NSString *requestURLstring = [NSString stringWithFormat:apiFormat, @(newLocation.coordinate.latitude), @(newLocation.coordinate.longitude)];
	FXDLogObject(requestURLstring);


	NSURL *requestURL = [NSURL URLWithString:requestURLstring];
	NSURLRequest *apiRequest = [NSURLRequest requestWithURL:requestURL];


	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:apiRequest];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];

	[operation
	 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NotifyingLocationUpdating(responseObject, nil);

	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 NotifyingLocationUpdating(nil, error);
	 }];
	
	[operation start];
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
