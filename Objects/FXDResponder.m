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

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;
	FXDLogObject(launchOptions);

	FXDLogObject([[UIDevice currentDevice].identifierForVendor UUIDString]);

	return YES;
}

#pragma mark -
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	FXDLog_SEPARATE;
	FXDLogObject(deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {	FXDLog_SEPARATE;
	FXDLog_ERROR;
	FXDLog_ERROR_ALERT;
}

//MARK: Be careful with the case for older version, which cannot fetch.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {	FXDLog_SEPARATE;
	FXDLogObject(userInfo);
	FXDLogObject(completionHandler);

	[FXDAlertView
	 showAlertWithTitle:nil
	 message:userInfo[@"aps"][@"alert"]
	 cancelButtonTitle:nil
	 withAlertCallback:nil];


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

	FXDLogObject(parameters);

	[FXDAlertView
	 showAlertWithTitle:_ClassSelectorSelf
	 message:[parameters description]
	 cancelButtonTitle:nil
	 withAlertCallback:nil];
#endif

	return YES;
}

#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;

	return YES;
}

#pragma mark -
- (void)applicationDidBecomeActive:(UIApplication *)application {	FXDLog_SEPARATE;

	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}


	FXDLogVariable(application.applicationIconBadgeNumber);
	application.applicationIconBadgeNumber = 0;

	FXDLogBOOL(self.didFinishLaunching);
}

- (void)applicationWillResignActive:(UIApplication *)application {	FXDLog_SEPARATE;

}

- (void)applicationDidEnterBackground:(UIApplication *)application	{FXDLog_SEPARATE;

	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}


}

- (void)applicationWillEnterForeground:(UIApplication *)application {	FXDLog_SEPARATE;

	//MARK: To prevent app being affected when state is being changed during launching
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}


}

@end
