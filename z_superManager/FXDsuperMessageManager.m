//
//  FXDsuperMessageManager.m
//
//
//  Created by petershine on 3/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperMessageManager.h"


#pragma mark - Public implementation
@implementation FXDsuperMessageManager


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
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
		FXDWindow *mainWindow = (FXDWindow*)[UIApplication mainWindow];

		if (mainWindow.rootViewController) {
			FXDLogObject(mainWindow.rootViewController);

			presentingController = mainWindow.rootViewController;
		}
	}


	[emailController setMailComposeDelegate:self];

	[presentingController
	 presentViewController:emailController
	 animated:YES
	 completion:nil];
}

- (MFMailComposeViewController*)preparedMailComposeInterface {	FXDLog_DEFAULT;
	FXDLogObject([[NSBundle mainBundle] infoDictionary]);

	NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	FXDLogObject(version);

#if ForDEVELOPER
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages firstObject];
	FXDLogObject(currentLanguage);
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

	NSString *stringDevice = [NSString stringWithFormat:@"%@ %@", [GlobalAppManager deviceModelName], [[UIDevice currentDevice] systemVersion]];

	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

	NSArray *arrayCountryCode = [NSLocale ISOCountryCodes];
	NSMutableDictionary *dicCountryCode = [[NSMutableDictionary alloc] initWithCapacity:0];

	for(NSString *countryCode in arrayCountryCode) {
		NSString *currentCountryName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
		dicCountryCode[countryCode] = currentCountryName;
	}

	NSString *stringKey = [[[NSLocale currentLocale] localeIdentifier] substringWithRange:NSMakeRange(3, 2)];
	NSString *returnString = [NSString stringWithFormat:@"%@", dicCountryCode[stringKey]];

	NSString *stringCountry = [NSString stringWithFormat:@"%@", returnString];


	NSString *mailBodyString = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n%@\n", lineSeparator, stringAppVersion, stringDevice, stringCountry];

	FXDLogObject(mailBodyString);

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

	FXDLogVariable(result);

	FXDLog_ERROR;

	[controller dismissViewControllerAnimated:YES completion:nil];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
