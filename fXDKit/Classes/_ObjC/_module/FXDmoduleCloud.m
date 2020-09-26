

#import "FXDmoduleCloud.h"


@implementation FXDmoduleCloud

#pragma mark - Memory management
- (void)dealloc {
	_statusCallback = nil;
}

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareContainerURLwithIdentifier:(NSString*)containerIdentifier withStatusCallback:(FXDcallbackFinish)statusCallback {	FXDLog_DEFAULT

	FXDLogObject(containerIdentifier);
	FXDLogObject(statusCallback);

	_containerIdentifier = containerIdentifier;
	_statusCallback = statusCallback;


	[self observedNSUbiquityIdentityDidChange:nil];
}

#pragma mark -
- (void)notifyCallbackWithContainerURL:(NSURL*)containerURL shouldAddObserver:(BOOL)shouldAddObserver withAlertBody:(NSString*)alertBody {	FXDLog_DEFAULT

	//MARK: Assume if notification is nil, observer should be added
	if (shouldAddObserver) {
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSUbiquityIdentityDidChange:)
		 name:NSUbiquityIdentityDidChangeNotification
		 object:nil];
	}

	if (alertBody.length > 0) {

		//TODO: To be used with Swift version of simpleAlert
		UIAlertController *alertController = [UIAlertController
											  alertControllerWithTitle:alertBody
											  message:nil
											  preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *cancelAction =
		[UIAlertAction
		 actionWithTitle:NSLocalizedString(@"OK", nil)
		 style:UIAlertActionStyleCancel
		 handler:nil];

		[alertController addAction:cancelAction];


		UIWindow *mainWindow = [[UIApplication sharedApplication] performSelector:@selector(mainWindow:)];
		FXDLogObject(mainWindow);

		UIViewController *presentingScene = mainWindow.rootViewController;
		FXDLogObject(presentingScene);

		[presentingScene
		 presentViewController:alertController
		 animated:YES
		 completion:nil];
	}

	if (_statusCallback) {
		_statusCallback(_cmd, (containerURL != nil), containerURL);
	}
}


#pragma mark - Observer
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

	NSFileManager *fileManager = [NSFileManager defaultManager];
	FXDLogObject(fileManager.ubiquityIdentityToken);

	if (fileManager.ubiquityIdentityToken == nil) {
		[self
		 notifyCallbackWithContainerURL:nil
		 shouldAddObserver:(notification == nil)
		 withAlertBody:NSLocalizedString(@"Please enable iCloud", nil)];
		return;
	}


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSError *error = nil;
	id<NSObject,NSCopying,NSCoding> identityToken = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:[userDefaults objectForKey:userdefaultObjSavedUbiquityIdentityToken] error:&error];
	FXDLogObject(identityToken);
	FXDLogBOOL([identityToken isEqual:fileManager.ubiquityIdentityToken]);
	FXDLog_ERROR

	if (identityToken == nil
		|| [identityToken isEqual:fileManager.ubiquityIdentityToken] == NO) {

		identityToken = fileManager.ubiquityIdentityToken;

		NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:identityToken requiringSecureCoding:NO error:&error];
		FXDLog_ERROR

		[userDefaults setObject:archivedData forKey:userdefaultObjSavedUbiquityIdentityToken];
		[userDefaults synchronize];
	}


	self.containerURL = [NSURL evaluatedURLforPath:[userDefaults objectForKey:userdefaultStringSavedUbiquityContainerURL]];
	FXDLogObject(self.containerURL);


	NSOperationQueue *containerURLupdatingQueue = [NSOperationQueue newSerialQueueWithName:NSStringFromSelector(_cmd)];

	[containerURLupdatingQueue
	 addOperationWithBlock:^{	FXDLog_DEFAULT
		 FXDLogObject(self.containerIdentifier);

		 NSURL *ubiquityContainerURL = [fileManager URLForUbiquityContainerIdentifier:self.containerIdentifier];
		 FXDLogObject(ubiquityContainerURL);


		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{	FXDLog_DEFAULT
			  FXDLogObject(self.containerURL);

			  FXDLogBOOL([[ubiquityContainerURL absoluteString] isEqualToString:[self.containerURL absoluteString]]);

			  if (ubiquityContainerURL == nil && self.containerURL == nil) {
				  [self
				   notifyCallbackWithContainerURL:nil
				   shouldAddObserver:(notification == nil)
				   withAlertBody:NSLocalizedString(@"iCloud cannot be activated currently", nil)];
				  return;
			  }


			  [userDefaults setObject:ubiquityContainerURL.absoluteString forKey:userdefaultStringSavedUbiquityContainerURL];
			  [userDefaults synchronize];


			  self.containerURL = ubiquityContainerURL;

			  FXDLogObject([fileManager infoDictionaryForFolderURL:self.containerURL]);

			  [self
			   notifyCallbackWithContainerURL:self.containerURL
			   shouldAddObserver:(notification == nil)
			   withAlertBody:nil];
		  }];
	 }];
}

#pragma mark - Delegate

@end
