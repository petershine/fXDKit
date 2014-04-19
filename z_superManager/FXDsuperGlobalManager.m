//
//  FXDsuperGlobalManager.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDsuperGlobalManager.h"


#pragma mark - Public implementation
@implementation FXDsuperGlobalManager


#pragma mark - Memory management

#pragma mark - Initialization
+ (instancetype)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (NSInteger)appLaunchCount {
	_appLaunchCount = [[NSUserDefaults standardUserDefaults] integerForKey:userdefaultIntegerAppLaunchCount];
	
	return _appLaunchCount;
}

- (BOOL)isDeviceOld {
	//MARK: Test using oldDeviceArray
	if (_oldDeviceArray == nil) {

		//MARK: Update as new devices are introduced and it's harder to support old devices
		_oldDeviceArray = @[@"iPhone 4",
							@"iPhone 4S"];

		if ([_oldDeviceArray containsObject:self.deviceModelName]) {
			_isDeviceOld = YES;
		}
		else {
			_isDeviceOld = NO;
		}

		FXDLog_DEFAULT;
		FXDLogObject(_oldDeviceArray);
		FXDLogBOOL(_isDeviceOld);
	}

	return _isDeviceOld;
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
	if (_mainStoryboardName == nil) {
		FXDLog_OVERRIDE;
	}

	return _mainStoryboardName;
}

#pragma mark -
- (NSString*)deviceLanguageCode {
	if (_deviceLanguageCode == nil) {	FXDLog_DEFAULT;
		NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
		
		_deviceLanguageCode = [languages firstObject];
		
		if ([_deviceLanguageCode isEqualToString:@"zh-Hans"]) {
			_deviceLanguageCode = @"ch";
		}
		else if ([_deviceLanguageCode isEqualToString:@"zh-Hant"]) {
			_deviceLanguageCode = @"tw";
		}
		
		FXDLog(@"1.%@ %@", _Object(_deviceLanguageCode), _Object(languages));
		
		//MARK: limit supported languages
		if ([_deviceLanguageCode isEqualToString:@"en"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ko"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ja"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ch"] == NO
			&& [_deviceLanguageCode isEqualToString:@"tw"] == NO) {
			_deviceLanguageCode = @"en";
		}
		FXDLog(@"2.%@ %@", _Object(_deviceLanguageCode), _Object(languages));
	}

	return _deviceLanguageCode;
}

- (NSString*)deviceCountryCode {
	if (_deviceCountryCode == nil) {	FXDLog_DEFAULT;
		NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
		
		NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
		
		_deviceCountryCode = components[1];
		
		FXDLogObject(_deviceCountryCode);
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
		  @"iPhone5,3":	@"iPhone 5c(GSM)",
		  @"iPhone5,4":	@"iPhone 5c(GSM+CDMA)",
		  @"iPhone6,1":	@"iPhone 5s(GSM)",
		  @"iPhone6,2":	@"iPhone 5s(GSM+CDMA)",

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

		FXDLog(@"%@ %@", _Object(_deviceModelName), _Object(machineName));
	}

	return _deviceModelName;
}

#pragma mark -
- (NSDateFormatter*)dateformatterUTC {
	
	if (_dateformatterUTC == nil) {	FXDLog_DEFAULT;
		_dateformatterUTC = [NSDateFormatter new];
		
		NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
		[_dateformatterUTC setTimeZone:UTCtimezone];
		[_dateformatterUTC setDateFormat:dateformatDefault];
		
		FXDLogObject(_dateformatterUTC);
	}
	
	return _dateformatterUTC;
}

- (NSDateFormatter*)dateformatterLocal {
	
	if (_dateformatterLocal == nil) {	FXDLog_DEFAULT;
		_dateformatterLocal = [NSDateFormatter new];
		
		NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
		[_dateformatterLocal setTimeZone:localTimeZone];
		[_dateformatterLocal setDateFormat:dateformatDefault];
				
		FXDLogObject(_dateformatterLocal);
	}
	
	return _dateformatterLocal;
}

#pragma mark -
- (id)rootController {
	if (_rootController == nil) {
		if (self.mainStoryboard) {
			_rootController = [self.mainStoryboard instantiateInitialViewController];
		}

		FXDLog_DEFAULT;
		FXDLogObject(_rootController);
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
	
	FXDLogVariable([addedControllers count]);
	
	if ([addedControllers count] == 0) {
		_homeController = self.rootController;
		FXDLogObject(self.rootController);
		
		return _homeController;
	}
	
	
	if ([self.rootController isKindOfClass:[UITabBarController class]] == NO) {
		_homeController = [addedControllers firstObject];
		FXDLogObject([addedControllers firstObject]);
		
		return _homeController;
	}
	
	
	id subContainerController = [addedControllers firstObject];
	
	if ([subContainerController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = (UINavigationController*)subContainerController;
		
		if ([navigationController.viewControllers count] > 0) {
			_homeController = [(navigationController.viewControllers) firstObject];
			FXDLogObject([(navigationController.viewControllers) firstObject]);
		}
	}
	else {
		_homeController = subContainerController;
		FXDLogObject(subContainerController);
	}
	
	return _homeController;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGlobalManagerAtLaunchWithFinishCallback:(FXDcallbackFinish)finishCallback {
	[self
	 prepareGlobalManagerWithMainCoredata:nil
	 withUbiquityContainerURL:nil
	 withCompleteProtection:NO
	 withFinishCallback:finishCallback];
}

- (void)prepareGlobalManagerWithMainCoredata:(FXDsuperMainCoredata*)mainCoredata withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	void (^ManagerDidPrepareBlock)(void) = ^(void){	FXDLog_SEPARATE;
		FXDLogObject([[NSBundle mainBundle] infoDictionary]);

		FXDLogObject(NSUserName());
		FXDLogObject(NSFullUserName());

		FXDLogObject(NSHomeDirectory());
		FXDLogObject(NSTemporaryDirectory());

		FXDLogObject(NSOpenStepRootDirectory());


		[self incrementAppLaunchCount];
		
		[self configureUserDefaultsInfo];
		[self configureGlobalAppearance];

		[self startObservingEssentialNotifications];
		
		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
	};
	
	
	if (mainCoredata == nil) {
		ManagerDidPrepareBlock();
		
		return;
	}
	
	
	[mainCoredata
	 prepareWithUbiquityContainerURL:ubiquityContainerURL
	 withCompleteProtection:withCompleteProtection
	 finishCallback:^(SEL caller, BOOL finished, id responseObj) {
		 FXDLog_BLOCK(mainCoredata, caller);
		 
		 ManagerDidPrepareBlock();
	 }];
}

#pragma mark -
- (void)incrementAppLaunchCount {	FXDLog_DEFAULT;

	NSInteger modifiedCount = self.appLaunchCount;
	FXDLog(@"1.%@", _Variable(modifiedCount));

	_appLaunchCount = modifiedCount+1;
	FXDLog(@"2.%@", _Variable(_appLaunchCount));
	
	[[NSUserDefaults standardUserDefaults] setInteger:_appLaunchCount forKey:userdefaultIntegerAppLaunchCount];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
- (void)configureUserDefaultsInfo {	FXDLog_DEFAULT;
}

- (void)configureGlobalAppearance {	FXDLog_DEFAULT;
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

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions {	FXDLog_DEFAULT;
#if USE_Flurry
	#if ForDEVELOPER
	[Flurry setShowErrorInLogEnabled:[@(USE_FlurryWithLogging) boolValue]];
	[Flurry setDebugLogEnabled:[@(USE_FlurryWithLogging) boolValue]];
	#endif

	[Flurry setSecureTransportEnabled:YES];
	[Flurry setCrashReportingEnabled:YES];

	[Flurry setBackgroundSessionEnabled:YES];

	[Flurry startSession:flurryApplicationKey withOptions:launchOptions];
#endif

#if USE_Appsee
	[Appsee start:appseeAPIkey];
#endif

#if USE_TestFlight
	[TestFlight takeOff:testflightAppToken];
#endif
}

#pragma mark -
- (BOOL)shouldUpgradeForNewAppVersion {
	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	NSInteger versionInteger = [[version stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
	FXDLogVariable(versionInteger);

	BOOL shouldUpgrade = [self isLastVersionOlderThanVersionInteger:versionInteger];
	FXDLogBOOL(shouldUpgrade);

	return shouldUpgrade;
}

- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger {
	BOOL isOlder = NO;

	id lastVersionObj = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultIntegerLastUpgradedAppVersion];
	FXDLog(@"%@ < %@", _Variable([lastVersionObj integerValue]), _Variable(versionInteger));

	if ([lastVersionObj integerValue] < versionInteger) {
		isOlder = YES;
	}
	FXDLogBOOL(isOlder);

	return isOlder;
}

- (void)updateLastUpgradedAppVersionAfterLaunch {	FXDLog_DEFAULT;
	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	NSInteger versionInteger = [[version stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];

	[[NSUserDefaults standardUserDefaults] setInteger:versionInteger forKey:userdefaultIntegerLastUpgradedAppVersion];
	[[NSUserDefaults standardUserDefaults] synchronize];
	FXDLog(@"SAVED: %@", _Variable(versionInteger));
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
- (void)observedUIApplicationWillChangeStatusBarFrame:(NSNotification*)notification {

	if ([UIApplication sharedApplication].statusBarHidden == NO) {	FXDLog_DEFAULT;
		FXDLogRect([UIApplication sharedApplication].statusBarFrame);
		FXDLogObject([notification userInfo][UIApplicationStatusBarFrameUserInfoKey]);
	}
}

- (void)observedUIApplicationDidChangeStatusBarFrame:(NSNotification*)notification {

	if ([UIApplication sharedApplication].statusBarHidden == NO) {	FXDLog_DEFAULT;
		FXDLogRect([UIApplication sharedApplication].statusBarFrame);
		FXDLogObject([notification userInfo][UIApplicationStatusBarFrameUserInfoKey]);
	}
}

#pragma mark -
//MARK: Override to implement accordingly
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
