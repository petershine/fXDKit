//
//  FXDResponder.m
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDResponder.h"


#pragma mark - Public implementation
@implementation FXDResponder


#pragma mark - Memory management
- (void)dealloc {
    FXDLog_SEPARATE;
}


#pragma mark - Initialization
- (id)init {
	self = [super init];

	if (self) {
        FXDLog_SEPARATE;
	}

	return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;
	FXDLog(@"launchOptions: %@", launchOptions);

#if ForDEVELOPER
	if (launchOptions) {
		[FXDAlertView
		 showAlertWithTitle:strClassSelector
		 message:[launchOptions description]
		 clickedButtonAtIndexBlock:nil
		 cancelButtonTitle:nil];
	}
#endif

	return YES;
}

#pragma mark -
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	FXDLog_SEPARATE;
	FXDLog(@"deviceToken: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {	FXDLog_SEPARATE;
	FXDLog_ERROR_ALERT;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {	FXDLog_SEPARATE;
	FXDLog(@"userInfo: %@", userInfo);
	FXDLog(@"completionHandler: %@", completionHandler);

#if ForDEVELOPER
	[FXDAlertView
	 showAlertWithTitle:strClassSelector
	 message:[userInfo description]
	 clickedButtonAtIndexBlock:nil
	 cancelButtonTitle:nil];
#endif

	if (completionHandler) {
		completionHandler(UIBackgroundFetchResultNoData);
	}
}

#pragma mark -
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {	FXDLog_SEPARATE;
#if	ForDEVELOPER
	NSDictionary *parameters = @{@"sourceApplication":	(sourceApplication) ? sourceApplication:@"",
								 @"annotation":	(annotation) ? annotation:@"",
								 @"url":	([url absoluteString]) ? [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@"",
								 @"url scheme":	([url scheme]) ? [url scheme]:@"",};

	FXDLog(@"parameters: %@", parameters);

	[FXDAlertView
	 showAlertWithTitle:strClassSelector
	 message:[parameters description]
	 clickedButtonAtIndexBlock:nil
	 cancelButtonTitle:nil];
#endif

	return YES;
}

#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;

	
	//SAMPLE:
	/*
	<#APP_PREFIX#>managerGlobal *globalManager = [<#APP_PREFIX#>managerGlobal sharedInstance];
	<#APP_PREFIX#>sceneLaunch *launchScene = [globalManager.mainStoryboard instantiateViewControllerWithIdentifier:sceneidentifierLaunch];

	self.window = [FXDWindow instantiateDefaultWindow];
	[self.window prepareWithLaunchImageController:launchScene];
	[self.window makeKeyAndVisible];

	[globalManager startUsageAnalyticsWithLaunchOptions:launchOptions];


	//MARK: Need to be called before app finishes launching
	[[<#APP_PREFIX#>managerPush sharedInstance] preparePushManager];
	 */

	return YES;
}

#pragma mark -
- (void)applicationDidBecomeActive:(UIApplication *)application {	FXDLog_SEPARATE;

	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLog(@"self.isAppLaunching: %d", self.isAppLaunching);
		return;
	}


	FXDLog(@"applicationIconBadgeNumber: %d", application.applicationIconBadgeNumber);
	application.applicationIconBadgeNumber = 0;

	FXDLog(@"self.didFinishLaunching: %d", self.didFinishLaunching);


	//SAMPLE:
	/*
	POPmanagerGlobal *globalManager = [POPmanagerGlobal sharedInstance];

	if (self.didFinishLaunching == NO) {
		self.isAppLaunching = YES;

#if USE_Flurry
		NSString *launchingEvent = @"launchingEvent";
		LOGEVENT_FULL(launchingEvent, nil, YES);
#endif
		application.idleTimerDisabled = YES;


		POPcoredataMain *mainCoredata = [POPcoredataMain sharedInstance];
#if TEST_BundledSqlite
***REMOVED***
#endif

		[mainCoredata tranferFromOldSqliteFile:@"PopTooUniversal"];


		[[POPmanagerStore sharedInstance] prepareStoreManager];


		[globalManager
		 prepareGlobalManagerWithMainCoredata:mainCoredata
		 withUbiquityContainerURL:nil
		 withCompleteProtection:NO	//TEST: To avoid unexpected app crashing while in background
		 withDidFinishBlock:^(BOOL finished) {

			 POPsceneLaunch *launchScene = (POPsceneLaunch*)self.window.rootViewController;
			 [globalManager.rootContainer.view addSubview:launchScene.view];
			 [globalManager.rootContainer.view bringSubviewToFront:launchScene.view];

			 [self.window setRootViewController:globalManager.rootContainer];


			 [globalManager
			  updateAllDataWithDidFinishBlock:^(BOOL finished) {

				  POPmanagerGeolocation *geolocationManager = [POPmanagerGeolocation sharedInstance];
				  [geolocationManager startMainLocationManager];
				  [geolocationManager maximizeLocationAccuracy];

				  POPmanagerActiveItem *activeItemManager = [POPmanagerActiveItem sharedInstance];
				  [activeItemManager startObservingMediaPlayerNotifications];
				  [activeItemManager observedMPMusicPlayerControllerNowPlayingItemDidChange:nil];

				  POPsceneHome *homeScene = globalManager.mainContainer.homeScene;
				  [homeScene initializeMapview];

				  [globalManager.mainContainer prepareForFrontScenePresentation];

				  [launchScene
				   dismissLaunchControllerWithDidFinishBlock:^(BOOL finished) {
					   [globalManager updateLastUpgradedAppVersionAfterLaunch];


#if USE_appReviewManager
#if TARGET_IPHONE_SIMULATOR & ForDEVELOPER
					   [UAAppReviewManager setDebug:YES];
#endif

					   [UAAppReviewManager setUseMainAppBundleForLocalizations:YES];
					   [UAAppReviewManager setReviewTitle:NSLocalizedString(@"Please rate PopToo!", nil)];
					   [UAAppReviewManager setAppID:application_AppStoreID];
#endif

					   application.idleTimerDisabled = NO;

					   self.isAppLaunching = NO;

					   self.didFinishLaunching = YES;

					   LOGEVENT_END(launchingEvent, nil);
				   }];
			  }];
		 }];

		return;
	}


#if USE_Flurry
	NSString *becomingActiveEvent = @"becomingActiveEvent";
	LOGEVENT_FULL(becomingActiveEvent, nil, YES);
#endif

	[[FBSession activeSession] handleDidBecomeActive];

	[globalManager cancelClearingForMemory];

	[globalManager
	 updateAllDataWithDidFinishBlock:^(BOOL finished) {
		 POPmanagerGeolocation *geolocationManager = [POPmanagerGeolocation sharedInstance];
		 [geolocationManager maximizeLocationAccuracy];

		 POPsceneHome *homeScene = globalManager.mainContainer.homeScene;

		 if ([homeScene isMapviewAvailable]) {
			 [homeScene delayedTrackingUserOnMapViewAfterDelay:delayForStartUserTracking];
		 }
		 else {
			 [homeScene initializeMapview];
		 }

		 if (finished) {
			 POPmanagerOverlay *overlayManager = [POPmanagerOverlay sharedInstance];
			 [overlayManager startReloadingTaggedRenderer];
		 }


		 POPcontainerMain *mainContainer = [POPmanagerGlobal sharedInstance].mainContainer;
		 [mainContainer refreshForActiveItem];

		 __strong POPsceneHistory *_strongHistoryScene = globalManager.mainContainer.historyScene;
		 [_strongHistoryScene resumeRefreshingTimer];

		 LOGEVENT_END(becomingActiveEvent, nil);
	 }];
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application	{FXDLog_SEPARATE;
	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLog(@"self.isAppLaunching: %d", self.isAppLaunching);
		return;
	}


	//SAMPLE:
	/*
	POPmanagerGeolocation *geolocationManager = [POPmanagerGeolocation sharedInstance];
	POPmanagerActiveItem *activeItemManager = [POPmanagerActiveItem sharedInstance];

	if (activeItemManager.didStartGeotagging == NO) {
		[geolocationManager minimizeLocationAccuracy];
	}


	POPmanagerGlobal *globalManager = [POPmanagerGlobal sharedInstance];
	[globalManager.mainContainer.homeScene cancelTrackingUserOnMapView];

	__strong POPsceneHistory *_strongHistoryScene = globalManager.mainContainer.historyScene;
	[_strongHistoryScene pauseRefreshingTimer];

	[globalManager delayedClearingForMemory];
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {	FXDLog_SEPARATE;
	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLog(@"self.isAppLaunching: %d", self.isAppLaunching);
		return;
	}


	//SAMPLE:
	/*
	POPmanagerGlobal *globalManager = [POPmanagerGlobal sharedInstance];
	POPsceneHome *homeScene = globalManager.mainContainer.homeScene;
	
	if ([homeScene isMapviewAvailable] == NO) {
		[homeScene initializeMapview];
	}
	 */
}

@end
