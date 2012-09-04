//
//  FXDsuperTwitterControl.h
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define userdefaultObjKeyMainAccountIdentifier	@"MainAccountIdentifierObjKey"


#define urlrootTwitterAPI	@"https://api.twitter.com/1/"
#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]

#define urlstringTwitterUserLookUp		urlstringTwitter(@"users/lookup.json")
#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")

#define objkeyTwitterScreenName	@"screen_name"
#define objkeyTwitterStatus		@"status"


#import "FXDKit.h"

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface FXDsuperTwitterControl : NSObject <UIAlertViewDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For accessor overriding	
	ACAccountStore *_accountStore;
	ACAccountType *_accountType;
	
	NSArray *_twitterAccountArray;
	ACAccount *_mainTwitterAccount;
}

// Properties
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;

@property (strong, nonatomic) NSArray *twitterAccountArray;
@property (strong, nonatomic) ACAccount *mainTwitterAccount;


#pragma mark - Public
+ (FXDsuperTwitterControl*)sharedInstance;

- (void)signInBySelectingTwitterAccount;
- (void)showAlertViewForSelectingTwitterAccount;

- (void)userLookUpWithScreenName:(NSString*)screenName;
- (void)statusUpdateWithStatus:(NSString*)status;

- (TWTweetComposeViewController*)tweetComposeInterfaceWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate


@end
