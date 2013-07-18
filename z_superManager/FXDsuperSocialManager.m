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
- (void)dealloc {
	//GUIDE: Remove observer, Deallocate timer, Nilify delegates, etc
}


#pragma mark - Initialization
+ (FXDsuperSocialManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (ACAccountStore*)accountStore {
	if (_accountStore == nil) {
		_accountStore = [[ACAccountStore alloc] init];
	}

	return _accountStore;
}

- (ACAccountType*)accountType {
	if (_accountType == nil) {
		_accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	}

	return _accountType;
}

- (NSArray*)twitterAccountArray {
	if (_twitterAccountArray == nil) {
		_twitterAccountArray = [self.accountStore accountsWithAccountType:self.accountType];
	}

	return _twitterAccountArray;
}

- (ACAccount*)mainTwitterAccount {	FXDLog_DEFAULT;

	if (_mainTwitterAccount == nil) {
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		__block NSString *identifier = [userDefaults stringForKey:userdefaultObjKeyMainAccountIdentifier];

		FXDLog(@"accountIdentifier: %@", identifier);

		if (identifier) {

			if (self.accountType.accessGranted) {
				_mainTwitterAccount = [self.accountStore accountWithIdentifier:identifier];
			}
			else {
				identifier = nil;
			}
		}


		if (identifier) {
			[userDefaults setObject:identifier forKey:userdefaultObjKeyMainAccountIdentifier];
		}
		else {
			[userDefaults removeObjectForKey:userdefaultObjKeyMainAccountIdentifier];
		}

		[userDefaults synchronize];
	}

	FXDLog(@"_mainTwitterAccount: %@", _mainTwitterAccount);

	return _mainTwitterAccount;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)signInBySelectingTwitterAccountWithDidFinishBlock:(void(^)(BOOL finished))didFinishBlock {	FXDLog_DEFAULT;
	FXDLog(@"accountType.accountTypeDescription: %@", self.accountType.accountTypeDescription);
	FXDLog(@"accountType.accessGranted: %d", self.accountType.accessGranted);
	
	if (self.accountType.accessGranted) {
		[self showAlertViewForSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
	}
	else {
		[self.accountStore
		 requestAccessToAccountsWithType:self.accountType
		 options:nil
		 completion:^(BOOL granted, NSError *error) {
			 FXDLog(@"granted: %d", granted);

			 FXDLog_ERROR;

			 if (granted) {
				 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
					 [self showAlertViewForSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
				 }];
			 }
		 }];
	}
}

- (void)showAlertViewForSelectingTwitterAccountWithDidFinishBlock:(void(^)(BOOL finished))didFinishBlock {	FXDLog_DEFAULT;
	FXDLog(@"self.twitterAccountArray:\n%@", self.twitterAccountArray);

	if ([self.twitterAccountArray count] == 0) {
		//MARK: If no Twitter account is signed up... alert user
		if (didFinishBlock) {
			didFinishBlock(NO);
		}
		
		return;
	}


	NSString *alertTitle = NSLocalizedString(alert_SelectTwitterAccount, nil);
	NSString *alertMessage = NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil);
	NSString *cancelButtonTitle = NSLocalizedString(text_Cancel, nil);

	if (self.mainTwitterAccount) {
		cancelButtonTitle = NSLocalizedString(text_SignOut, nil);
	}


	FXDAlertView *alertView =
	[[FXDAlertView alloc]
	 initWithTitle:alertTitle
	 message:alertMessage
	 clickedButtonAtIndexBlock:^(id alertView, NSInteger buttonIndex) {
		 FXDLog(@"buttonIndex: %d", buttonIndex);
		 
		 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		 
		 if (buttonIndex != [(FXDAlertView*)alertView cancelButtonIndex]) {	FXDLog_DEFAULT;
			 
			 ACAccount *selectedTwitterAccount = (self.twitterAccountArray)[buttonIndex];
			 FXDLog(@"selectedTwitterAccount: %@", selectedTwitterAccount);
			 
			 if (selectedTwitterAccount) {
				 [userDefaults setObject:selectedTwitterAccount.identifier forKey:userdefaultObjKeyMainAccountIdentifier];
				 
				 _mainTwitterAccount = selectedTwitterAccount;
				 
#if ForDEVELOPER
				 [self userLookUpWithScreenName:_mainTwitterAccount.username];
#endif
			 }
		 }
		 else {
			 [userDefaults removeObjectForKey:userdefaultObjKeyMainAccountIdentifier];
			 
			 _mainTwitterAccount = nil;
		 }
		 
		 [userDefaults synchronize];
		 
		 _twitterAccountArray = nil;
		 
		 if (didFinishBlock) {
			 didFinishBlock(YES);
		 }
	 }
	 cancelButtonTitle:nil
	 otherButtonTitles:nil];
	

	for (ACAccount *twitterAccount in self.twitterAccountArray) {
		FXDLog(@"twitterAccount.username: %@", twitterAccount.username);

		[alertView addButtonWithTitle:[NSString stringWithFormat:@"@%@", twitterAccount.username]];
	}

	[alertView addButtonWithTitle:cancelButtonTitle];
	alertView.cancelButtonIndex = [self.twitterAccountArray count];

	[alertView show];
}

- (void)userLookUpWithScreenName:(NSString*)screenName {
	
	NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserLookUp];
	
	NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};

	SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];

	[defaultRequest
	 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
		 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif		 
	 }];
}

- (void)statusUpdateWithTweetText:(NSString*)tweetText {
	
	if (self.mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);

		return;
	}


	void (^credentialRequestingBlock)() = ^{
		NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];

		NSDictionary *parameters = @{objkeyTwitterStatus: tweetText};

		SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:parameters];

		defaultRequest.account = self.mainTwitterAccount;

		[defaultRequest
		 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		 }];
	};

	
	if (self.mainTwitterAccount.username == nil) {
		[self.accountStore
		 renewCredentialsForAccount:self.mainTwitterAccount
		 completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
			 FXDLog_ERROR;LOGEVENT_ERROR;

			 FXDLog(@"renewResult: %d", renewResult);

			 if (renewResult == ACAccountCredentialRenewResultRenewed) {
				 credentialRequestingBlock();
			 }
			 else {
				 //TODO: alert user about needing to have accessibility
			 }
		 }];
	}
	else {
		credentialRequestingBlock();
	}
}

- (SLComposeViewController*)socialComposeControllerWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;

	SLComposeViewController *socialComposeController = nil;

	//TODO: Test Facebook interface
	if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] == NO) {
		return socialComposeController;
	}


	socialComposeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

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
- (void)logTwitterResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error {
	FXDLog_ERROR;

	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger statusCode = [(NSHTTPURLResponse*)urlResponse statusCode];
		NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
		FXDLog(@"httpResponse: %d : %@", statusCode, statusCodeDescription);

		FXDLog(@"allHeaderFields:\n%@", [(NSHTTPURLResponse*)urlResponse allHeaderFields]);
	}

	FXDLog(@"responseData.length: %d bytes", responseData.length);

	id parsedObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
	FXDLog(@"parsedObject: %@\n %@", [parsedObject class], parsedObject);
}
#endif


//MARK: - Observer implementation

//MARK: - Delegate implementation
	
@end
