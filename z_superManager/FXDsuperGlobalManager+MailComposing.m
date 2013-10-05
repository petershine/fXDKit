//
//  FXDsuperGlobalManager+MailComposing.m
//
//
//  Created by petershine on 1/8/13.
//  Copyright (c) 2013 fXceed All rights reserved.
//

#import "FXDsuperGlobalManager.h"


@implementation FXDsuperGlobalManager (MailComposing)
- (void)presentEmailController:(MFMailComposeViewController*)emailController forPresentingController:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;
	
	
	if ([MFMailComposeViewController canSendMail] == NO) {
		//TODO: alert user
		return;
	}
	
	
	if (emailController == nil) {
		if (image || message) {
			emailController = [self preparedMailComposeInterfaceForSharingUsingImage:image usingMessage:message];
		}
		else {
			emailController = [self preparedMailComposeInterface];
		}
	}
	
	if (presentingController == nil) {
		FXDWindow *applicationWindow = [FXDWindow applicationWindow];
		
		if (applicationWindow.rootViewController) {
			FXDLog(@"applicationWindow.rootViewController: %@", applicationWindow.rootViewController);
			
			presentingController = applicationWindow.rootViewController;
		}
	}
	
	
	[emailController setMailComposeDelegate:self];
	
	[presentingController
	 presentViewController:emailController
	 animated:YES
	 completion:nil];
}

- (MFMailComposeViewController*)preparedMailComposeInterface {	FXDLog_DEFAULT;
	FXDLog(@"[NSBundle mainBundle] infoDictionary: %@", [[NSBundle mainBundle] infoDictionary]);

	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	FXDLog(@"version: %@", version);

#if ForDEVELOPER
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = languages[0];
	FXDLog(@"currentLanguage: %@", currentLanguage);
#endif

	NSString *mailAddr = NSLocalizedString(application_ContactEmail, nil);

	NSArray *toRecipients = nil;
	
	if (mailAddr) {
		toRecipients = @[mailAddr];
	}


	NSString *displayName = application_DisplayName;

	NSString *subjectString = [NSString stringWithFormat:@"[%@]", displayName];

	NSString *lineSeparator = @"_______________________________";
	NSString *stringAppVersion = [NSString stringWithFormat:@"%@ %@", subjectString, version];

	NSString *stringDevice = [NSString stringWithFormat:@"%@ %@", self.deviceModelName, [[UIDevice currentDevice] systemVersion]];

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


	//TEST: Find the right way to use
	/*
	NSString *stringNetwork = [[AFNetworkReachabilityManager sharedManager] localizedNetworkReachabilityStatusString];
	FXDLog(@"1.stringNetwork: %@", stringNetwork);

	if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
		stringNetwork = @"Network : WiFi";
	}
	else {
		stringNetwork = @"Network : 3G network";
	}
	
	FXDLog(@"2.stringNetwork: %@", stringNetwork);

	NSString *mailBodyString = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n%@\n%@\n", stringLine, stringAppVersion, stringDevice, stringCountry, stringNetwork];
	 */

	NSString *mailBodyString = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n%@\n", lineSeparator, stringAppVersion, stringDevice, stringCountry];

	FXDLog(@"mailBodyString: %@", mailBodyString);

	MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailController setSubject:subjectString];
	[emailController setToRecipients:toRecipients];
	[emailController setMessageBody:mailBodyString isHTML:NO];

	return emailController;
}

- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;

	MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailController setSubject:[NSString stringWithFormat:@"[%@]", application_DisplayName]];

	if (image) {
		[emailController addAttachmentData:UIImageJPEGRepresentation(image, 1.0) mimeType:@"image/jpeg" fileName:@"sharedImage"];
	}

	if (message) {
		[emailController setMessageBody:message isHTML:NO];
	}

	return emailController;
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	FXDLog_DEFAULT;

	FXDLog(@"result: %d", result);

	FXDLog_ERROR;

	[controller dismissViewControllerAnimated:YES completion:nil];
}


@end
