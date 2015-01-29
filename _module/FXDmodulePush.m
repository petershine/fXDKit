

#import "FXDmodulePush.h"


@implementation FXDmodulePush

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePushManager {	FXDLog_DEFAULT;

    UAConfig *config = [UAConfig defaultConfig];

	//NOTE: Automatic detection is not working correctly
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

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		//enabledRemoteNotificationTypes is not supported in iOS 8.0 and later.
		//registerForRemoteNotificationTypes: is not supported in iOS 8.0 and later.
	}
	else {
		[UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert);

	}
}

#pragma mark -
- (void)updateMainAlias:(NSString*)aliasString {	FXDLog_DEFAULT;
	FXDLogObject(aliasString);

	if (aliasString == nil) {
		return;
	}


	UAPush *urbanPushModule = [UAPush shared];
	FXDLogObject(urbanPushModule);

	if (urbanPushModule == nil) {
		return;
	}


	FXDLog(@"1.%@", _Object(urbanPushModule.alias));
	urbanPushModule.alias = aliasString;
	FXDLog(@"2.%@", _Object(urbanPushModule.alias));
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


#pragma mark - Observer

#pragma mark - Delegate

@end
