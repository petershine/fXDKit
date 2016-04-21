

#import "FXDmoduleSocial.h"


@implementation FXDmoduleSocial

#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		//TODO: Make sure observing of only started if the modula began running
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

		[notificationCenter
		 addObserver:self
		 selector:@selector(observedACAccountStoreDidChange:)
		 name:ACAccountStoreDidChangeNotification
		 object:nil];
	}

	return self;
}


#pragma mark - Property overriding
- (NSString*)typeIdentifier {
	if (_typeIdentifier == nil) {	FXDLog_OVERRIDE;
	}
	return _typeIdentifier;
}

- (NSString*)reasonForConnecting {
	if (_reasonForConnecting == nil) {	FXDLog_OVERRIDE;
	}
	return _reasonForConnecting;
}

- (NSDictionary*)initialAccessOptions {
	if (_initialAccessOptions == nil) {	FXDLog_OVERRIDE;
	}
	return _initialAccessOptions;
}

- (NSDictionary*)additionalAccessOptions {
	if (_additionalAccessOptions == nil) {	FXDLog_OVERRIDE;
	}
	return _additionalAccessOptions;
}

#pragma mark -
- (ACAccountStore*)mainAccountStore {
	if (_mainAccountStore == nil) {
		_mainAccountStore = [[ACAccountStore alloc] init];
	}
	return _mainAccountStore;
}

#pragma mark -
- (ACAccountType*)mainAccountType {
	if (_mainAccountType == nil) {
		if (self.typeIdentifier) {
			_mainAccountType = [self.mainAccountStore accountTypeWithAccountTypeIdentifier:self.typeIdentifier];
		}
#if ForDEVELOPER
		else {
			FXDLog_OVERRIDE;
		}
#endif
	}

	return _mainAccountType;
}

- (NSArray*)multiAccountArray {
	if (_multiAccountArray == nil) {
		if (self.mainAccountType) {
			_multiAccountArray = [self.mainAccountStore accountsWithAccountType:self.mainAccountType];
		}
#if ForDEVELOPER
		else {
			FXDLog_OVERRIDE;
		}
#endif
	}

	return _multiAccountArray;
}

- (ACAccount*)currentMainAccount {
	if (_currentMainAccount) {
		return _currentMainAccount;
	}

	
	FXDLog_DEFAULT;

	NSString *accountObjKey = @"";

	if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		accountObjKey = userdefaultObjMainTwitterAccountIdentifier;
	}
	else if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		accountObjKey = userdefaultObjMainFacebookAccountIdentifier;
	}


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSString *identifier = [userDefaults stringForKey:accountObjKey];

	FXDLog(@"%@ %@", _Object(accountObjKey), _Object(identifier));

	if (identifier) {

		if (self.mainAccountType.accessGranted) {
			_currentMainAccount = [self.mainAccountStore accountWithIdentifier:identifier];
		}
		else {
			identifier = nil;
		}
	}


	if (identifier) {
		[userDefaults setObject:identifier forKey:accountObjKey];
	}
	else {
		[userDefaults removeObjectForKey:accountObjKey];
	}

	[userDefaults synchronize];
	FXDLogObject(_currentMainAccount);

	return _currentMainAccount;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier fromPresentingScene:(UIViewController*)presentingScene withFinishCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLogObject(typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (callback) {
			callback(_cmd, NO, nil);
		}
		return;
	}


	FXDLogObject(self.mainAccountType.accountTypeDescription);
	FXDLogVariable(self.mainAccountType.accessGranted);

	void (^GrantedAccess)(void) = ^(void){
		[self
		 showActionSheetFromPresentingScene:presentingScene
		 forSelectingAccountForTypeIdentifier:typeIdentifier
		 withFinishCallback:callback];
	};

	void (^DeniedAccess)(void) = ^(void){
		NSString *alertTitle = nil;

		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			alertTitle = NSLocalizedString(@"Please grant Twitter access in Settings", nil);
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			alertTitle = NSLocalizedString(@"Please grant Facebook access in Settings", nil);
		}

		[FXDAlertController
		 showAlertWithTitle:alertTitle
		 message:self.reasonForConnecting
		 cancelButtonTitle:nil
		 withAlertCallback:nil];

		self->_mainAccountType = nil;

		if (callback) {
			callback(_cmd, NO, nil);
		}
	};


	if (self.mainAccountType.accessGranted) {
		GrantedAccess();
		return;
	}
	
	
	[self.mainAccountStore
	 requestAccessToAccountsWithType:self.mainAccountType
	 options:self.initialAccessOptions
	 completion:^(BOOL granted, NSError *error) {
		 FXDLog(@"1.%@", _BOOL(granted));
		 FXDLog_ERROR;
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{

			  if (granted == NO) {
				  DeniedAccess();
				  return;
			  }

			  if (self.additionalAccessOptions == nil) {
				  GrantedAccess();
				  return;
			  }

			  
			  [self.mainAccountStore
			   requestAccessToAccountsWithType:self.mainAccountType
			   options:self.additionalAccessOptions
			   completion:^(BOOL granted, NSError *error) {
				   FXDLog(@"2.%@", _BOOL(granted));
				   FXDLog_ERROR;

				   [[NSOperationQueue mainQueue]
					addOperationWithBlock:^{

						if (granted == NO) {
							DeniedAccess();
							return;
						}

						GrantedAccess();
					}];
			   }];
		  }];
	 }];
}

- (void)showActionSheetFromPresentingScene:(UIViewController*)presentingScene forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLogObject(typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	FXDLogObject(self.multiAccountArray);
	
	if (self.multiAccountArray.count == 0) {
		_multiAccountArray = nil;

		NSString *alertTitle = nil;

		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			alertTitle = NSLocalizedString(@"Please sign up for a Twitter account", nil);
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			alertTitle = NSLocalizedString(@"Please sign up for a Facebook account", nil);
		}

		[FXDAlertController
		 showAlertWithTitle:alertTitle
		 message:self.reasonForConnecting
		 cancelButtonTitle:nil
		 withAlertCallback:nil];

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	NSString *actionsheetTitle = nil;
	NSString *accountObjKey = @"";

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Twitter Account", nil);
		accountObjKey = userdefaultObjMainTwitterAccountIdentifier;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Facebook Timeline or Page", nil);
		accountObjKey = userdefaultObjMainFacebookAccountIdentifier;
	}

	FXDAlertController *alertController = [FXDAlertController
										   alertControllerWithTitle:actionsheetTitle
										   message:nil
										   preferredStyle:UIAlertControllerStyleActionSheet];

	FXDAlertAction *cancelAction =
	[FXDAlertAction
	 actionWithTitle:NSLocalizedString(@"Cancel", nil)
	 style:UIAlertActionStyleCancel
	 handler:^(UIAlertAction * _Nonnull action) {
		 _multiAccountArray = nil;

		 if (finishCallback) {
			 finishCallback(_cmd, NO, nil);
		 }
	 }];

	FXDAlertAction *signOutAction =
	[FXDAlertAction
	 actionWithTitle:NSLocalizedString(@"Sign Out", nil)
	 style:UIAlertActionStyleDestructive
	 handler:^(UIAlertAction * _Nonnull action) {
		 [[NSUserDefaults standardUserDefaults] removeObjectForKey:accountObjKey];

		 _currentMainAccount = nil;

		 _multiAccountArray = nil;

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];

	[alertController addAction:cancelAction];
	[alertController addAction:signOutAction];


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	for (ACAccount *account in self.multiAccountArray) {

		NSString *actionTitle = nil;

		if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			actionTitle = [NSString stringWithFormat:@"@%@", account.username];
		}
		else if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			if (account.userFullName) {
				actionTitle = [NSString stringWithFormat:@"%@", account.userFullName];
			}
			else {
				actionTitle = [NSString stringWithFormat:@"%@", account.username];
			}
		}


		FXDAlertAction *selectAction =
		[FXDAlertAction
		 actionWithTitle:actionTitle
		 style:UIAlertActionStyleDefault
		 handler:^(UIAlertAction * _Nonnull action) {
			 FXDLogObject(account);

			 if (account) {
				 [userDefaults setObject:account.identifier forKey:accountObjKey];

				 _currentMainAccount = account;
			 }

			 [userDefaults synchronize];

			 _multiAccountArray = nil;

			 if (finishCallback) {
				 finishCallback(_cmd, YES, nil);
			 }
		 }];

		[alertController addAction:selectAction];
	}


	[presentingScene
	 presentViewController:alertController
	 animated:YES
	 completion:nil];
}


#pragma mark -
- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock {	FXDLog_DEFAULT;
	FXDLogObject(typeIdentifier);

	if (self.currentMainAccount.username == nil) {
		[self.mainAccountStore
		 renewCredentialsForAccount:self.currentMainAccount
		 completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
			 FXDLog_ERROR;
			 
			 FXDLogVariable(renewResult);
			 
			 //TODO: alert user about needing to have accessibility

			 if (requestingBlock) {
				 requestingBlock((renewResult == ACAccountCredentialRenewResultRenewed));
			 }
		 }];
	}
	else {
		if (requestingBlock) {
			requestingBlock(YES);
		}
	}
}

#pragma mark -
- (SLComposeViewController*)socialComposeControllerForServiceIdentifier:(NSString*)serviceIdentifier withInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;

	SLComposeViewController *socialComposeController = nil;

	if ([SLComposeViewController isAvailableForServiceType:serviceIdentifier] == NO) {

		NSString *alertTitle = nil;

		if ([serviceIdentifier isEqualToString:SLServiceTypeTwitter]) {
			alertTitle = NSLocalizedString(@"Please connect to Twitter", nil);
		}
		else if ([serviceIdentifier isEqualToString:SLServiceTypeFacebook]) {
			alertTitle = NSLocalizedString(@"Please connect to Facebook", nil);
		}

		
		[FXDAlertController
		 showAlertWithTitle:alertTitle
		 message:self.reasonForConnecting
		 cancelButtonTitle:nil
		 withAlertCallback:nil];
		
		return nil;
	}


	socialComposeController = [SLComposeViewController composeViewControllerForServiceType:serviceIdentifier];

	if (initialText) {
		if ([socialComposeController setInitialText:initialText] == NO) {
			FXDLogObject(initialText);
		}
	}

	if (imageArray.count > 0) {
		for (UIImage *image in imageArray) {
			if ([socialComposeController addImage:image] == NO) {
				FXDLogObject(image);
			}
		}
	}

	if (URLarray.count > 0) {
		for (NSURL *url in URLarray) {
			if ([socialComposeController addURL:url] == NO) {
				FXDLogObject(url);
			}
		}
	}

	return socialComposeController;
}


- (void)evaluateResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;

	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger statusCode = [(NSHTTPURLResponse*)urlResponse statusCode];
		NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];

		if (statusCodeDescription) {}
		FXDLogObject([(NSHTTPURLResponse*)urlResponse allHeaderFields]);
		FXDLog(@"%@ : %@", _Variable(statusCode), _Object(statusCodeDescription));
	}

	FXDLogVariable([responseData length]);

	if ([responseData length] > 0) {
		id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		if (jsonObj) {}
		FXDLog(@"%@\n %@", _Object([jsonObj class]), jsonObj);
	}
}


#pragma mark - Observer
- (void)observedACAccountStoreDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);

#if	ForDEVELOPER
	FXDLogObject(self.typeIdentifier);

	ACAccountStore *accountStore = [notification object];

	for (ACAccount *account in accountStore.accounts) {
		ACAccountType *accountType = account.accountType;

		FXDLogObject(account.accountType.identifier);
		FXDLogObject(account.accountType.accountTypeDescription);

		FXDLogBOOL(accountType.accessGranted);

		FXDLog(@"%@ %@ %@ %@", account.username, _Object(accountType.identifier), _Object(accountType.accountTypeDescription), _BOOL(account.accountType.accessGranted));
	}
#endif
}

#pragma mark - Delegate
	
@end


@implementation FXDmoduleTwitter : FXDmoduleSocial
- (NSString*)typeIdentifier {
	if (_typeIdentifier == nil) {
		_typeIdentifier = ACAccountTypeIdentifierTwitter;
	}

	return _typeIdentifier;
}

- (NSString*)reasonForConnecting {
	if (_reasonForConnecting == nil) {	FXDLog_OVERRIDE;
		_reasonForConnecting = NSLocalizedString(@"Please go to device's Settings and add your Twitter account", nil);
	}

	return _reasonForConnecting;
}

#pragma mark -
- (void)twitterUserShowWithScreenName:(NSString*)screenName {

	if (self.currentMainAccount == nil) {	FXDLog_DEFAULT;
		FXDLogObject(self.currentMainAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierTwitter
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 NSURL *requestURL = [NSURL evaluatedURLforPath:urlstringTwitterUserShow];

		 NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};

		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

		 defaultRequest.account = self.currentMainAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData,
									  NSHTTPURLResponse *urlResponse,
									  NSError *error) {
			  FXDLog_BLOCK(defaultRequest, @selector(performRequestWithHandler:));

#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}

- (void)twitterStatusUpdateWithTweetText:(NSString*)tweetText atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude {

	if (self.currentMainAccount == nil) {	FXDLog_DEFAULT;
		FXDLogObject(self.currentMainAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierTwitter
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 NSURL *requestURL = [NSURL evaluatedURLforPath:urlstringTwitterStatusUpdate];

		 NSMutableDictionary *parameters = [@{objkeyTwitterStatus: tweetText} mutableCopy];

		 if (latitude != 0.0 && longitude != 0.0) {
			 parameters[objkeyTwitterLat] = @(latitude);
			 parameters[objkeyTwitterLong] = @(longitude);
		 }


		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:parameters];

		 defaultRequest.account = self.currentMainAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData,
									  NSHTTPURLResponse *urlResponse,
									  NSError *error) {
			  FXDLog_BLOCK(defaultRequest, @selector(performRequestWithHandler:));

#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}

@end


@implementation FXDmoduleFacebook : FXDmoduleSocial
- (NSString*)typeIdentifier {
	if (_typeIdentifier == nil) {
		_typeIdentifier = ACAccountTypeIdentifierFacebook;
	}

	return _typeIdentifier;
}

- (NSString*)reasonForConnecting {
	if (_reasonForConnecting == nil) {	FXDLog_OVERRIDE;
		_reasonForConnecting = NSLocalizedString(@"Please go to device's Settings and add your Facebook account", nil);
	}

	return _reasonForConnecting;
}

- (NSDictionary*)initialAccessOptions {
	if (_initialAccessOptions == nil) {	FXDLog_DEFAULT;
		_initialAccessOptions = @{ACFacebookAppIdKey:	apikeyFacebookAppId,
						   ACFacebookPermissionsKey:	@[facebookPermissionEmail]};

		FXDLogObject(_initialAccessOptions);
	}

	return _initialAccessOptions;
}

#pragma mark -
- (void)facebookRequestForFacebookUserId:(NSString*)facebookUserId {
	if (self.currentMainAccount == nil) {	FXDLog_DEFAULT;
		FXDLogObject(self.currentMainAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierFacebook
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);
		 
		 NSURL *requestURL = nil;

		 if ([facebookUserId length] > 0) {
			 requestURL = [NSURL evaluatedURLforPath:urlstringFacebook(facebookUserId)];
		 }
		 else {
			 requestURL = [NSURL evaluatedURLforPath:urlstringFacebook(facebookGraphMe)];
		 }


		 NSDictionary *parameters = nil;

		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

		 defaultRequest.account = self.currentMainAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData,
									  NSHTTPURLResponse *urlResponse,
									  NSError *error) {
			  FXDLog_BLOCK(defaultRequest, @selector(performRequestWithHandler:));

#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}
@end
