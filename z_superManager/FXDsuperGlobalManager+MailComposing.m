//
//  FXDsuperGlobalManager+MailComposing.m
//
//
//  Created by petershine on 1/8/13.
//  Copyright (c) 2013 petershine. All rights reserved.
//

#import "FXDsuperGlobalManager.h"

#import "Reachability.h"


@implementation FXDsuperGlobalManager (MailComposing)
- (MFMailComposeViewController*)preparedMailComposeInterface {	FXDLog_DEFAULT;
	FXDLog(@"[NSBundle mainBundle] infoDictionary: %@", [[NSBundle mainBundle] infoDictionary]);

	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	FXDLog(@"version: %@", version);

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = languages[0];
	FXDLog(@"currentLanguage: %@", currentLanguage);

	NSString *mailAddr = NSLocalizedString(application_ContactEmail, nil);

	NSArray *toRecipients = nil;
	
	if (mailAddr) {
		toRecipients = @[mailAddr];
	}


#ifdef application_DisplayedName
	NSString *bundleName = NSLocalizedString(application_DisplayedName, nil);
#else
	NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
#endif

	NSString *subjectString = [NSString stringWithFormat:@"[%@]", bundleName];

	NSString *stringLine = @"_______________________________";
	NSString *stringAppVersion = [NSString stringWithFormat:@"%@ %@", subjectString, version];

	NSString *machineStr = [[self class] deviceModelName];

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


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	FXDLog_DEFAULT;

	FXDLog(@"result: %d", result);

	FXDLog_ERROR;

	[controller dismissViewControllerAnimated:YES completion:nil];
}


@end
