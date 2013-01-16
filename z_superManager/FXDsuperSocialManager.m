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
	// Instance variables

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
		NSString *identifier = [[NSUserDefaults standardUserDefaults] stringForKey:userdefaultObjKeyMainAccountIdentifier];

		FXDLog(@"accountIdentifier: %@", identifier);

		if (identifier) {

			if (self.accountType.accessGranted) {
				_mainTwitterAccount = [self.accountStore accountWithIdentifier:identifier];
			}
			else {
				identifier = nil;
			}
		}

		[[NSUserDefaults standardUserDefaults] setObject:identifier forKey:userdefaultObjKeyMainAccountIdentifier];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

	FXDLog(@"_mainTwitterAccount: %@", _mainTwitterAccount);

	return _mainTwitterAccount;
}


#pragma mark - Method overriding


#pragma mark - Public
- (void)signInBySelectingTwitterAccount {	FXDLog_DEFAULT;	
	FXDLog(@"accountType.accountTypeDescription: %@", self.accountType.accountTypeDescription);
	FXDLog(@"accountType.accessGranted: %d", self.accountType.accessGranted);
	
	if (self.accountType.accessGranted) {
		[self showAlertViewForSelectingTwitterAccount];
	}
	else {
		if ([FXDsuperGlobalManager isSystemVersionLatest]) {
			[self.accountStore
			 requestAccessToAccountsWithType:self.accountType
			 options:nil
			 completion:^(BOOL granted, NSError *error) {
				 FXDLog(@"granted: %d", granted);
				 
				 FXDLog_ERROR;
				 
				 if (granted) {
					 [self showAlertViewForSelectingTwitterAccount];
				 }
			 }];
		}
		else {
#if ENVIRONMENT_newestSDK
#else
			[self.accountStore
			 requestAccessToAccountsWithType:self.accountType
			 withCompletionHandler:^(BOOL granted, NSError *error) {
				 FXDLog(@"granted: %d", granted);

				 FXDLog_ERROR;

				 if (granted) {
					 [self showAlertViewForSelectingTwitterAccount];
				 }
			 }];
#endif
		}
	}
}

- (void)showAlertViewForSelectingTwitterAccount {	FXDLog_DEFAULT;
	
	if ([self.twitterAccountArray count] == 0) {
		//If no Twitter account is signed up... alert user
		//Following is not working
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
		
		return;
	}


	NSString *alertTitle = NSLocalizedString(alert_SelectTwitterAccount, nil);
	NSString *alertMessage = NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil);
	NSString *cancelButtonTitle = NSLocalizedString(text_Cancel, nil);

	if (self.mainTwitterAccount) {
		alertTitle = NSLocalizedString(alert_SelectTwitterAccount, nil);
		alertMessage = NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil);
		cancelButtonTitle = NSLocalizedString(text_SignOut, nil);
	}


	FXDAlertView *alertView =
	[[FXDAlertView alloc]
	 initWithTitle:alertTitle
	 message:alertMessage
	 clickedButtonAtIndexBlock:^(FXDAlertView *alertView, NSInteger buttonIndex) {
		 FXDLog(@"buttonIndex: %d", buttonIndex);

		 _mainTwitterAccount = nil;

		 NSString *identifier = nil;

		 if (buttonIndex != alertView.cancelButtonIndex) {

			 _mainTwitterAccount = (self.twitterAccountArray)[buttonIndex];

			 identifier = _mainTwitterAccount.identifier;
#if ForDEVELOPER
			 [self userLookUpWithScreenName:self.mainTwitterAccount.username];
#endif
		 }

		 [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:userdefaultObjKeyMainAccountIdentifier];
		 [[NSUserDefaults standardUserDefaults] synchronize];

		 _twitterAccountArray = nil;
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

#if ENVIRONMENT_newestSDK
	SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
#else
	TWRequest *defaultRequest = [[TWRequest alloc] initWithURL:requestURL
												parameters:parameters
											 requestMethod:TWRequestMethodGET];
#endif
	
	[defaultRequest
	 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
		 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif		 
	 }];
}

- (void)statusUpdateWithStatus:(NSString*)status {
	
	if (self.mainTwitterAccount) {
		NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];

		NSDictionary *parameters = @{objkeyTwitterStatus: status};

#if ENVIRONMENT_newestSDK
		SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:parameters];
#else
		TWRequest *defaultRequest = [[TWRequest alloc] initWithURL:requestURL
													parameters:parameters
												 requestMethod:TWRequestMethodPOST];
#endif
		
		defaultRequest.account = self.mainTwitterAccount;
		
		[defaultRequest
		 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif		 
		 }];
	}
	else {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);
	}
}

#if ENVIRONMENT_newestSDK
- (SLComposeViewController*)socialComposeInterfaceWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;

	SLComposeViewController *socialComposeInterface = nil;

	if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] == NO) {
#warning "//TODO: test facebook"

		return socialComposeInterface;
	}


	socialComposeInterface = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

#else
- (TWTweetComposeViewController*)socialComposeInterfaceWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;

	TWTweetComposeViewController *socialComposeInterface = nil;
	
	if ([TWTweetComposeViewController canSendTweet] == NO) {
		//TODO: notify

		return socialComposeInterface;
	}


	socialComposeInterface = [[TWTweetComposeViewController alloc] init];
	
#endif

	if (initialText) {
		if ([socialComposeInterface setInitialText:initialText] == NO) {
			FXDLog(@"initialText: %@", initialText);
		}
	}

	if ([imageArray count] > 0) {
		for (UIImage *image in imageArray) {
			if ([socialComposeInterface addImage:image] == NO) {
				FXDLog(@"image: %@", image);
			}
		}
	}

	if ([URLarray count] > 0) {
		for (NSURL *url in URLarray) {
			if ([socialComposeInterface addURL:url] == NO) {
				FXDLog(@"URL: %@", url);
			}
		}
	}

	return socialComposeInterface;
}

- (void)logTwitterResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error {
	FXDLog_ERROR;

#if ForDEVELOPER
	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		NSInteger statusCode = [(NSHTTPURLResponse*)urlResponse statusCode];
		NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
		FXDLog(@"httpResponse: %d : %@", statusCode, statusCodeDescription);

		FXDLog(@"allHeaderFields:\n%@", [(NSHTTPURLResponse*)urlResponse allHeaderFields]);
	}

	FXDLog(@"responseData.length: %d bytes", responseData.length);

	id parsedObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
	FXDLog(@"parsedObject: %@\n %@", [parsedObject class], parsedObject);
#endif
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

	
@end
