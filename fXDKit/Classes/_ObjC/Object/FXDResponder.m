

#import "FXDResponder.h"


@implementation FXDResponder

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public

#pragma mark - Observer

#pragma mark - Delegate
//MARK: UIApplicationDelegate

//MARK: For the app with any remote (even including local) notification, override following implementation
/*
 e.g. Request snippet
	UIUserNotificationType notificationTypes = (UIUserNotificationTypeNone|UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert);
	UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
	[[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	FXDLog_SEPARATE;
	FXDLogObject(deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {	FXDLog_SEPARATE;
	FXDLog_ERROR;
}

//MARK: Be careful with the case for older version, which cannot fetch.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {	FXDLog_SEPARATE;
	FXDLogObject(userInfo);
	FXDLogObject(completionHandler);

	if (completionHandler) {
		completionHandler(UIBackgroundFetchResultNoData);
	}
}
 */

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

	FXDLog_OVERRIDE;
	
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


@implementation UIResponder (Added)
- (void)executeOperationsForApplication:(UIApplication*)application withLaunchOption:(NSDictionary*)launchOptions {	FXDLog_DEFAULT;
	FXDLogObject(launchOptions);

	if (launchOptions[UIApplicationLaunchOptionsURLKey]
		|| launchOptions[UIApplicationLaunchOptionsSourceApplicationKey]
		|| launchOptions[UIApplicationLaunchOptionsAnnotationKey]) {

		NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
		NSString *sourceApplication = launchOptions[UIApplicationLaunchOptionsSourceApplicationKey];
		id annotation = launchOptions[UIApplicationLaunchOptionsAnnotationKey];
		
		NSDictionary *openOptions = @{UIApplicationOpenURLOptionsSourceApplicationKey:sourceApplication,
									  UIApplicationOpenURLOptionsAnnotationKey:annotation};

		[self application:application openURL:url options:openOptions];
	}

	//MARK: UIKIT_EXTERN UIApplicationLaunchOptionsKey const UIApplicationLaunchOptionsLocalNotificationKey     NS_DEPRECATED_IOS(4_0, 10_0, "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]") __TVOS_PROHIBITED; // userInfo contains a UILocalNotification

	//MARK: - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_DEPRECATED_IOS(3_0, 10_0, "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications");
}

- (BOOL)isUsableLaunchOption:(NSDictionary*)launchOptions {	FXDLog_DEFAULT;

	if (launchOptions[UIApplicationLaunchOptionsURLKey]
		|| launchOptions[UIApplicationLaunchOptionsSourceApplicationKey]
		|| launchOptions[UIApplicationLaunchOptionsAnnotationKey]) {

		return YES;
	}

	//MARK: UIKIT_EXTERN UIApplicationLaunchOptionsKey const UIApplicationLaunchOptionsLocalNotificationKey     NS_DEPRECATED_IOS(4_0, 10_0, "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]") __TVOS_PROHIBITED; // userInfo contains a UILocalNotification

	if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
		return YES;
	}

	if (launchOptions) {
		FXDLogObject(launchOptions);
		return YES;
	}


	return NO;
}

@end