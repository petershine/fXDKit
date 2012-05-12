//
//  FXDsuperTwitterControl.h
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


#define userdefaultObjKeyMainAccountIdentifier	@"MainAccountIdentifierObjKey"


#define urlrootTwitterAPI	@"https://api.twitter.com/1/"
#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]

#define urlstringTwitterUserLookUp		urlstringTwitter(@"users/lookup.json")
#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")

#define objkeyTwitterScreenName	@"screen_name"
#define objkeyTwitterStatus		@"status"


@interface FXDsuperTwitterControl : FXDObject <UIAlertViewDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference	
	ACAccountStore *_accountStore;
	ACAccountType *_accountType;
	
	NSArray *_twitterAccountArray;
	ACAccount *_mainTwitterAccount;
}

// Properties
@property (retain, nonatomic) ACAccountStore *accountStore;
@property (retain, nonatomic) ACAccountType *accountType;

@property (retain, nonatomic) NSArray *twitterAccountArray;
@property (retain, nonatomic) ACAccount *mainTwitterAccount;

// Controllers


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperTwitterControl*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)signInBySelectingTwitterAccount;
- (void)showAlertViewForSelectingTwitterAccount;

- (void)userLookUpWithScreenName:(NSString*)screenName;
- (void)statusUpdateWithStatus:(NSString*)status;

- (TWTweetComposeViewController*)tweetComposeInterfaceWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLArray:(NSArray*)urlArray;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate


@end
