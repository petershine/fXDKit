//
//  FXDmoduleSocial.m
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDmoduleSocial.h"


@implementation FXDmoduleSocial

#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(observedACAccountStoreDidChange:)
		 name:ACAccountStoreDidChangeNotification
		 object:nil];
	}

	return self;
}


#pragma mark - Property overriding
- (NSString*)typeIdentifier {
	if (_typeIdentifier == nil) {
		FXDLog_OVERRIDE;
	}
	return _typeIdentifier;
}

- (NSString*)reasonForConnecting {
	if (_reasonForConnecting == nil) {
		FXDLog_OVERRIDE;
	}
	return _reasonForConnecting;
}

- (NSDictionary*)initialAccessOptions {
	if (_initialAccessOptions == nil) {
		FXDLog_OVERRIDE;
	}
	return _initialAccessOptions;
}

- (NSDictionary*)additionalAccessOptions {
	if (_additionalAccessOptions == nil) {
		FXDLog_OVERRIDE;
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
- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

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


	FXDLogObject(self.mainAccountType.accountTypeDescription);
	FXDLogVariable(self.mainAccountType.accessGranted);

	void (^GrantedAccess)(void) = ^(void){
		[self
		 showActionSheetInPresentingView:presentingView
		 forSelectingAccountForTypeIdentifier:typeIdentifier
		 withFinishCallback:finishCallback];
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

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
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
	
	if ([self.multiAccountArray count] == 0) {
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
	actionSheet.destructiveButtonIndex = [self.multiAccountArray count]+1;
	
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
- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock {

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

	if ([imageArray count] > 0) {
		for (UIImage *image in imageArray) {
			if ([socialComposeController addImage:image] == NO) {
				FXDLogObject(image);
			}
		}
	}

	if ([URLarray count] > 0) {
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


//MARK: - Observer implementation
- (void)observedACAccountStoreDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);

#if	ForDEVELOPER
	ACAccountStore *accountStore = [notification object];

	for (ACAccount *account in accountStore.accounts) {
		FXDLog(@"%@ %@ %@", _Object(account.accountType.accountTypeDescription), _Object(account.username), _BOOL(account.accountType.accessGranted));
	}
#endif
}

//MARK: - Delegate implementation
	
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
		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserShow];

		 NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};

		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

		 defaultRequest.account = self.currentMainAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
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
		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];

		 NSMutableDictionary *parameters = [@{objkeyTwitterStatus: tweetText
											  } mutableCopy];

		 if (latitude != 0.0 && longitude != 0.0) {
			 parameters[objkeyTwitterLat] = @(latitude);
			 parameters[objkeyTwitterLong] = @(longitude);
		 }


		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:parameters];

		 defaultRequest.account = self.currentMainAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
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
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}
@end