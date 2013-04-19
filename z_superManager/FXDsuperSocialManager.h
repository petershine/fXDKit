//
//  FXDsuperSocialManager.h
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


@interface FXDsuperSocialManager : FXDObject

// Properties
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;

@property (strong, nonatomic) NSArray *twitterAccountArray;
@property (strong, nonatomic) ACAccount *mainTwitterAccount;


#pragma mark - Public
+ (FXDsuperSocialManager*)sharedInstance;

- (void)signInBySelectingTwitterAccountWithDidFinishBlock:(void(^)(void))didFinishBlock;
- (void)showAlertViewForSelectingTwitterAccountWithDidFinishBlock:(void(^)(void))didFinishBlock;

- (void)userLookUpWithScreenName:(NSString*)screenName;
- (void)statusUpdateWithTweetText:(NSString*)tweetText;

- (SLComposeViewController*)socialComposeControllerWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;

#if ForDEVELOPER
- (void)logTwitterResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;
#endif


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
