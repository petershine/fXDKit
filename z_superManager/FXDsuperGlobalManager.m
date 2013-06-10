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
- (void)dealloc {	FXDLog_SEPARATE;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization
+ (FXDsuperGlobalManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
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
- (NSString*)mainStoryboardName {
	if (_mainStoryboardName == nil) {	FXDLog_OVERRIDE;
		FXDLog(@"mainBundlelocalizedInfoDictionary:\n%@", [[NSBundle mainBundle] localizedInfoDictionary]);
	}

	return _mainStoryboardName;
}

- (FXDStoryboard*)mainStoryboard {
	if (_mainStoryboard == nil) {
		if (self.mainStoryboardName) {
			_mainStoryboard = (FXDStoryboard*)[FXDStoryboard storyboardWithName:self.mainStoryboardName bundle:nil];
		}
		else {
			FXDLog_OVERRIDE;
		}
	}

	return _mainStoryboard;
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
	if (_deviceModelName) {
		return _deviceModelName;
	}
	
	
	FXDLog_DEFAULT;
	
	struct utsname systemInfo;
	uname(&systemInfo);
	
	_deviceModelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	
	if([_deviceModelName isEqualToString:@"i386"]) {
		_deviceModelName = @"iPhone Simulator";
	}
    else if([_deviceModelName isEqualToString:@"iPhone1,1"]) {
		_deviceModelName = @"iPhone";
	}
	else if([_deviceModelName isEqualToString:@"iPhone1,2"]) {
		_deviceModelName = @"iPhone 3G";
	}
	else if([_deviceModelName isEqualToString:@"iPhone2,1"]) {
		_deviceModelName = @"iPhone 3GS";
	}
	else if([_deviceModelName isEqualToString:@"iPhone3,1"]) {
		_deviceModelName = @"iPhone 4";
	}
	else if([_deviceModelName isEqualToString:@"iPhone4,1"]) {
		_deviceModelName = @"iPhone 4S";
	}
	else if([_deviceModelName isEqualToString:@"iPhone5,1"]) {
		_deviceModelName = @"iPhone 5";
	}
	
	else if([_deviceModelName isEqualToString:@"iPod1,1"]) {
		_deviceModelName = @"iPod 1st Gen";
	}
	else if([_deviceModelName isEqualToString:@"iPod2,1"]) {
		_deviceModelName = @"iPod 2nd Gen";
	}
	else if([_deviceModelName isEqualToString:@"iPod3,1"]) {
		_deviceModelName = @"iPod 3rd Gen";
	}
	else if([_deviceModelName isEqualToString:@"iPod4,1"]) {
		_deviceModelName = @"iPod 4th Gen";
	}
	else if([_deviceModelName isEqualToString:@"iPod5,1"]) {
		_deviceModelName = @"iPod 5th Gen";
	}
	
    else if([_deviceModelName isEqualToString:@"iPad1,1"]) {
        _deviceModelName = @"iPad";
	}
    else if([_deviceModelName isEqualToString:@"iPad2,1"]) {
        _deviceModelName = @"iPad 2(WiFi)";
	}
    else if([_deviceModelName isEqualToString:@"iPad2,2"]) {
        _deviceModelName = @"iPad 2(GSM)";
	}
    else if([_deviceModelName isEqualToString:@"iPad2,3"]) {
        _deviceModelName = @"iPad 2(CDMA)";
	}
	else if([_deviceModelName isEqualToString:@"iPad3,1"]) {
        _deviceModelName = @"New iPad (WiFi)";
	}
    else if([_deviceModelName isEqualToString:@"iPad3,2"]) {
        _deviceModelName = @"New iPad (GSM)";
	}
    else if([_deviceModelName isEqualToString:@"iPad3,3"]) {
        _deviceModelName = @"New iPad (CDMA)";
	}
	
	return _deviceModelName;
}
#pragma mark -
- (NSDateFormatter*)dateformatterUTC {
	
	if (_dateformatterUTC == nil) {	FXDLog_DEFAULT;
		_dateformatterUTC = [[NSDateFormatter alloc] init];
		
		NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
		[_dateformatterUTC setTimeZone:UTCtimezone];
		[_dateformatterUTC setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
		FXDLog(@"_dateformatterUTC: %@", _dateformatterUTC);
	}
	
	return _dateformatterUTC;
}

- (NSDateFormatter*)dateformatterLocal {
	
	if (_dateformatterLocal == nil) {	FXDLog_DEFAULT;
		_dateformatterLocal = [[NSDateFormatter alloc] init];
		
		NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
		[_dateformatterLocal setTimeZone:localTimeZone];
		[_dateformatterLocal setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				
		FXDLog(@"_dateformatterLocal: %@", _dateformatterLocal);
	}
	
	return _dateformatterLocal;
}

#pragma mark -
- (id)rootController {
	if (_rootController == nil) {
		if (self.mainStoryboard) {
			_rootController = [self.mainStoryboard instantiateInitialViewController];
		}
		else {
			FXDLog_OVERRIDE;
		}
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
	
	FXDLog(@"addedControllers count: %d", [addedControllers count]);
	
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
	[self prepareGlobalManagerWithCoreDataManager:nil withUbiquityContainerURL:nil atLaunchWithWindowLoadingBlock:windowLoadingBlock];
}

- (void)prepareGlobalManagerWithCoreDataManager:(FXDsuperCoreDataManager*)coreDataManager withUbiquityContainerURL:(NSURL*)ubiquityContainerURL atLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock {	FXDLog_DEFAULT;
	
#if ForDEVELOPER
	NSUUID *deviceIdentier = [UIDevice currentDevice].identifierForVendor;
	FXDLog(@"deviceIdentier UUIDString: %@", [deviceIdentier UUIDString]);
#endif
	
	void (^didPrepareBlock)(void) = ^(void){
		[self startObservingEssentialNotifications];
		
		if (windowLoadingBlock) {
			windowLoadingBlock();
		}
	};
	
	
	if (coreDataManager == nil) {
		didPrepareBlock();
		return;
	}
	
	
	[coreDataManager
	 prepareCoreDataManagerWithUbiquityContainerURL:ubiquityContainerURL
	 didFinishBlock:^(BOOL finished) {
		 FXDLog(@"finished: %d %@", finished, strClassSelector);
		 
		 didPrepareBlock();
	 }];
}

- (void)startObservingEssentialNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillChangeStatusBarFrame:)
	 name:UIApplicationWillChangeStatusBarFrameNotification
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidChangeStatusBarFrame:)
	 name:UIApplicationDidChangeStatusBarFrameNotification
	 object:nil];

	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillResignActive:)
	 name:UIApplicationWillResignActiveNotification
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidBecomeActive:)
	 name:UIApplicationDidBecomeActiveNotification
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillTerminate:)
	 name:UIApplicationWillTerminateNotification
	 object:nil];
	
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedNSUserDefaultsDidChange:)
	 name:NSUserDefaultsDidChangeNotification
	 object:nil];
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
}

- (void)observedUIApplicationDidChangeStatusBarFrame:(NSNotification*)notification {	FXDLog_OVERRIDE;
}

#pragma mark -
- (void)observedUIApplicationWillResignActive:(NSNotification*)notification {	FXDLog_OVERRIDE;
}
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_OVERRIDE;
}
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification {	FXDLog_OVERRIDE;
}
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_OVERRIDE;
}

#pragma mark -
- (void)observedNSUserDefaultsDidChange:(NSNotification *)notification {	//FXDLog_OVERRIDE;
}

//MARK: - Delegate implementation


@end
