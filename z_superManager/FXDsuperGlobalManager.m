//
//  FXDsuperGlobalManager.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDsuperGlobalManager.h"

#import "FXDsuperCoreDataManager.h"


#pragma mark - Public implementation
@implementation FXDsuperGlobalManager


#pragma mark - Memory management

#pragma mark - Initialization
+ (FXDsuperGlobalManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (NSInteger)appLaunchCount {
	_appLaunchCount = [[NSUserDefaults standardUserDefaults] integerForKey:userdefaultIntegerAppLaunchCount];
	
	return _appLaunchCount;
}

#pragma mark -
- (BOOL)didMakePurchase {	//FXDLog_DEFAULT;
	_didMakePurchase = [[NSUserDefaults standardUserDefaults] boolForKey:userdefaultBoolDidMakePurchase];

	return _didMakePurchase;
}

- (void)setDidMakePurchase:(BOOL)didMake {	FXDLog_DEFAULT;
	_didMakePurchase = didMake;

	[[NSUserDefaults standardUserDefaults] setBool:_didMakePurchase forKey:userdefaultBoolDidMakePurchase];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
- (BOOL)didShareToSocialNet {	//FXDLog_DEFAULT;
	_didShareToSocialNet = [[NSUserDefaults standardUserDefaults] boolForKey:userdefaultBoolDidShareToSocialNet];

	return _didShareToSocialNet;
}

- (void)setDidShareToSocialNet:(BOOL)didShare {	FXDLog_DEFAULT;
	_didShareToSocialNet = didShare;

	[[NSUserDefaults standardUserDefaults] setBool:_didShareToSocialNet forKey:userdefaultBoolDidShareToSocialNet];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
- (FXDStoryboard*)mainStoryboard {
	if (_mainStoryboard == nil) {
		if (self.mainStoryboardName) {
			_mainStoryboard = (FXDStoryboard*)[FXDStoryboard storyboardWithName:self.mainStoryboardName bundle:nil];
		}
#if ForDEVELOPER
		else {
			FXDLog_OVERRIDE;
		}
#endif
	}
	
	return _mainStoryboard;
}

- (NSString*)mainStoryboardName {
	if (_mainStoryboardName == nil) {	FXDLog_OVERRIDE;
		FXDLog(@"mainBundlelocalizedInfoDictionary:\n%@", [[NSBundle mainBundle] localizedInfoDictionary]);
	}

	return _mainStoryboardName;
}

#pragma mark -
- (NSString*)deviceLanguageCode {
	if (_deviceLanguageCode == nil) {	FXDLog_DEFAULT;
		NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
		
		_deviceLanguageCode = languages[0];
		
		if ([_deviceLanguageCode isEqualToString:@"zh-Hans"]) {
			_deviceLanguageCode = @"ch";
		}
		else if ([_deviceLanguageCode isEqualToString:@"zh-Hant"]) {
			_deviceLanguageCode = @"tw";
		}
		
		FXDLog(@"1._deviceLanguageCode: %@ languages:\n%@", _deviceLanguageCode, languages);
		
		//MARK: limit supported languages
		if ([_deviceLanguageCode isEqualToString:@"en"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ko"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ja"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ch"] == NO
			&& [_deviceLanguageCode isEqualToString:@"tw"] == NO) {
			_deviceLanguageCode = @"en";
		}
		FXDLog(@"2._deviceLanguageCode: %@ languages:\n%@", _deviceLanguageCode, languages);
	}
	
	FXDLog(@"_deviceLanguageCode: %@", _deviceLanguageCode);

	return _deviceLanguageCode;
}

- (NSString*)deviceCountryCode {
	if (_deviceCountryCode == nil) {	FXDLog_DEFAULT;
		NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
		
		NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
		
		_deviceCountryCode = components[1];
		
		FXDLog(@"_deviceCountryCode: %@", _deviceCountryCode);
	}
	
	return _deviceCountryCode;
}

- (NSString*)deviceModelName {
	if (_deviceModelName == nil) {	FXDLog_DEFAULT;
		
		struct utsname systemInfo;
		uname(&systemInfo);
		
		NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
		
		NSDictionary *commonNamesDictionary =
		@{@"i386":		@"iPhone Simulator",
		  @"x86_64":	@"iPad Simulator",

		  @"iPhone1,1":	@"iPhone",
		  @"iPhone1,2":	@"iPhone 3G",
		  @"iPhone2,1":	@"iPhone 3GS",
		  @"iPhone3,1":	@"iPhone 4",
		  @"iPhone4,1":	@"iPhone 4S",
		  @"iPhone5,1":	@"iPhone 5(GSM)",
		  @"iPhone5,2":	@"iPhone 5(GSM+CDMA)",

		  @"iPad1,1":	@"iPad",
		  @"iPad2,1":	@"iPad 2(WiFi)",
		  @"iPad2,2":	@"iPad 2(GSM)",
		  @"iPad2,3":	@"iPad 2(CDMA)",
		  @"iPad2,4":	@"iPad 2(WiFi Rev A)",
		  @"iPad2,5":	@"iPad Mini(WiFi)",
		  @"iPad2,6":	@"iPad Mini(GSM)",
		  @"iPad2,7":	@"iPad Mini(GSM+CDMA)",
		  @"iPad3,1":	@"iPad 3(WiFi)",
		  @"iPad3,2":	@"iPad 3(GSM+CDMA)",
		  @"iPad3,3":	@"iPad 3(GSM)",
		  @"iPad3,4":	@"iPad 4(WiFi)",
		  @"iPad3,5":	@"iPad 4(GSM)",
		  @"iPad3,6":	@"iPad 4(GSM+CDMA)",

		  @"iPod1,1":	@"iPod 1st Gen",
		  @"iPod2,1":	@"iPod 2nd Gen",
		  @"iPod3,1":	@"iPod 3rd Gen",
		  @"iPod4,1": 	@"iPod 4th Gen",
		  @"iPod5,1":	@"iPod 5th Gen",
		  };

		_deviceModelName = commonNamesDictionary[machineName];

		if (_deviceModelName == nil) {
			_deviceModelName = machineName;
		}

		FXDLog(@"_deviceModelName: %@", _deviceModelName);
	}

	return _deviceModelName;
}

#pragma mark -
- (NSDateFormatter*)dateformatterUTC {
	
	if (_dateformatterUTC == nil) {	FXDLog_DEFAULT;
		_dateformatterUTC = [[NSDateFormatter alloc] init];
		
		NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
		[_dateformatterUTC setTimeZone:UTCtimezone];
		[_dateformatterUTC setDateFormat:dateformatDefault];
		
		FXDLog(@"_dateformatterUTC: %@", _dateformatterUTC);
	}
	
	return _dateformatterUTC;
}

- (NSDateFormatter*)dateformatterLocal {
	
	if (_dateformatterLocal == nil) {	FXDLog_DEFAULT;
		_dateformatterLocal = [[NSDateFormatter alloc] init];
		
		NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
		[_dateformatterLocal setTimeZone:localTimeZone];
		[_dateformatterLocal setDateFormat:dateformatDefault];
				
		FXDLog(@"_dateformatterLocal: %@", _dateformatterLocal);
	}
	
	return _dateformatterLocal;
}

#pragma mark -
- (id)rootController {
	if (_rootController == nil) {	FXDLog_DEFAULT;
		if (self.mainStoryboard) {
			_rootController = [self.mainStoryboard instantiateInitialViewController];
		}
		
		FXDLog(@"_rootController: %@", _rootController);
	}

	return _rootController;
}

- (id)homeController {
	if (_homeController) {
		return _homeController;
	}
	
	
	FXDLog_DEFAULT;
	
	NSArray *addedControllers = nil;
	
	if ([self.rootController respondsToSelector:@selector(viewControllers)]) {
		addedControllers = [self.rootController performSelector:@selector(viewControllers)];
	}
	else if ([self.rootController respondsToSelector:@selector(childViewControllers)]) {
		addedControllers = [self.rootController performSelector:@selector(childViewControllers)];
	}
	
	FXDLog(@"addedControllers count: %lu", (unsigned long)[addedControllers count]);
	
	if ([addedControllers count] == 0) {
		_homeController = self.rootController;
		FXDLog(@"_homeController = self.rootController: %@", _homeController);
		
		return _homeController;
	}
	
	
	if ([self.rootController isKindOfClass:[UITabBarController class]] == NO) {
		_homeController = addedControllers[0];
		FXDLog(@"_homeController = addedControllers[0]: %@", _homeController);
		
		return _homeController;
	}
	
	
	id subContainerController = addedControllers[0];
	
	if ([subContainerController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = (UINavigationController*)subContainerController;
		
		if ([navigationController.viewControllers count] > 0) {
			_homeController = (navigationController.viewControllers)[0];
			
			FXDLog(@"_homeController = (containedNavigationController.viewControllers)[0]: %@", _homeController);
		}
	}
	else {
		_homeController = subContainerController;
		
		FXDLog(@"_homeController = subContainerController: %@", _homeController);
	}
	
	return _homeController;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGlobalManagerAtLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock {	//FXDLog_OVERRIDE;
	[self prepareGlobalManagerWithCoreDataManager:nil withUbiquityContainerURL:nil withCompleteProtection:NO  atLaunchWithWindowLoadingBlock:windowLoadingBlock];
}

- (void)prepareGlobalManagerWithCoreDataManager:(FXDsuperCoreDataManager*)coreDataManager withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection atLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock {	FXDLog_DEFAULT;
	
	//MARK: UUID can be changed is the device is recovered from backup or sent backup to iCloud
#if ForDEVELOPER
	FXDLog(@"identifierForVendor UUIDString: %@", [[UIDevice currentDevice].identifierForVendor UUIDString]);
#endif
	
	void (^ManagerDidPrepareBlock)(void) = ^(void){
		[self configureUserDefaultsInfo];
		[self startObservingEssentialNotifications];
		
		if (windowLoadingBlock) {
			windowLoadingBlock();
		}
	};
	
	
	if (coreDataManager == nil) {
		ManagerDidPrepareBlock();
		
		return;
	}
	
	
	[coreDataManager
	 prepareCoreDataManagerWithUbiquityContainerURL:ubiquityContainerURL
	 withCompleteProtection:withCompleteProtection
	 didFinishBlock:^(BOOL finished) {
		 FXDLog(@"prepareCoreDataManagerWithUbiquityContainerURL finished: %d", finished);
		 
		 ManagerDidPrepareBlock();
	 }];
}

#pragma mark -
- (void)configureUserDefaultsInfo {	FXDLog_OVERRIDE;
	
}

- (void)startObservingEssentialNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	//UIApplicationStatusBar:
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillChangeStatusBarFrame:)
	 name:UIApplicationWillChangeStatusBarFrameNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidChangeStatusBarFrame:)
	 name:UIApplicationDidChangeStatusBarFrameNotification
	 object:nil];

	//UIApplicationState:
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillResignActive:)
	 name:UIApplicationWillResignActiveNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillEnterForeground:)
	 name:UIApplicationWillEnterForegroundNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidBecomeActive:)
	 name:UIApplicationDidBecomeActiveNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidReceiveMemoryWarning:)
	 name:UIApplicationDidReceiveMemoryWarningNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillTerminate:)
	 name:UIApplicationWillTerminateNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationSignificantTimeChange:)
	 name:UIApplicationSignificantTimeChangeNotification
	 object:nil];
	
	//NSUserDefaults:
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSUserDefaultsDidChange:)
	 name:NSUserDefaultsDidChangeNotification
	 object:nil];
	
	//UIDeviceBattery:
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIDeviceBatteryStateDidChange:)
	 name:UIDeviceBatteryStateDidChangeNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIDeviceBatteryLevelDidChange:)
	 name:UIDeviceBatteryLevelDidChangeNotification
	 object:nil];
}

#pragma mark -
- (void)incrementAppLaunchCount {	FXDLog_DEFAULT;
	FXDLog(@"1.appLaunchCount: %ld", (long)self.appLaunchCount);
	
	_appLaunchCount++;
	[[NSUserDefaults standardUserDefaults] setInteger:_appLaunchCount forKey:userdefaultIntegerAppLaunchCount];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	FXDLog(@"2.appLaunchCount: %ld", (long)self.appLaunchCount);
}

#pragma mark -
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay {
	if (alertBody == nil) {
		return;
	}
	
	
	UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
	localNotifcation.repeatInterval = 0;
	localNotifcation.alertBody = alertBody;
	
	if (delay > 0.0) {
		localNotifcation.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
		
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotifcation];
	}
	else {
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotifcation];
	}
}

#pragma mark -
- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [NSDate date];
	}
	
    NSString *UTCdateString = [self.dateformatterUTC stringFromDate:localDate];
	
    return UTCdateString;
}

- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate {
	
	NSString *UTCdateString = [self UTCdateStringForLocalDate:localDate];
	
	NSDate *UTCdate = [self.dateformatterUTC dateFromString:UTCdateString];
	
	return UTCdate;
}

- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate {
	
	NSString *localDateString = [self.dateformatterLocal stringFromDate:UTCdate];
	
	return localDateString;
}

- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate {
	NSString *localDateString = [self localDateStringForUTCdate:UTCdate];
	
	NSDate *localDate = [self.dateformatterLocal dateFromString:localDateString];
	
	return localDate;
}


//MARK: - Observer implementation
- (void)observedUIApplicationWillChangeStatusBarFrame:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"UIApplication sharedApplication].statusBarFrame: %@", NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
	FXDLog(@"notification: %@", [notification userInfo][UIApplicationStatusBarFrameUserInfoKey]);
}

- (void)observedUIApplicationDidChangeStatusBarFrame:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedUIApplicationWillResignActive:(NSNotification*)notification {
}
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {
}
- (void)observedUIApplicationWillEnterForeground:(NSNotification*)notification {
}
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification {
}
- (void)observedUIApplicationDidReceiveMemoryWarning:(NSNotification*)notification {
}
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {
}
- (void)observedUIApplicationSignificantTimeChange:(NSNotification*)notification {
}

#pragma mark -
- (void)observedNSUserDefaultsDidChange:(NSNotification *)notification {
}

#pragma mark -
- (void)observedUIDeviceBatteryStateDidChange:(NSNotification*)notification {
}
- (void)observedUIDeviceBatteryLevelDidChange:(NSNotification*)notification {
}

//MARK: - Delegate implementation


@end
