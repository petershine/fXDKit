

#import "FXDmoduleSocial.h"


@implementation FXDmoduleSocial

#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
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

	if (_currentMainAccount == nil) {	FXDLog_DEFAULT;

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
	}

	return _currentMainAccount;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withFinishCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

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
		[self showActionSheetInPresentingView:presentingView
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

		[FXDAlertView
		 showAlertWithTitle:alertTitle
		 message:self.reasonForConnecting
		 cancelButtonTitle:nil
		 withAlertCallback:nil];

		_mainAccountType = nil;

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

- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

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

		[FXDAlertView
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

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Twitter Account", nil);
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Facebook Timeline or Page", nil);
	}

	FXDActionSheet *actionSheet =
	[[FXDActionSheet alloc]
	 initWithTitle:actionsheetTitle
	 withButtonTitleArray:nil
	 cancelButtonTitle:nil
	 destructiveButtonTitle:nil
	 withAlertCallback:^(id alertObj, NSInteger buttonIndex) {
		 [self
		  selectAccountForTypeIdentifier:typeIdentifier
		  fromActionSheet:alertObj
		  forButtonIndex:buttonIndex
		  withFinishCallback:finishCallback];
	 }];
	
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
	actionSheet.cancelButtonIndex = 0;
	
	for (ACAccount *account in self.multiAccountArray) {
		if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
		}
		else if ([self.typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			if (account.userFullName) {
				[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@", account.userFullName]];
			}
			else {
				[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@", account.username]];
			}
		}
	}
	
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Sign Out", nil)];
	actionSheet.destructiveButtonIndex = self.multiAccountArray.count+1;
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:presentingView];
}

- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromActionSheet:(FXDActionSheet*)actionSheet forButtonIndex:(NSInteger)buttonIndex withFinishCallback:(FXDcallbackFinish)finishCallback {

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


	FXDLogVariable(buttonIndex);
	FXDLogVariable(actionSheet.cancelButtonIndex);
	FXDLogVariable(actionSheet.destructiveButtonIndex);

	if (buttonIndex == (NSInteger)[actionSheet performSelector:@selector(cancelButtonIndex)]) {
		_multiAccountArray = nil;

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	NSString *accountObjKey = @"";

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		accountObjKey = userdefaultObjMainTwitterAccountIdentifier;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		accountObjKey = userdefaultObjMainFacebookAccountIdentifier;
	}


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([actionSheet isKindOfClass:[UIActionSheet class]]
		&& buttonIndex == [(FXDActionSheet*)actionSheet destructiveButtonIndex]) {
		
		[userDefaults removeObjectForKey:accountObjKey];

		_currentMainAccount = nil;
	}
	else {
		ACAccount *selectedAccount = (self.multiAccountArray)[buttonIndex-1];
		FXDLogObject(selectedAccount);
		
		if (selectedAccount) {
			[userDefaults setObject:selectedAccount.identifier forKey:accountObjKey];

			_currentMainAccount = selectedAccount;
		}
		
		[userDefaults synchronize];
	}

	_multiAccountArray = nil;

	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
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

		
		[FXDAlertView
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
	FXDLog_ERROR_ALERT;

	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger statusCode = [(NSHTTPURLResponse*)urlResponse statusCode];
		NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];

		if (statusCodeDescription) {}
		FXDLogObject([(NSHTTPURLResponse*)urlResponse allHeaderFields]);
		FXDLog(@"%@ : %@", _Variable(statusCode), _Object(statusCodeDescription));
	}

	FXDLog(@"responseData %@ bytes", _Variable([responseData length]));

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

		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserShow];

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

		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];

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
			 requestURL = [NSURL URLWithString:urlstringFacebook(facebookUserId)];
		 }
		 else {
			 requestURL = [NSURL URLWithString:urlstringFacebook(facebookGraphMe)];
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


@implementation FXDmoduleFacebookSSO

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSDictionary*)additionalAccessOptions {
	if (_additionalAccessOptions == nil) {	FXDLog_DEFAULT;
		
		_additionalAccessOptions =
		@{ACFacebookAppIdKey:	apikeyFacebookAppId,
		  ACFacebookPermissionsKey:	@[facebookPermissionPublicProfile,
									  facebookPermissionUserFriends,
									  facebookPermissionPublishActions,
									  facebookPermissionManagePages,
									  facebookPermissionPublishStream],
		  ACFacebookAudienceKey:	ACFacebookAudienceEveryone};

		FXDLogObject(_additionalAccessOptions);
	}

	return _additionalAccessOptions;
}

- (NSArray*)multiAccountArray {	//NOTE: Using facebookSDK;
	return _multiAccountArray;
}

#pragma mark -
- (FBSessionLoginBehavior)sessionLoginBehavior {
	return FBSessionLoginBehaviorUseSystemAccountIfPresent;
}

#pragma mark -
- (NSDictionary*)currentFacebookAccount {

	if (_currentFacebookAccount == nil) {	FXDLog_DEFAULT;

		NSString *accountObjKey = userdefaultObjMainFacebookAccountIdentifier;


		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

		NSDictionary *accountDictionary = [userDefaults dictionaryForKey:accountObjKey];

		FXDLog(@"accountObjKey: %@", accountObjKey);

		if (accountDictionary) {
			_currentFacebookAccount = accountDictionary;
		}

		FXDLog(@"_currentFacebookAccount: %@", _currentFacebookAccount);
	}

	return _currentFacebookAccount;
}


#pragma mark - Method overriding
- (void)signInBySelectingAccountForTypeIdentifier:(NSString *)typeIdentifier withPresentingView:(UIView *)presentingView withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	[(FXDWindow*)[UIApplication mainWindow] showInformationViewAfterDelay:delayQuarterSecond];

	// Initialize a session object
	FBSession *activeSession = [FBSession activeSession];

	FXDLog(@"1.%@", _Variable(activeSession.state));
	FXDLog(@"1.%@", _BOOL(activeSession.isOpen));

	FXDLog(@"1.%@", _Variable(activeSession.accessTokenData.loginType));

	if (activeSession.isOpen) {
		[self
		 updateSessionPermissionWithFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
			 FXDLog_BLOCK(self, caller);
			 FXDLogBOOL(finished);

			 if (finished) {
				 [self
				  showActionSheetInPresentingView:presentingView
				  forSelectingAccountForTypeIdentifier:typeIdentifier
				  withFinishCallback:finishCallback];
			 }
			 else {
				 [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

				 if (finishCallback) {
					 finishCallback(_cmd, finished, nil);
				 }
			 }
		 }];
		return;
	}


	//TODO: Learn why this is called multiple times when asking for permission right after
	[FBSession
	 openActiveSessionWithReadPermissions:nil
	 allowLoginUI:YES
	 completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
		 FXDLog(@"2.%@", _Variable(status));
		 FXDLog(@"2.%@", _BOOL(session.isOpen));

		 FXDLog(@"2.%@", _Variable(session.accessTokenData.loginType));

		 BOOL shouldContinue = [self shouldContinueWithError:error];

		 if (shouldContinue == NO || session.isOpen == NO) {
			 [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

			 if (finishCallback) {
				 finishCallback(_cmd, shouldContinue, nil);
			 }
			 return;
		 }


		 FXDLog(@"self.isAskingForMorePermissions: %d", self.isAskingForMorePermissions);
		 if (self.isAskingForMorePermissions) {
			 return;
		 }


		 self.isAskingForMorePermissions = YES;

		 Float64 delayInSeconds = 2.0;

		 if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			 delayInSeconds = 0.0;
		 }

		 FXDLog(@"%@ %@", _BOOL([UIApplication sharedApplication].applicationState == UIApplicationStateActive), _Variable(delayInSeconds));

		 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			 [self
			  updateSessionPermissionWithFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
				  FXDLog_BLOCK(self, caller);
				  FXDLogBOOL(finished);

				  if (finished) {
					  [self
					   showActionSheetInPresentingView:presentingView
					   forSelectingAccountForTypeIdentifier:typeIdentifier
					   withFinishCallback:finishCallback];
				  }
				  else {
					  [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

					  if (finishCallback) {
						  finishCallback(_cmd, finished, nil);
					  }
				  }

				  self.isAskingForMorePermissions = NO;
			  }];
		 });
	 }];
}

- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	void (^ConfigureActionSheet)(void) = ^(void){
		FXDLog(@"self.multiAccountArray:\n%@", self.multiAccountArray);

		NSString *actionsheetTitle = NSLocalizedString(@"Please select your Facebook Timeline or Page", nil);

		FXDActionSheet *actionSheet =
		[[FXDActionSheet alloc]
		 initWithTitle:actionsheetTitle
		 withButtonTitleArray:nil
		 cancelButtonTitle:nil
		 destructiveButtonTitle:nil
		 withAlertCallback:^(id alertObj, NSInteger buttonIndex) {
			 [self
			  selectAccountForTypeIdentifier:typeIdentifier
			  fromActionSheet:alertObj
			  forButtonIndex:buttonIndex
			  withFinishCallback:finishCallback];
		 }];

		[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
		actionSheet.cancelButtonIndex = 0;

		for (NSDictionary *account in self.multiAccountArray) {
			NSString *buttonTitle = nil;

			if ([account[objkeyFacebookCategory] length] == 0) {
				if ([account[objkeyFacebookUsername] length] > 0) {
					buttonTitle = [NSString stringWithFormat:@"TIMELINE: %@", account[objkeyFacebookUsername]];
				}
				else {
					buttonTitle = [NSString stringWithFormat:@"TIMELINE: %@", account[objkeyFacebookName]];
				}
			}
			else {
				buttonTitle = [NSString stringWithFormat:@"PAGE: %@", account[objkeyFacebookName]];
			}

			if (buttonTitle) {
				[actionSheet addButtonWithTitle:buttonTitle];
			}
		}

		[actionSheet addButtonWithTitle:NSLocalizedString(@"Sign Out", nil)];
		actionSheet.destructiveButtonIndex = [self.multiAccountArray count]+1;

		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:presentingView];

		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];
	};


	void (^RequestingFailed)(void) = ^(void){
		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
	};


	if ([self.multiAccountArray count] > 0) {
		ConfigureActionSheet();
		return;
	}


	NSMutableArray *collectedAccounts = [[NSMutableArray alloc] initWithCapacity:0];

	//TODO: Learn about batch requesting
	[self
	 facebookRequestForMeWithFinishCallback:^(SEL caller, BOOL finished, NSArray *accounts) {
		 FXDLog_BLOCK(self, caller);

		 if ([accounts count] > 0) {
			 [collectedAccounts addObjectsFromArray:accounts];
		 }
		 else {
			 RequestingFailed();
			 return;
		 }


		 [self
		  facebookRequestForAccountsWithFinishCallback:^(SEL caller, BOOL finished, NSArray *accounts) {
			  FXDLog_BLOCK(self, caller);

			  if ([accounts count] > 0) {
				  [collectedAccounts addObjectsFromArray:accounts];
			  }
			  else {
				  RequestingFailed();
				  return;
			  }


			  _multiAccountArray = [collectedAccounts copy];
			  FXDLog(@"_multiAccountArray count: %lu", (unsigned long)[_multiAccountArray count]);

			  if ([self.multiAccountArray count] > 0) {
				  ConfigureActionSheet();
			  }
			  else {
				  RequestingFailed();
			  }
		  }];
	 }];
}

- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromActionSheet:(FXDActionSheet*)actionSheet forButtonIndex:(NSInteger)buttonIndex withFinishCallback:(FXDcallbackFinish)finishCallback {

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	FXDLogVariable(buttonIndex);
	FXDLogVariable(actionSheet.cancelButtonIndex);
	FXDLogVariable(actionSheet.destructiveButtonIndex);


	if (buttonIndex == (NSInteger)[actionSheet performSelector:@selector(cancelButtonIndex)]) {
		_multiAccountArray = nil;

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	NSString *accountObjKey = userdefaultObjMainFacebookAccountIdentifier;


	BOOL didAssignAccount = NO;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	if ([actionSheet isKindOfClass:[UIActionSheet class]]
		&& buttonIndex == [(FXDActionSheet*)actionSheet destructiveButtonIndex]) {

		[self resetCredential];
	}
	else {
		NSDictionary *selectedAccount = (self.multiAccountArray)[buttonIndex-1];
		FXDLog(@"selectedAccount: %@", selectedAccount);

		if (selectedAccount) {
			[userDefaults setObject:selectedAccount forKey:accountObjKey];

			_currentFacebookAccount = selectedAccount;
		}

		[userDefaults synchronize];

		didAssignAccount = YES;
	}

	_multiAccountArray = nil;

	if (finishCallback) {
		finishCallback(_cmd, didAssignAccount, nil);
	}
}

#pragma mark -
- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock {	FXDLog_DEFAULT;

	FBSession *activeSession = [FBSession activeSession];
	FXDLog(@"1.%@ %@ %@ %@", _BOOL(activeSession.isOpen), _Variable(activeSession.state), _Object(activeSession.accessTokenData.accessToken), _Variable(activeSession.accessTokenData.loginType));

	if (activeSession.isOpen) {
		if (requestingBlock) {
			requestingBlock(YES);
		}
		return;
	}


	void (^SessionOpening)(FXDcallbackFinish) = ^(FXDcallbackFinish finishCallback){
		FXDLog(@"SessionOpening: %@", finishCallback);

		[[FBSession activeSession]
		 openWithBehavior:self.sessionLoginBehavior
		 completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
			 FXDLog_BLOCK([FBSession activeSession], @selector(openWithBehavior:completionHandler:));
			 FXDLogVariable(status);
			 FXDLog_ERROR;


			 BOOL shouldRequest = (status == FBSessionStateCreatedOpening
								   || status == FBSessionStateOpen
								   || status == FBSessionStateOpenTokenExtended);
			 FXDLogBOOL(shouldRequest);

			 if (finishCallback) {
				 finishCallback(_cmd, shouldRequest, nil);
			 }
		 }];
	};


	SessionOpening(^(SEL caller, BOOL finished, id responseObj){
		FXDLog(@"SessionOpening %@", _BOOL(finished));
		FXDLog(@"2.%@ %@ %@ %@", _BOOL(activeSession.isOpen), _Variable(activeSession.state), _Object(activeSession.accessTokenData.accessToken), _Variable(activeSession.accessTokenData.loginType));

		if (finished
			|| (activeSession.accessTokenData
				&& activeSession.accessTokenData.loginType != FBSessionLoginTypeSystemAccount)) {

				if (requestingBlock) {
					requestingBlock(finished);
				}
				return;
			}


		[FBSession
		 renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
			 FXDLog_BLOCK(FBSession, @selector(renewSystemCredentials:));
			 FXDLog_ERROR;

			 if (error) {
				 NSString *alertMessage = [error localizedDescription];

				 if ([error code] == 9) {
					 alertMessage = [alertMessage stringByAppendingString:NSLocalizedString(@"\nPlease try again", nil)];
				 }
				 FXDLogObject(alertMessage);

				 [FXDAlertView
				  showAlertWithTitle:nil
				  message:alertMessage
				  cancelButtonTitle:nil
				  withAlertCallback:nil];
			 }

			 BOOL didRenew = (result == ACAccountCredentialRenewResultRenewed);
			 FXDLogBOOL(didRenew);

			 if (didRenew) {
				 SessionOpening(^(SEL caller, BOOL finished, id responseObj){
					 FXDLog(@"SessionOpening finished: %d", finished);

					 if (requestingBlock) {
						 requestingBlock(finished);
					 }
				 });
				 return;
			 }

			 [self resetCredential];
			 
			 if (requestingBlock) {
				 requestingBlock(NO);
			 }
		 }];
	});
}


#pragma mark - Public
- (void)resetCredential {	FXDLog_DEFAULT;
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:userdefaultObjMainFacebookAccountIdentifier];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:userdefaultObjKeyFacebookAccessToken];

	[[FBSession activeSession] closeAndClearTokenInformation];

	_currentFacebookAccount = nil;
	_currentPageAccessToken = nil;
}

#pragma mark -
- (void)startObservingFBSessionNotifications {	FXDLog_DEFAULT;

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidSetActiveSession:)
	 name:FBSessionDidSetActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidUnsetActiveSession:)
	 name:FBSessionDidUnsetActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidBecomeOpenActiveSession:)
	 name:FBSessionDidBecomeOpenActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidBecomeClosedActiveSession:)
	 name:FBSessionDidBecomeClosedActiveSessionNotification
	 object:nil];
}

#pragma mark -
- (BOOL)shouldContinueWithError:(NSError*)error {
	if (error == nil) {
		return YES;
	}


	FXDLog_ERROR;

	NSString *errorMessage = [error userInfo][@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"][@"message"];
	FXDLogObject(errorMessage);

	if (errorMessage.length > 0) {
		[FXDAlertView
		 showAlertWithTitle:nil
		 message:errorMessage
		 cancelButtonTitle:nil
		 withAlertCallback:nil];
	}

	return NO;
}

#pragma mark -
- (void)updateSessionPermissionWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	BOOL canReturnEarly = YES;

	FBSession *activeSession = [FBSession activeSession];
	FXDLogObject(activeSession.permissions);

	if ([activeSession.permissions containsObject:facebookPermissionPublishActions] == NO) {
		canReturnEarly = NO;
	}

	FXDLogBOOL(canReturnEarly);

	if (canReturnEarly) {
		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	NSMutableArray *permissions = [self.additionalAccessOptions[ACFacebookPermissionsKey] mutableCopy];

	[permissions removeObject:facebookPermissionBasicInfo];


	FBSessionDefaultAudience defaultAudience = FBSessionDefaultAudienceNone;

	if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceEveryone]) {
		defaultAudience = FBSessionDefaultAudienceEveryone;
	}
	else if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceFriends]) {
		defaultAudience = FBSessionDefaultAudienceFriends;
	}
	else if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceOnlyMe]) {
		defaultAudience = FBSessionDefaultAudienceOnlyMe;
	}

	[activeSession
	 requestNewPublishPermissions:[permissions copy]
	 defaultAudience:defaultAudience
	 completionHandler:^(FBSession *session, NSError *error) {
		 FXDLog(@"3.%@", _Variable(session.state));
		 FXDLog(@"3.%@", _BOOL(session.isOpen));

		 FXDLog(@"3.%@", _Object(session.permissions));
		 FXDLog(@"3.%@", _Variable(session.accessTokenData.loginType));

		 BOOL shouldContinue = [self shouldContinueWithError:error];

		 if (finishCallback) {
			 finishCallback(_cmd, shouldContinue, nil);
		 }
	 }];
}


#pragma mark -
- (void)facebookRequestForMeWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (shouldContinue == NO) {
				  if (finishCallback) {
					  finishCallback(_cmd, shouldContinue, nil);
				  }
				  return;
			  }


			  NSDictionary *facebookMeInfo =
			  @{objkeyFacebookID:	(result[objkeyFacebookID]) ? result[objkeyFacebookID]:@"",
				objkeyFacebookName:	(result[objkeyFacebookName]) ? result[objkeyFacebookName]:@"",
				objkeyFacebookUsername:	(result[objkeyFacebookUsername]) ? result[objkeyFacebookUsername]:@""};

			  if (finishCallback) {
				  NSArray *accounts = @[facebookMeInfo];

				  finishCallback(_cmd, shouldContinue, accounts);
			  }
		  }];
	 }];
}

- (void)facebookRequestForAccountsWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startWithGraphPath:facebookGraphMeAccounts
		  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (finishCallback) {
				  finishCallback(_cmd, shouldContinue, [result[@"data"] copy]);
			  }
		  }];
	 }];
}

- (void)facebookRequestPageAccessTokenWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLog(@"1.%@", _Object(self.currentPageAccessToken));

	if (self.currentPageAccessToken.length > 0) {
		if (finishCallback) {
			finishCallback(_cmd, YES, self.currentPageAccessToken);
		}
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }



		 NSString *facebookPageId = self.currentFacebookAccount[objkeyFacebookID];

		 NSString *graphPath = [NSString stringWithFormat:@"/%@?fields=access_token", facebookPageId];
		 FXDLogObject(graphPath);

		 
		 //NOTE: MainQueue is necessaryfor safe requesting
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{

			  FXDAssert_IsMainThread;

			  [FBRequestConnection
			   startWithGraphPath:graphPath
			   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
				   FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:completionHandler:));
				   FXDLog(@"result[\"%@\"]: %@", objkeyFacebookAccessToken, result[objkeyFacebookAccessToken]);

				   BOOL shouldContinue = [self shouldContinueWithError:error];

				   if (shouldContinue) {
					   self.currentPageAccessToken = [result[objkeyFacebookAccessToken] copy];
				   }
				   else {
					   self.currentPageAccessToken = nil;
				   }

				   FXDLog(@"2.%@", _Object(self.currentPageAccessToken));
				   
				   if (finishCallback) {
					   finishCallback(_cmd, shouldContinue, self.currentPageAccessToken);
				   }
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)facebookRequestToPostWithMessage:(NSString*)message withMediaLink:(NSString*)mediaLink atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(message), _Object(mediaLink));

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 void (^PostWithLink)(NSString*) = ^(NSString *placeId){	FXDLog_DEFAULT;
			 FXDLog(@"PostWithLink: %@", _Object(placeId));

			 NSString *facebookId = self.currentFacebookAccount[objkeyFacebookID];
			 NSString *graphPath = [NSString stringWithFormat:facebookGraphProfileFeed, facebookId];
			 FXDLogObject(graphPath);


			 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
			 if (message) {parameters[@"message"] = message;}
			 if (mediaLink) {parameters[@"link"] = mediaLink;}
			 if (placeId) {parameters[@"place"] = placeId;}


			 NSString *pageCategory = self.currentFacebookAccount[objkeyFacebookCategory];
			 FXDLogObject(pageCategory);

			 if (pageCategory.length == 0) {
				 parameters[objkeyFacebookAccessToken] = [FBSession activeSession].accessTokenData.accessToken;

				 FXDLog(@"1.PostWithLink parameters: %@", parameters);

				 FXDAssert_IsMainThread;

				 [FBRequestConnection
				  startWithGraphPath:graphPath
				  parameters:parameters
				  HTTPMethod:@"POST"
				  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
					  FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:parameters:HTTPMethod:completionHandler:));
					  FXDLog(@"PostWithLink result: %@", result);

					  BOOL shouldContinue = [self shouldContinueWithError:error];

					  if (finishCallback) {
						  finishCallback(_cmd, shouldContinue, nil);
					  }
				  }];

				 return;
			 }


			 //http://stackoverflow.com/a/18279372/259765
			 [self
			  facebookRequestPageAccessTokenWithFinishCallback:^(SEL caller, BOOL finished, NSString *pageAccessToken) {
				  FXDLog_BLOCK(self, caller);
				  FXDLogBOOL(finished);

				  FXDLogObject(pageAccessToken);

				  if (finished == NO
					  || self.currentPageAccessToken.length == 0) {

					  if (finishCallback) {
						  finishCallback(_cmd, NO, nil);
					  }
					  return;
				  }


				  parameters[objkeyFacebookAccessToken] = self.currentPageAccessToken;
				  FXDLog(@"2.PostWithLink parameters: %@", parameters);

				  NSError *error = nil;
				  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
												  requestWithMethod:@"POST"
												  URLString:urlstringFacebook(graphPath)
												  parameters:parameters
												  error:&error];FXDLog_ERROR;
				  FXDLogObject(request);

				  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
				  operation.responseSerializer = [AFJSONResponseSerializer serializer];

				  [operation
				   setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
					   FXDLogObject(responseObject);

					   if (finishCallback) {
						   finishCallback(_cmd, YES, nil);
					   }
				   }
				   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					   FXDLog_ERROR;

					   if (finishCallback) {
						   finishCallback(_cmd, NO, nil);
					   }
				   }];

				  [operation start];
			  }];
		 };


		 if (latitude == 0.0 && longitude == 0.0) {
			 PostWithLink(nil);
			 return;
		 }


		 NSString *graphPath = @"search";

		 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
		 parameters[objkeyFacebookAccessToken] = [FBSession activeSession].accessTokenData.accessToken;
		 parameters[@"type"] = @"place";
		 parameters[@"center"] = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
		 parameters[@"distance"] = [NSString stringWithFormat:@"%@", @(kCLLocationAccuracyKilometer)];

		 FXDLogObject(parameters);

		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startWithGraphPath:graphPath
		  parameters:parameters
		  HTTPMethod:@"GET"
		  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			  FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:parameters:HTTPMethod:completionHandler:));

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (shouldContinue == NO) {
				  if (finishCallback) {
					  finishCallback(_cmd, shouldContinue, nil);
				  }
				  return;
			  }


			  NSString *placeId = nil;

			  //TODO: Check if distance sorting is necessary

			  for (NSDictionary *place in result[@"data"]) {

				  if (placeId == nil) {
					  placeId = place[objkeyFacebookID];
					  FXDLog(@"%@ %@", _Object(placeId), _Object(place[objkeyFacebookName]));
					  break;
				  }
			  }
			  
			  PostWithLink(placeId);
		  }];
	 }];
}


#pragma mark - Observer
- (void)observedACAccountStoreDidChange:(NSNotification*)notification {
	[super observedACAccountStoreDidChange:notification];

	ACAccountStore *accountStore = [notification object];

	for (ACAccount *account in accountStore.accounts) {
		ACAccountType *accountType = account.accountType;

		if ([accountType.identifier isEqualToString:self.typeIdentifier]
			|| [accountType.accountTypeDescription isEqualToString:self.typeIdentifier]) {

			if (accountType.accessGranted) {
				return;
			}
		}
	}


	[self resetCredential];
}

#pragma mark -
- (void)observedFBSessionDidSetActiveSession:(NSNotification*)notification {
}

- (void)observedFBSessionDidUnsetActiveSession:(NSNotification*)notification {
}

- (void)observedFBSessionDidBecomeOpenActiveSession:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

- (void)observedFBSessionDidBecomeClosedActiveSession:(NSNotification*)notification {	FXDLog_DEFAULT;
}

#pragma mark - Delegate

@end