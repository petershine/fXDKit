//
//  FXDmoduleMessage.m
//
//
//  Created by petershine on 3/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDmoduleMessage.h"



@implementation FXDmoduleMessage


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;


	if ([MFMailComposeViewController canSendMail] == NO) {
		//TODO: alert user
		return;
	}


	if (emailScene == nil) {
		if (image || message) {
			emailScene = [self emailSceneForSharingImage:image usingMessage:message];
		}
		else {
			emailScene = [self emailSceneWithMailBody];
		}
	}

	if (presentingController == nil) {
		FXDWindow *mainWindow = (FXDWindow*)[UIApplication mainWindow];

		if (mainWindow.rootViewController) {
			FXDLogObject(mainWindow.rootViewController);

			presentingController = mainWindow.rootViewController;
		}
	}


	[emailScene setMailComposeDelegate:self];

	[presentingController
	 presentViewController:emailScene
	 animated:YES
	 completion:nil];
}

- (MFMailComposeViewController*)emailSceneWithMailBody {	FXDLog_DEFAULT;
	FXDLogObject([[NSBundle mainBundle] infoDictionary]);

	NSString *version = application_BundleVersion;
	FXDLogObject(version);

#if ForDEVELOPER
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages firstObject];
	FXDLogObject(currentLanguage);
#endif

	NSString *contactEmail = NSLocalizedString(application_ContactEmail, nil);

	NSArray *toRecipients = nil;

	if (contactEmail) {
		toRecipients = @[contactEmail];
	}


	NSString *displayName = application_DisplayName;

	NSString *subjectLine = [NSString stringWithFormat:@"[%@]", displayName];

	NSString *lineSeparator = @"_______________________________";
	NSString *appVersionLine = [NSString stringWithFormat:@"%@ %@", subjectLine, version];


	struct utsname systemInfo;
	uname(&systemInfo);

	NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	NSString *machineNameLine = [NSString stringWithFormat:@"%@ %@", machineName, [UIDevice currentDevice].systemVersion];

	NSString *mailBody = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n", lineSeparator, appVersionLine, machineNameLine];

	FXDLogObject(mailBody);

	MFMailComposeViewController *emailScene = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailScene setSubject:subjectLine];
	[emailScene setToRecipients:toRecipients];
	[emailScene setMessageBody:mailBody isHTML:NO];

	return emailScene;
}

- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;

	MFMailComposeViewController *emailScene = [[MFMailComposeViewController alloc] initWithRootViewController:nil];
	[emailScene setSubject:[NSString stringWithFormat:@"[%@]", application_DisplayName]];

	if (image) {
		[emailScene addAttachmentData:UIImageJPEGRepresentation(image, 1.0) mimeType:@"image/jpeg" fileName:@"sharedImage"];
	}

	if (message) {
		[emailScene setMessageBody:message isHTML:NO];
	}

	return emailScene;
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