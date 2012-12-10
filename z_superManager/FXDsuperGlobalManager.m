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
	// Instance variables

	// Properties

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

- (BOOL)didShareToSocialNet {	//FXDLog_DEFAULT;
	_didShareToSocialNet = [[NSUserDefaults standardUserDefaults] boolForKey:userdefaultBoolDidShareToSocialNet];

	return _didShareToSocialNet;
}

- (void)setDidShareToSocialNet:(BOOL)didShare {	FXDLog_DEFAULT;
	_didShareToSocialNet = didShare;

	[[NSUserDefaults standardUserDefaults] setBool:_didShareToSocialNet forKey:userdefaultBoolDidShareToSocialNet];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

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

- (NSString*)mainStoryboardName {
	if (_mainStoryboardName == nil) {	FXDLog_OVERRIDE;
		//
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

- (id)rootScene {
	if (_rootScene == nil) {
		if (self.mainStoryboard) {
			_rootScene = [self.mainStoryboard instantiateInitialViewController];
		}
		else {
			FXDLog_OVERRIDE;
		}
	}

	return _rootScene;
}

- (id)homeScene {
	if (_homeScene == nil) {

		if ([self.rootScene respondsToSelector:@selector(viewControllers)] == NO) {
			_homeScene = self.rootScene;

			return _homeScene;
		}


		NSArray *viewControllers = [self.rootScene performSelector:@selector(viewControllers)];

		if ([viewControllers count] == 0) {
			return _homeScene;
		}


		if ([self.rootScene isKindOfClass:[UITabBarController class]] == NO) {
			_homeScene = viewControllers[0];

			return _homeScene;
		}


		id tabbedViewController = viewControllers[0];

		if ([tabbedViewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *tabbedNavigationController = (UINavigationController*)tabbedViewController;

			if ([tabbedNavigationController.viewControllers count] > 0) {
				_homeScene = (tabbedNavigationController.viewControllers)[0];
			}
		}
		else {
			_homeScene = tabbedViewController;
		}
	}

	return _homeScene;
}


#pragma mark - Method overriding


#pragma mark - Public
- (void)prepareGlobalManagerAtLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock {	FXDLog_OVERRIDE;
	FXDLog(@"windowLoadingBlock: %@", windowLoadingBlock);

	if (windowLoadingBlock) {
		windowLoadingBlock();
	}
}


+ (BOOL)isSystemVersionLatest {
	BOOL isSystemVersionLatest = NO;
	
	NSString *systemVersionString = [[UIDevice currentDevice] systemVersion];
	
	if ([systemVersionString floatValue] >= latestSupportedSystemVersion) {
		isSystemVersionLatest = YES;
	}
	
#if ForDEVELOPER
	FXDLog(@"isSystemVersionLatest: %d %f >= %f", isSystemVersionLatest, [systemVersionString floatValue], latestSupportedSystemVersion);
#endif
	
	return isSystemVersionLatest;
}

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
	FXDAlertView *alertview = [[FXDAlertView alloc] initWithTitle:title
														message:message
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(text_OK, nil)
											  otherButtonTitles:nil];
	
	[alertview show];
}

+ (void)alertCancelAndOKwithMessage:(NSString*)message withTitle:(NSString*)title alertDelegate:(id)alertDelegate {
	FXDAlertView *alertview = [[FXDAlertView alloc] initWithTitle:title
														  message:message
														 delegate:alertDelegate
												cancelButtonTitle:NSLocalizedString(text_Cancel, nil)
												otherButtonTitles:NSLocalizedString(text_OK, nil), nil];
	
	[alertview show];
}

+ (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay {	
	if (alertBody) {
		if (delay == 0.0) {
			delay = delayOneSecond;
		}
		
		UILocalNotification *localNotifcation = [[UILocalNotification alloc] init];
		localNotifcation.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
		localNotifcation.repeatInterval = 0;
		localNotifcation.soundName = UILocalNotificationDefaultSoundName;
		localNotifcation.alertBody = alertBody;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotifcation];
	}
}

+ (void)printoutListOfFonts {	FXDLog_DEFAULT;
	FXDLog(@"UIFont familyNames: %@", [UIFont familyNames]);
}

- (MFMailComposeViewController*)preparedMailComposeInterface {	FXDLog_DEFAULT;
	FXDLog(@"[NSBundle mainBundle] infoDictionary: %@", [[NSBundle mainBundle] infoDictionary]);
	
	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	FXDLog(@"version: %@", version);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = languages[0];
	FXDLog(@"currentLanguage: %@", currentLanguage);

	NSString *mailAddr = nil;
		
	NSArray *toRecipients = @[mailAddr];

#ifdef application_DisplayedName
	NSString *bundleName = NSLocalizedString(application_DisplayedName, nil);
#else
	NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];	
#endif
	
	NSString *subjectString = [NSString stringWithFormat:@"[%@]", bundleName];
	
	NSString *stringLine = @"_______________________________";
	NSString *stringAppVersion = [NSString stringWithFormat:@"%@ %@", subjectString, version];
	
	NSString *machineStr = [FXDsuperGlobalManager deviceModelName];
	
	NSString *stringDevice = [NSString stringWithFormat:@"%@ %@", machineStr, [[UIDevice currentDevice] systemVersion]];		
	
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	NSArray *arrayCountryCode = [NSLocale ISOCountryCodes];
	NSMutableDictionary *dicCountryCode = [[NSMutableDictionary alloc] init];
	
	for(NSString *countryCode in arrayCountryCode) {
		NSString *currentCountryName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
		dicCountryCode[countryCode] = currentCountryName;
	}
	
	NSString *stringKey = [[[NSLocale currentLocale] localeIdentifier] substringWithRange:NSMakeRange(3, 2)];
	NSString *returnString = [NSString stringWithFormat:@"%@", dicCountryCode[stringKey]];
	
	NSString *stringCountry = [NSString stringWithFormat:@"%@", returnString];
	
	NSString *stringNetwork = nil;
	
	if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
		stringNetwork = @"Network : WiFi";
	}
	else {
		stringNetwork = @"Network : 3G network";
	}
	
	NSString *mailBodyString = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n%@\n%@\n", stringLine, stringAppVersion, stringDevice, stringCountry, stringNetwork];
	FXDLog(@"mailBodyString: %@", mailBodyString);
	
	MFMailComposeViewController *emailInterface = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailInterface setSubject:subjectString];
	[emailInterface setToRecipients:toRecipients];
	[emailInterface setMessageBody:mailBodyString isHTML:NO];
		
	return emailInterface;
}

- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;
	
	MFMailComposeViewController *emailInterface = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailInterface setSubject:[NSString stringWithFormat:@"[%@]", NSLocalizedString(application_DisplayedName, nil)]];
	
	if (image) {		
		[emailInterface addAttachmentData:UIImageJPEGRepresentation(image, 1.0) mimeType:@"image/jpeg" fileName:@"sharedImage"];
	}
	
	if (message) {
		[emailInterface setMessageBody:message isHTML:NO];
	}
	
	return emailInterface;
}

- (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;
	
	if (presentingInterface == nil) {
		FXDWindow *applicationWindow = [FXDWindow applicationWindow];
		
		if (applicationWindow.rootViewController) {
			FXDLog(@"applicationWindow.rootViewController: %@", applicationWindow.rootViewController);
			
			presentingInterface = applicationWindow.rootViewController;
		}
	}
	
	if ([MFMailComposeViewController canSendMail]) {		
		MFMailComposeViewController *emailInterface = nil;
		
		if (image || message) {
			emailInterface = [self preparedMailComposeInterfaceForSharingUsingImage:image usingMessage:message];
		}
		else {
			emailInterface = [self preparedMailComposeInterface];
		}
		
		[emailInterface setMailComposeDelegate:self];
		
		[presentingInterface presentViewController:emailInterface
										  animated:YES
										completion:^{
											//OK
										}];
	}
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex != alertView.cancelButtonIndex) {
		NSDictionary *addedDictionary = (NSDictionary*)alertView.addedObj;
		
		if (addedDictionary) {
			//
		}
	}
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	FXDLog_DEFAULT;
	
	FXDLog(@"result: %d", result);

	FXDLog_ERROR;
	
	[controller dismissViewControllerAnimated:YES completion:nil];
}


@end
