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
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	FXDLog_SEPARATE;
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

		FXDLog(@"_deviceLanguageCode: %@ languages:\n%@", _deviceLanguageCode, languages);

		//MARK: limit supported languages
		if ([_deviceLanguageCode isEqualToString:@"en"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ko"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ja"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ch"] == NO
			&& [_deviceLanguageCode isEqualToString:@"tw"] == NO) {
			_deviceLanguageCode = @"en";
		}
	}

	return _deviceLanguageCode;
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

	if (windowLoadingBlock) {
		[self startObservingEssentialNotifications];
		
		windowLoadingBlock();
	}
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
+ (NSString*)deviceModelName {

	struct utsname systemInfo;

	uname(&systemInfo);

	NSString *modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

	if([modelName isEqualToString:@"i386"]) {
		modelName = @"iPhone Simulator";
	}
    else if([modelName isEqualToString:@"iPhone1,1"]) {
		modelName = @"iPhone";
	}
	else if([modelName isEqualToString:@"iPhone1,2"]) {
		modelName = @"iPhone 3G";
	}
	else if([modelName isEqualToString:@"iPhone2,1"]) {
		modelName = @"iPhone 3GS";
	}
	else if([modelName isEqualToString:@"iPhone3,1"]) {
		modelName = @"iPhone 4";
	}
	else if([modelName isEqualToString:@"iPhone4,1"]) {
		modelName = @"iPhone 4S";
	}
	else if([modelName isEqualToString:@"iPhone5,1"]) {
		modelName = @"iPhone 5";
	}

	else if([modelName isEqualToString:@"iPod1,1"]) {
		modelName = @"iPod 1st Gen";
	}
	else if([modelName isEqualToString:@"iPod2,1"]) {
		modelName = @"iPod 2nd Gen";
	}
	else if([modelName isEqualToString:@"iPod3,1"]) {
		modelName = @"iPod 3rd Gen";
	}
	else if([modelName isEqualToString:@"iPod4,1"]) {
		modelName = @"iPod 4th Gen";
	}
	else if([modelName isEqualToString:@"iPod5,1"]) {
		modelName = @"iPod 5th Gen";
	}

    else if([modelName isEqualToString:@"iPad1,1"]) {
        modelName = @"iPad";
	}
    else if([modelName isEqualToString:@"iPad2,1"]) {
        modelName = @"iPad 2(WiFi)";
	}
    else if([modelName isEqualToString:@"iPad2,2"]) {
        modelName = @"iPad 2(GSM)";
	}
    else if([modelName isEqualToString:@"iPad2,3"]) {
        modelName = @"iPad 2(CDMA)";
	}
	else if([modelName isEqualToString:@"iPad3,1"]) {
        modelName = @"New iPad (WiFi)";
	}
    else if([modelName isEqualToString:@"iPad3,2"]) {
        modelName = @"New iPad (GSM)";
	}
    else if([modelName isEqualToString:@"iPad3,3"]) {
        modelName = @"New iPad (CDMA)";
	}

	return modelName;
}

+ (NSString*)deviceCountryCode {
	NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
	
	NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
	
	NSString *countryCode = components[1];
	
	return countryCode;
}

+ (NSString*)deviceLanguageCode {	
	NSString *firstLanguage = [[self class] sharedInstance].deviceLanguageCode;
	
	return firstLanguage;
}

+ (void)alertWithMessage:(NSString*)message withTitle:(NSString*)title {
	FXDAlertView *alertview = [[FXDAlertView alloc]
							   initWithTitle:title
							   message:message
							   delegate:nil
							   cancelButtonTitle:NSLocalizedString(text_OK, nil)
							   otherButtonTitles:nil];

	[alertview show];
}

+ (void)printoutListOfFonts {	FXDLog_DEFAULT;
	FXDLog(@"UIFont familyNames: %@", [UIFont familyNames]);
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
