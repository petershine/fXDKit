//
//  FXDsuperSocialManager.m
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperSocialManager.h"


#pragma mark - Public implementation
@implementation FXDsuperSocialManager


#pragma mark - Memory management

#pragma mark - Initialization
+ (FXDsuperSocialManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (NSString*)reasonForTwitterAccount {
	if (_reasonForTwitterAccount == nil) {	FXDLog_OVERRIDE;
		_reasonForTwitterAccount = NSLocalizedString(@"Please go to device's Settings and add your Twitter account", nil);
	}

	return _reasonForTwitterAccount;
}

- (NSString*)reasonForFacebookAccount {
	if (_reasonForFacebookAccount == nil) {	FXDLog_OVERRIDE;
		_reasonForFacebookAccount = NSLocalizedString(@"Please go to device's Settings and add your Facebook account", nil);
	}

	return _reasonForFacebookAccount;
}

#pragma mark -
- (NSDictionary*)accountAccessOptions {
	if (_accountAccessOptions == nil) {
		FXDLog_OVERRIDE;
	}

	return _accountAccessOptions;
}

#pragma mark -
- (ACAccountStore*)accountStore {
	if (_accountStore == nil) {
		_accountStore = [[ACAccountStore alloc] init];
	}

	return _accountStore;
}

#pragma mark -
- (ACAccountType*)twitterAccountType {
	if (_twitterAccountType == nil) {
		_twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	}

	return _twitterAccountType;
}

- (NSArray*)twitterAccountArray {
	if (_twitterAccountArray == nil) {
		_twitterAccountArray = [self.accountStore accountsWithAccountType:self.twitterAccountType];
	}

	return _twitterAccountArray;
}

- (ACAccount*)mainTwitterAccount {

	if (_mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		__block NSString *identifier = [userDefaults stringForKey:userdefaultObjKeyMainTwitterAccountIdentifier];

		FXDLog(@"identifier: %@", identifier);

		if (identifier) {

			if (self.twitterAccountType.accessGranted) {
				_mainTwitterAccount = [self.accountStore accountWithIdentifier:identifier];
			}
			else {
				identifier = nil;
			}
		}


		if (identifier) {
			[userDefaults setObject:identifier forKey:userdefaultObjKeyMainTwitterAccountIdentifier];
		}
		else {
			[userDefaults removeObjectForKey:userdefaultObjKeyMainTwitterAccountIdentifier];
		}

		[userDefaults synchronize];
		FXDLog(@"_mainTwitterAccount: %@", _mainTwitterAccount);
	}

	return _mainTwitterAccount;
}

#pragma mark -
- (ACAccountType*)facebookAccountType {
	if (_facebookAccountType == nil) {
		_facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
	}

	return _facebookAccountType;
}

- (NSArray*)facebookAccountArray {
	if (_facebookAccountArray == nil) {
		_facebookAccountArray = [self.accountStore accountsWithAccountType:self.facebookAccountType];
	}

	return _facebookAccountArray;
}

- (ACAccount*)mainFacebookAccount {

	if (_mainFacebookAccount == nil) {	FXDLog_DEFAULT;
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

		__block NSString *identifier = [userDefaults stringForKey:userdefaultObjKeyMainFacebookAccountIdentifier];

		FXDLog(@"identifier: %@", identifier);

		if (identifier) {

			if (self.facebookAccountType.accessGranted) {
				_mainFacebookAccount = [self.accountStore accountWithIdentifier:identifier];
			}
			else {
				identifier = nil;
			}
		}


		if (identifier) {
			[userDefaults setObject:identifier forKey:userdefaultObjKeyMainFacebookAccountIdentifier];
		}
		else {
			[userDefaults removeObjectForKey:userdefaultObjKeyMainFacebookAccountIdentifier];
		}

		[userDefaults synchronize];
		FXDLog(@"_mainFacebookAccount: %@", _mainFacebookAccount);
	}

	return _mainFacebookAccount;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	ACAccountType *accountType = nil;

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		accountType = self.twitterAccountType;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		accountType = self.facebookAccountType;
	}


	FXDLog(@"accountType.accountTypeDescription: %@", accountType.accountTypeDescription);
	FXDLog(@"accountType.accessGranted: %d", accountType.accessGranted);
	
	if (accountType.accessGranted) {
		[self
		 showActionSheetInPresentingView:presentingView
		 forSelectingAccountForTypeIdentifier:typeIdentifier
		 withDidFinishBlock:didFinishBlock];
		return;
	}
	
	
	[self.accountStore
	 requestAccessToAccountsWithType:accountType
	 options:self.accountAccessOptions
	 completion:^(BOOL granted, NSError *error) {
		 FXDLog(@"granted: %d", granted);
		 
		 FXDLog_ERROR;
		 
		 if (granted) {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  [self
				   showActionSheetInPresentingView:presentingView
				   forSelectingAccountForTypeIdentifier:typeIdentifier
				   withDidFinishBlock:didFinishBlock];
			  }];
		 }
		 else {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  NSString *alertTitle = nil;
				  NSString *alertMessage = nil;

				  if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
					  alertTitle = NSLocalizedString(@"Please grant Twitter access in Settings", nil);
					  alertMessage = self.reasonForTwitterAccount;
				  }
				  else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
					  alertTitle = NSLocalizedString(@"Please grant Facebook access in Settings", nil);
					  alertMessage = self.reasonForFacebookAccount;
				  }

				  [FXDAlertView
				   showAlertWithTitle:alertTitle
				   message:alertMessage
				   clickedButtonAtIndexBlock:nil
				   cancelButtonTitle:nil];

				  if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
					  _twitterAccountType = nil;
				  }
				  else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
					  _facebookAccountType = nil;
				  }

				  if (didFinishBlock) {
					  didFinishBlock(NO);
				  }
			  }];
		 }
	 }];
}

- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	NSArray *accountArray = nil;

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		accountArray = self.twitterAccountArray;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		accountArray = self.facebookAccountArray;
	}


	FXDLog(@"accountArray:\n%@", accountArray);
	
	if ([accountArray count] == 0) {
		NSString *alertTitle = nil;
		NSString *alertMessage = nil;

		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			_twitterAccountArray = nil;

			alertTitle = NSLocalizedString(@"Please sign up for a Twitter account", nil);
			alertMessage = self.reasonForTwitterAccount;
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			_facebookAccountArray = nil;

			alertTitle = NSLocalizedString(@"Please sign up for a Facebook account", nil);
			alertMessage = self.reasonForFacebookAccount;
		}

		[FXDAlertView
		 showAlertWithTitle:alertTitle
		 message:alertMessage
		 clickedButtonAtIndexBlock:nil
		 cancelButtonTitle:nil];

		if (didFinishBlock) {
			didFinishBlock(NO);
		}
		return;
	}


	NSString *actionsheetTitle = nil;

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Twitter Account", nil);
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		actionsheetTitle = NSLocalizedString(@"Please select your Facebook Account", nil);
	}

	FXDActionSheet *actionSheet =
	[[FXDActionSheet alloc]
	 initWithTitle:actionsheetTitle
	 clickedButtonAtIndexBlock:^(id alertObj, NSInteger buttonIndex) {
		 [self
		  selectAccountForTypeIdentifier:typeIdentifier
		  fromAlertObj:alertObj
		  forButtonIndex:buttonIndex
		  withDidFinishBlock:didFinishBlock];
		 
	 } withButtonTitleArray:nil
	 cancelButtonTitle:nil
	 destructiveButtonTitle:nil
	 otherButtonTitles:nil];
	
	[actionSheet addButtonWithTitle:NSLocalizedString(text_Cancel, nil)];
	actionSheet.cancelButtonIndex = 0;
	
	for (ACAccount *account in accountArray) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
	}
	
	[actionSheet addButtonWithTitle:NSLocalizedString(text_SignOut, nil)];
	actionSheet.destructiveButtonIndex = [accountArray count]+1;
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:presentingView];
}

#pragma mark -
- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromAlertObj:(id)actionSheet forButtonIndex:(NSInteger)buttonIndex withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

#if ForDEVELOPER
	FXDLog(@"buttonIndex: %ld", (long)buttonIndex);
	FXDLog(@"cancelButtonIndex: %ld", (long)[actionSheet performSelector:@selector(cancelButtonIndex)]);
	
	if ([actionSheet isKindOfClass:[UIActionSheet class]]) {
		FXDLog(@"destructiveButtonIndex: %ld", (long)[(FXDActionSheet*)actionSheet destructiveButtonIndex]);
	}
#endif
	
	if (buttonIndex == (NSInteger)[actionSheet performSelector:@selector(cancelButtonIndex)]) {
		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			_twitterAccountArray = nil;
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			_facebookAccountArray = nil;
		}

		if (didFinishBlock) {
			didFinishBlock(NO);
		}
		return;
	}


	NSString *accountObjKey = @"";

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		accountObjKey = userdefaultObjKeyMainTwitterAccountIdentifier;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		accountObjKey = userdefaultObjKeyMainFacebookAccountIdentifier;
	}


	BOOL finishedWithAccount = NO;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([actionSheet isKindOfClass:[UIActionSheet class]]
		&& buttonIndex == [(FXDActionSheet*)actionSheet destructiveButtonIndex]) {
		
		[userDefaults removeObjectForKey:accountObjKey];

		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			_mainTwitterAccount = nil;
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			_mainFacebookAccount = nil;
		}
	}
	else {
		NSArray *accountArray = nil;

		if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
			accountArray = self.twitterAccountArray;
		}
		else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
			accountArray = self.facebookAccountArray;
		}

		ACAccount *selectedAccount = (accountArray)[buttonIndex-1];
		FXDLog(@"selectedAccount: %@", selectedAccount);
		
		if (selectedAccount) {
			[userDefaults setObject:selectedAccount.identifier forKey:accountObjKey];

			if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
				_mainTwitterAccount = selectedAccount;
				
#if ForDEVELOPER
				[self twitterUserShowWithScreenName:_mainTwitterAccount.username];
#endif
			}
			else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
				_mainFacebookAccount = selectedAccount;

#if ForDEVELOPER
				[self facebookRequestForFacebookUserId:nil];
#endif
			}
		}
		
		[userDefaults synchronize];

		finishedWithAccount = YES;
	}

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		_twitterAccountArray = nil;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		_facebookAccountArray = nil;
	}

	if (didFinishBlock) {
		didFinishBlock(finishedWithAccount);
	}
}

#pragma mark -
- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(void))requestingBlock {

	ACAccount *mainAccount = nil;

	if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
		mainAccount = self.mainTwitterAccount;
	}
	else if ([typeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
		mainAccount = self.mainFacebookAccount;
	}

	if (mainAccount.username == nil) {
		[self.accountStore
		 renewCredentialsForAccount:mainAccount
		 completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
			 FXDLog_ERROR;
			 
			 FXDLog(@"renewResult: %ld", (long)renewResult);
			 
			 if (renewResult == ACAccountCredentialRenewResultRenewed) {
				 if (requestingBlock) {
					 requestingBlock();
				 }
			 }
			 else {
				 //TODO: alert user about needing to have accessibility
			 }
		 }];
	}
	else {
		if (requestingBlock) {
			requestingBlock();
		}
	}
}

#pragma mark -
- (SLComposeViewController*)socialComposeControllerForServiceIdentifier:(NSString*)serviceIdentifier withInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;

	SLComposeViewController *socialComposeController = nil;

	if ([SLComposeViewController isAvailableForServiceType:serviceIdentifier] == NO) {

		NSString *alertTitle = nil;
		NSString *alertMessage = nil;

		if ([serviceIdentifier isEqualToString:SLServiceTypeTwitter]) {
			alertTitle = NSLocalizedString(@"Please connect to Twitter", nil);
			alertMessage = self.reasonForTwitterAccount;
		}
		else if ([serviceIdentifier isEqualToString:SLServiceTypeFacebook]) {
			alertTitle = NSLocalizedString(@"Please connect to Facebook", nil);
			alertMessage = self.reasonForFacebookAccount;
		}

		
		[FXDAlertView
		 showAlertWithTitle:alertTitle
		 message:alertMessage
		 clickedButtonAtIndexBlock:nil
		 cancelButtonTitle:nil];
		
		return nil;
	}


	socialComposeController = [SLComposeViewController composeViewControllerForServiceType:serviceIdentifier];

	if (initialText) {
		if ([socialComposeController setInitialText:initialText] == NO) {
			FXDLog(@"initialText: %@", initialText);
		}
	}

	if ([imageArray count] > 0) {
		for (UIImage *image in imageArray) {
			if ([socialComposeController addImage:image] == NO) {
				FXDLog(@"image: %@", image);
			}
		}
	}

	if ([URLarray count] > 0) {
		for (NSURL *url in URLarray) {
			if ([socialComposeController addURL:url] == NO) {
				FXDLog(@"URL: %@", url);
			}
		}
	}

	return socialComposeController;
}


#if ForDEVELOPER
- (void)evaluateResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error {
	FXDLog_ERROR;

	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger statusCode = [(NSHTTPURLResponse*)urlResponse statusCode];
		NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
		FXDLog(@"httpResponse: %ld : %@", (long)statusCode, statusCodeDescription);

		FXDLog(@"allHeaderFields:\n%@", [(NSHTTPURLResponse*)urlResponse allHeaderFields]);
	}

	FXDLog(@"responseData length: %lu bytes", (unsigned long)[responseData length]);

	if ([responseData length] > 0) {
		id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		FXDLog(@"jsonObj: %@\n %@", [jsonObj class], jsonObj);
	}
}
#endif


//MARK: - Observer implementation

//MARK: - Delegate implementation
	
@end


@implementation FXDsuperSocialManager (Twitter)
- (void)twitterUserShowWithScreenName:(NSString*)screenName {

	if (self.mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierTwitter
	 withRequestingBlock:^{
		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserShow];

		 NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};

		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

		 defaultRequest.account = self.mainTwitterAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}

- (void)twitterStatusUpdateWithTweetText:(NSString*)tweetText atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude {

	if (self.mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierTwitter
	 withRequestingBlock:^{
		 NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];

		 NSMutableDictionary *parameters = [@{objkeyTwitterStatus: tweetText
											  } mutableCopy];

		 if (latitude != 0.0 && longitude != 0.0) {
			 parameters[objkeyTwitterLat] = @(latitude);
			 parameters[objkeyTwitterLong] = @(longitude);
		 }


		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:parameters];

		 defaultRequest.account = self.mainTwitterAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}

@end


@implementation FXDsuperSocialManager (Facebook)
- (void)facebookRequestForFacebookUserId:(NSString*)facebookUserId {
	if (self.mainFacebookAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainFacebookAccount: %@", self.mainFacebookAccount);
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:ACAccountTypeIdentifierFacebook
	 withRequestingBlock:^{
		 NSURL *requestURL = nil;

		 if ([facebookUserId length] > 0) {
			 requestURL = [NSURL URLWithString:urlstringFacebook(facebookUserId)];
		 }
		 else {
			 requestURL = [NSURL URLWithString:urlstringFacebookUserMe];
		 }


		 NSDictionary *parameters = nil;

		 SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

		 defaultRequest.account = self.mainFacebookAccount;

		 [defaultRequest
		  performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			  [self evaluateResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		  }];
	 }];
}
@end