//
//  FXDmodulePush.m
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDmodulePush.h"


#pragma mark - Public implementation
@implementation FXDmodulePush


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePushManager {	FXDLog_DEFAULT;

    UAConfig *config = [UAConfig defaultConfig];

	//MARK: Automatic detection is not working correctly
#if DEBUG
	config.inProduction = NO;
#else
	config.inProduction = YES;
#endif

	config.developmentAppKey = urbanairshipDevelopmentKey;
	config.developmentAppSecret = urbanairshipDevelopmentSecret;

	config.productionAppKey = urbanairshipProductionKey;
	config.productionAppSecret = urbanairshipProductionSecret;


    [UAirship takeOff:config];

#ifdef __IPHONE_8_0
	[UAPush shared].notificationTypes = (UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert);
#else
	[UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert);
#endif

	[self updateMainAlias:nil];
}

#pragma mark -
- (void)updateMainAlias:(NSString*)aliasString {	FXDLog_DEFAULT;
	FXDLogObject(aliasString);

	if (aliasString == nil) {
		return;
	}


	UAPush *urbanPushManager = [UAPush shared];
	FXDLogObject(urbanPushManager);

	if (urbanPushManager == nil) {
		return;
	}


	FXDLog(@"1.%@", _Object(urbanPushManager.alias));
	urbanPushManager.alias = aliasString;
	FXDLog(@"2.%@", _Object(urbanPushManager.alias));
}

- (void)activateLocationReporting {	FXDLog_DEFAULT
	FXDLogBOOL([UALocationService locationServicesEnabled]);
	FXDLogBOOL([UALocationService locationServiceAuthorized]);


	[UALocationService setAirshipLocationServiceEnabled:YES];
	FXDLogBOOL([UALocationService airshipLocationServiceEnabled]);


	UALocationService *locationService = [[UAirship shared] locationService];
	locationService.standardLocationDesiredAccuracy = kCLLocationAccuracyBest;
	locationService.standardLocationDistanceFilter = kCLDistanceFilterNone;

	[locationService reportCurrentLocation];

	locationService.automaticLocationOnForegroundEnabled = YES;
	locationService.backgroundLocationServiceEnabled = YES;

	[locationService startReportingSignificantLocationChanges];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
