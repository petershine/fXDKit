//
//  FXDsuperTwitterControl.m
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperTwitterControl.h"


#pragma mark - Private interface
@interface FXDsuperTwitterControl (Private)
- (void)logTwitterResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;
@end


#pragma mark - Public implementation
@implementation FXDsuperTwitterControl

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties		
		_accountStore = nil;
		_accountType = nil;
		
		_twitterAccountArray = nil;
		_mainTwitterAccount = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (ACAccountStore*)accountStore {
	if (!_accountStore) {
		_accountStore = [[ACAccountStore alloc] init];
	}
	
	return _accountStore;
}

- (ACAccountType*)accountType {
	if (!_accountType) {
		_accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	}
	
	return _accountType;
}

#pragma mark -
- (NSArray*)twitterAccountArray {
	if (!_twitterAccountArray) {
		_twitterAccountArray = [self.accountStore accountsWithAccountType:self.accountType];
	}
	
	return _twitterAccountArray;
}

- (ACAccount*)mainTwitterAccount {	FXDLog_DEFAULT;
	
	if (!_mainTwitterAccount) {
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


#pragma mark - Private
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


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperTwitterControl*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}

#pragma mark -
- (void)signInBySelectingTwitterAccount {	FXDLog_DEFAULT;	
	FXDLog(@"accountType.accountTypeDescription: %@", self.accountType.accountTypeDescription);
	FXDLog(@"accountType.accessGranted: %d", self.accountType.accessGranted);
	
	if (self.accountType.accessGranted) {
		[self showAlertViewForSelectingTwitterAccount];
	}
	else {
		if ([FXDsuperGlobalControl isSystemVersionLatest]) {
#if ENVIRONTMENT_newestSDK
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
#endif
		}
		else {
#if ENVIRONTMENT_newestSDK
#else
			[self.accountStore requestAccessToAccountsWithType:self.accountType
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
	
	if ([self.twitterAccountArray count] > 0) {
		
		NSString *alertTitle = NSLocalizedString(alert_SelectTwitterAccount, nil);
		NSString *alertMessage = NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil);
		NSString *cancelButtonTitle = NSLocalizedString(text_Cancel, nil);
		
		if (self.mainTwitterAccount) {
			alertTitle = NSLocalizedString(alert_SelectTwitterAccount, nil);
			alertMessage = NSLocalizedString(message_PleaseSelectYourTwitterAcount, nil);
			cancelButtonTitle = @"SIGN OUT";
		}
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
															message:alertMessage
														   delegate:self
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
	else {
		//If no Twitter account is signed up... alert user
		//Following is not working
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
	}
}

#pragma mark -
- (void)userLookUpWithScreenName:(NSString*)screenName {
	
	NSURL *requestURL = [NSURL URLWithString:urlstringTwitterUserLookUp];
	
	NSDictionary *parameters = @{objkeyTwitterScreenName: screenName};
	
	TWRequest *defaultRequest = [[TWRequest alloc] initWithURL:requestURL
												parameters:parameters
											 requestMethod:TWRequestMethodGET];
	
	[defaultRequest
	 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if DEBUG
		 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif		 
	 }];
}

- (void)statusUpdateWithStatus:(NSString*)status {
	
	if (self.mainTwitterAccount) {
		NSURL *requestURL = [NSURL URLWithString:urlstringTwitterStatusUpdate];
		
		NSDictionary *parameters = @{objkeyTwitterStatus: status};
		
		TWRequest *defaultRequest = [[TWRequest alloc] initWithURL:requestURL
													parameters:parameters
												 requestMethod:TWRequestMethodPOST];
		
		defaultRequest.account = self.mainTwitterAccount;
		
		[defaultRequest
		 performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {	FXDLog_DEFAULT;
#if DEBUG
			 [self logTwitterResponseWithResponseData:responseData withURLresponse:urlResponse withError:error];
#endif		 
		 }];
	}
	else {	FXDLog_DEFAULT;
		FXDLog(@"self.mainTwitterAccount: %@", self.mainTwitterAccount);
	}
}

#pragma mark -
- (TWTweetComposeViewController*)tweetComposeInterfaceWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray {	FXDLog_DEFAULT;
	
	TWTweetComposeViewController *tweetComposeInterface = nil;
	
	if ([TWTweetComposeViewController canSendTweet]) {
		tweetComposeInterface = [[TWTweetComposeViewController alloc] init];
		
		if (initialText) {
			if ([tweetComposeInterface setInitialText:initialText] == NO) {
				FXDLog(@"initialText: %@", initialText);
			}
		}
		
		if ([imageArray count] > 0) {
			for (UIImage *image in imageArray) {
				if ([tweetComposeInterface addImage:image] == NO) {
					FXDLog(@"image: %@", image);
				}
			}
		}
		
		if ([URLarray count] > 0) {
			for (NSURL *url in URLarray) {
				if ([tweetComposeInterface addURL:url] == NO) {
					FXDLog(@"URL: %@", url);
				}
			}
		}
	}
	else {
		//TODO: notify
	}
	
	return tweetComposeInterface;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {	FXDLog_DEFAULT;
	FXDLog(@"buttonIndex: %d", buttonIndex);
	
	_mainTwitterAccount = nil;
	
	NSString *identifier = nil;
	
	if (buttonIndex != alertView.cancelButtonIndex) {

		_mainTwitterAccount = [self.twitterAccountArray objectAtIndex:buttonIndex];
		
		identifier = _mainTwitterAccount.identifier;
		
#if ForDEVELOPER
		[self userLookUpWithScreenName:self.mainTwitterAccount.username];
#endif
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:identifier forKey:userdefaultObjKeyMainAccountIdentifier];	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	self.twitterAccountArray = nil;
}


@end
