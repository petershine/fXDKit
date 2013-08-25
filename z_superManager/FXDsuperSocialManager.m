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

- (ACAccount*)mainTwitterAccount {

	if (_mainTwitterAccount == nil) {	FXDLog_DEFAULT;
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
- (void)signInBySelectingTwitterAccountWithPresentingView:(UIView*)presentingView withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
	FXDLog(@"accountType.accountTypeDescription: %@", self.accountType.accountTypeDescription);
	FXDLog(@"accountType.accessGranted: %d", self.accountType.accessGranted);
	
	if (self.accountType.accessGranted) {
		//[self showAlertViewForSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
		[self showActionSheetInPresentingView:presentingView forSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
		return;
	}
	
	
	[self.accountStore
	 requestAccessToAccountsWithType:self.accountType
	 options:nil
	 completion:^(BOOL granted, NSError *error) {
		 FXDLog(@"granted: %d", granted);
		 
		 FXDLog_ERROR;
		 
		 if (granted) {
			 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
				 //[self showAlertViewForSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
				 [self showActionSheetInPresentingView:presentingView forSelectingTwitterAccountWithDidFinishBlock:didFinishBlock];
			 }];
		 }
		 else {
			 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
				 FXDAlertView *alertView =
				 [[FXDAlertView alloc]
				  initWithTitle:NSLocalizedString(@"Please grant Twitter access in Settings", nil)
				  message:NSLocalizedString(@"PopToo uses your Twitter to share about music you're listening", nil)
				  clickedButtonAtIndexBlock:nil
				  cancelButtonTitle:NSLocalizedString(text_OK, nil)
				  otherButtonTitles:nil];
				 
				 [alertView show];
			 }];
			 
			 if (didFinishBlock) {
				 didFinishBlock(NO);
			 }
		 }
	 }];
}

- (void)showAlertViewForSelectingTwitterAccountWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
	FXDLog(@"self.twitterAccountArray:\n%@", self.twitterAccountArray);

	if ([self.twitterAccountArray count] == 0) {
		//MARK: If no Twitter account is signed up... alert user
		if (didFinishBlock) {
			didFinishBlock(NO);
		}
		
		return;
	}


	FXDAlertView *alertView =
	[[FXDAlertView alloc]
	 initWithTitle:NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil)
	 message:nil
	 clickedButtonAtIndexBlock:^(id alertView, NSInteger buttonIndex) {
		 [self
		  selectTwitterAccountFromAlertView:alertView
		  forButtonIndex:buttonIndex
		  withDidFinishBlock:didFinishBlock];
	 }
	 cancelButtonTitle:nil
	 otherButtonTitles:nil];
	
	
	[alertView addButtonWithTitle:NSLocalizedString(text_Cancel, nil)];
	alertView.cancelButtonIndex = 0;

	for (ACAccount *twitterAccount in self.twitterAccountArray) {
		[alertView addButtonWithTitle:[NSString stringWithFormat:@"@%@", twitterAccount.username]];
	}

	[alertView addButtonWithTitle:NSLocalizedString(text_SignOut, nil)];

	[alertView show];
}

- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingTwitterAccountWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {
	FXDLog_DEFAULT;
	FXDLog(@"self.twitterAccountArray:\n%@", self.twitterAccountArray);
	
	if ([self.twitterAccountArray count] == 0) {
		//MARK: If no Twitter account is signed up... alert user
		if (didFinishBlock) {
			didFinishBlock(NO);
		}
		
		return;
	}
	
	
	FXDActionSheet *actionSheet =
	[[FXDActionSheet alloc]
	 initWithTitle:NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil)
	 clickedButtonAtIndexBlock:^(id alertView, NSInteger buttonIndex) {
		 [self
		  selectTwitterAccountFromAlertView:alertView
		  forButtonIndex:buttonIndex
		  withDidFinishBlock:didFinishBlock];
		 
	 } withButtonTitleArray:nil
	 cancelButtonTitle:nil
	 destructiveButtonTitle:nil
	 otherButtonTitles:nil];
	
	[actionSheet addButtonWithTitle:NSLocalizedString(text_Cancel, nil)];
	actionSheet.cancelButtonIndex = 0;
	
	for (ACAccount *twitterAccount in self.twitterAccountArray) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"@%@", twitterAccount.username]];
	}
	
	[actionSheet addButtonWithTitle:NSLocalizedString(text_SignOut, nil)];
	actionSheet.destructiveButtonIndex = [self.twitterAccountArray count]+1;
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:presentingView];
}

#pragma mark -
- (void)selectTwitterAccountFromAlertView:(id)alertView forButtonIndex:(NSInteger)buttonIndex withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {
	
#if ForDEVELOPER
	FXDLog(@"buttonIndex: %d", buttonIndex);
	FXDLog(@"cancelButtonIndex: %d", (NSInteger)[alertView performSelector:@selector(cancelButtonIndex)]);
	
	if ([alertView isKindOfClass:[UIActionSheet class]]) {
		FXDLog(@"destructiveButtonIndex: %d", [(FXDActionSheet*)alertView destructiveButtonIndex]);
	}
#endif
	
	
	if (buttonIndex == (NSInteger)[alertView performSelector:@selector(cancelButtonIndex)]) {
		_twitterAccountArray = nil;
		
		if (didFinishBlock) {
			didFinishBlock(YES);
		}
		
		return;
	}
	
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([alertView isKindOfClass:[UIActionSheet class]]
		&& buttonIndex == [(FXDActionSheet*)alertView destructiveButtonIndex]) {
		
		[userDefaults removeObjectForKey:userdefaultObjKeyMainAccountIdentifier];
		_mainTwitterAccount = nil;
	}
	else if ([alertView isKindOfClass:[UIAlertView class]]
		&& buttonIndex == [self.twitterAccountArray count]+1) {
		
		[userDefaults removeObjectForKey:userdefaultObjKeyMainAccountIdentifier];
		_mainTwitterAccount = nil;
	}
	else {
		ACAccount *selectedTwitterAccount = (self.twitterAccountArray)[buttonIndex-1];
		FXDLog(@"selectedTwitterAccount: %@", selectedTwitterAccount);
		
		if (selectedTwitterAccount) {
			[userDefaults setObject:selectedTwitterAccount.identifier forKey:userdefaultObjKeyMainAccountIdentifier];
			
			_mainTwitterAccount = selectedTwitterAccount;
			
			[self userShowWithScreenName:_mainTwitterAccount.username];
		}
		
		[userDefaults synchronize];
	}
	
	_twitterAccountArray = nil;
	
	if (didFinishBlock) {
		didFinishBlock(YES);
	}
}

- (void)userShowWithScreenName:(NSString*)screenName {
	
	if (self.mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);
		
		return;
	}
	
	[self renewTwitterCredentialWithRequestingBlock:^{
		NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserShow];
		
		NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};
		
		SLRequest *defaultRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
		
		[defaultRequest
		 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if ForDEVELOPER
			 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif
		 }];
	}];
}

- (void)statusUpdateWithTweetText:(NSString*)tweetText {
	
	if (self.mainTwitterAccount == nil) {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);

		return;
	}

	
	[self renewTwitterCredentialWithRequestingBlock:^{
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
	}];
}

- (void)renewTwitterCredentialWithRequestingBlock:(void(^)(void))requestingBlock {
	
	if (self.mainTwitterAccount.username == nil) {
		[self.accountStore
		 renewCredentialsForAccount:self.mainTwitterAccount
		 completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
			 FXDLog_ERROR;LOGEVENT_ERROR;
			 
			 FXDLog(@"renewResult: %d", renewResult);
			 
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

	FXDLog(@"responseData length: %d bytes", [responseData length]);

	if ([responseData length] > 0) {
		id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		FXDLog(@"jsonObj: %@\n %@", [jsonObj class], jsonObj);
	}
}
#endif


//MARK: - Observer implementation

//MARK: - Delegate implementation
	
@end
