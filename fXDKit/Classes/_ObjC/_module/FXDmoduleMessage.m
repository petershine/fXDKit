

#import "FXDmoduleMessage.h"


@implementation FXDmoduleMessage

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message withRecipients:(NSArray*)recipients {	FXDLog_DEFAULT;


	if ([MFMailComposeViewController canSendMail] == NO) {
		//FIXME: alert user
		return;
	}


	if (emailScene == nil) {
		if (image || message) {
			emailScene = [self emailSceneForSharingImage:image usingMessage:message];
		}
		else {
			emailScene = [self emailSceneWithMailBodyWithRecipients:recipients];
		}
	}

	if (presentingController == nil) {
		FXDWindow *mainWindow = (FXDWindow*)[UIApplication sharedApplication].delegate.window;

		if (mainWindow.rootViewController) {
			FXDLogObject(mainWindow.rootViewController);

			presentingController = mainWindow.rootViewController;
		}
	}


	emailScene.mailComposeDelegate = self;

	[presentingController
	 presentViewController:emailScene
	 animated:YES
	 completion:nil];
}

- (MFMailComposeViewController*)emailSceneWithMailBodyWithRecipients:(NSArray*)recipients {	FXDLog_DEFAULT;
	FXDLogObject([[NSBundle mainBundle] infoDictionary]);
	FXDLogObject(recipients);

	NSString *version = application_BundleVersion;
	FXDLogObject(version);

#if ForDEVELOPER
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = languages.firstObject;
	FXDLogObject(currentLanguage);
#endif


	NSString *displayName = application_DisplayName;

	NSString *subjectLine = [NSString stringWithFormat:@"[%@]", displayName];

	NSString *lineSeparator = @"_______________________________";
	NSString *appVersionLine = [NSString stringWithFormat:@"%@ %@", subjectLine, version];


	struct utsname systemInfo;
	uname(&systemInfo);

	NSString *machineName = @(systemInfo.machine);
	NSString *machineNameLine = [NSString stringWithFormat:@"%@ %@", machineName, [UIDevice currentDevice].systemVersion];

	NSString *mailBody = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@\n%@\n", lineSeparator, appVersionLine, machineNameLine];

	FXDLogObject(mailBody);

	MFMailComposeViewController *emailScene = [[MFMailComposeViewController alloc] initWithNavigationBarClass:nil toolbarClass:nil];
	[emailScene setSubject:subjectLine];
	[emailScene setToRecipients:recipients];
	[emailScene setMessageBody:mailBody isHTML:NO];

	return emailScene;
}

- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message {	FXDLog_DEFAULT;

	MFMailComposeViewController *emailScene = [[MFMailComposeViewController alloc] initWithNavigationBarClass:nil toolbarClass:nil];
	[emailScene setSubject:[NSString stringWithFormat:@"[%@]", application_DisplayName]];

	if (image) {
		[emailScene addAttachmentData:UIImageJPEGRepresentation(image, 1.0) mimeType:@"image/jpeg" fileName:@"sharedImage"];
	}

	if (message) {
		[emailScene setMessageBody:message isHTML:NO];
	}

	return emailScene;
}

#pragma mark - Observer

#pragma mark - Delegate
//MARK: MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {	FXDLog_DEFAULT;

	FXDLogVariable(result);

	FXDLog_ERROR;

	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
