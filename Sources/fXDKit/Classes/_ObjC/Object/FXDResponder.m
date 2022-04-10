

#import "FXDResponder.h"


@implementation FXDResponder

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0) {	FXDLog_SEPARATE;
	FXDLogObject(deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0) {	FXDLog_SEPARATE;
	FXDLog_ERROR;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0) {	FXDLog_SEPARATE;
	FXDLogObject(userInfo);
	FXDLogObject(completionHandler);

	if (completionHandler != nil) {
		completionHandler(UIBackgroundFetchResultNewData);
	}
}

#pragma mark -
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {	FXDLog_SEPARATE;
	FXDLogObject(url);
	FXDLogObject(app);
	FXDLogObject(options);

	return YES;
}

#pragma mark -
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;
	FXDLogObject(launchOptions);

	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	FXDLog_SEPARATE;
	FXDLogObject(launchOptions);;
	
	return YES;
}

#pragma mark -
- (void)applicationDidBecomeActive:(UIApplication *)application {	FXDLog_SEPARATE;
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}


	FXDLogBOOL(self.didFinishLaunching);
}

- (void)applicationWillResignActive:(UIApplication *)application {	FXDLog_SEPARATE;
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application	{FXDLog_SEPARATE;
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application {	FXDLog_SEPARATE;
	if (self.isAppLaunching) {
		FXDLogBOOL(self.isAppLaunching);
		return;
	}
}

@end

