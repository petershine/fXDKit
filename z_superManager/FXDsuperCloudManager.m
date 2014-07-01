//
//  FXDsuperCloudManager.m
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCloudManager.h"


@implementation FXDsuperCloudManager

#pragma mark - Memory management
- (void)dealloc {
	_statusCallback = NULL;
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareContainerURLwithIdentifier:(NSString*)containerIdentifier withStatusCallback:(FXDcallbackFinish)statusCallback {	FXDLog_DEFAULT;

	FXDLogObject(containerIdentifier);
	FXDLogObject(statusCallback);

	_containerIdentifier = containerIdentifier;
	_statusCallback = statusCallback;

	
	[self observedNSUbiquityIdentityDidChange:nil];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedNSUbiquityIdentityDidChange:)
	 name:NSUbiquityIdentityDidChangeNotification
	 object:nil];
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);

	NSFileManager *fileManager = [NSFileManager defaultManager];
	FXDLogObject(fileManager.ubiquityIdentityToken);

	if (fileManager.ubiquityIdentityToken == nil) {
		[FXDAlertView
		 showAlertWithTitle:NSLocalizedString(@"Please enable iCloud", nil)
		 message:nil
		 cancelButtonTitle:nil
		 withAlertCallback:nil];

		if (_statusCallback) {
			_statusCallback(_cmd, NO, nil);
		}
		return;
	}


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	id identityToken = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:userdefaultObjSavedUbiquityIdentityToken]];
	FXDLogObject(identityToken);
	FXDLogBOOL([identityToken isEqual:fileManager.ubiquityIdentityToken]);

	if (identityToken == nil
		|| [identityToken isEqual:fileManager.ubiquityIdentityToken] == NO) {

		identityToken = fileManager.ubiquityIdentityToken;

		NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:identityToken];

		[userDefaults setObject:archivedData forKey:userdefaultObjSavedUbiquityIdentityToken];
		[userDefaults synchronize];
	}


	self.containerURL = [NSURL URLWithString:[userDefaults objectForKey:userdefaultStringSavedUbiquityContainerURL]];
	FXDLogObject(self.containerURL);


	[[NSOperationQueue new]
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
		 FXDLogObject(self.containerIdentifier);

		 NSURL *ubiquityContainerURL = [fileManager URLForUbiquityContainerIdentifier:self.containerIdentifier];
		 FXDLogObject(ubiquityContainerURL);


		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  FXDLogObject(self.containerURL);

			  FXDLogBOOL([[ubiquityContainerURL absoluteString] isEqualToString:[self.containerURL absoluteString]]);

			  if (ubiquityContainerURL == nil && self.containerURL == nil) {
				  [FXDAlertView
				   showAlertWithTitle:NSLocalizedString(@"iCloud cannot be activated currently", nil)
				   message:nil
				   cancelButtonTitle:nil
				   withAlertCallback:nil];

				  if (_statusCallback) {
					  _statusCallback(_cmd, NO, nil);
				  }
				  return;
			  }


			  [userDefaults setObject:[ubiquityContainerURL absoluteString] forKey:userdefaultStringSavedUbiquityContainerURL];
			  [userDefaults synchronize];


			  self.containerURL = ubiquityContainerURL;

#if ForDEVELOPER
			  FXDLogObject([fileManager infoDictionaryForFolderURL:self.containerURL]);
			  FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
			  FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Document]);
#endif

			  if (_statusCallback) {
				  _statusCallback(_cmd, YES, self.containerURL);
			  }
		  }];
	 }];
}

//MARK: - Delegate implementation

@end
