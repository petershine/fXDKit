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
- (void)dealloc {	FXDLog_SEPARATE;
	FXDAssert_IsMainThread;
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {	FXDLog_SEPARATE;
		FXDAssert_IsMainThread;
	}

	return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	FXDLog_DEFAULT;
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;
	FXDLogObject(launchOptions);

#if ForDEVELOPER
	if (launchOptions) {
		[FXDAlertView
		 showAlertWithTitle:_ClassSelectorSelf
		 message:[launchOptions description]
		 cancelButtonTitle:nil
		 withAlertCallback:nil];
	}


	FXDLogObject([[NSBundle mainBundle] infoDictionary]);

	FXDLogObject([[UIDevice currentDevice].identifierForVendor UUIDString]);

#if	USE_AdvertisementFrameworks
	FXDLogObject([[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]);
#endif

	FXDLogObject(NSUserName());
	FXDLogObject(NSFullUserName());

	FXDLogObject(NSHomeDirectory());
	FXDLogObject(NSTemporaryDirectory());

	FXDLogObject(NSOpenStepRootDirectory());
#endif

	return YES;
}

#pragma mark -
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	FXDLog_SEPARATE;

#if ForDEVELOPER
	NSString *deviceTokenString = [deviceToken description];
	deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
	deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
	deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];

	FXDLogObject(deviceTokenString);
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {	FXDLog_SEPARATE;
	FXDLog_ERROR;
	FXDLog_ERROR_ALERT;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {	FXDLog_SEPARATE;
	FXDLogObject(userInfo);
	FXDLogObject(completionHandler);

#if ForDEVELOPER
	[FXDAlertView
	 showAlertWithTitle:_ClassSelectorSelf
	 message:[userInfo description]
	 cancelButtonTitle:nil
	 withAlertCallback:nil];
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
