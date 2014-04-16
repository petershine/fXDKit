//
//  FXDsuperSocialManager.h
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define userdefaultObjMainTwitterAccountIdentifier	@"MainTwitterAccountIdentifierObjKey"
#define userdefaultObjMainFacebookAccountIdentifier	@"MainFacebookAccountIdentifierObjKey"


@interface FXDsuperSocialManager : FXDsuperManager {
	NSString *_typeIdentifier;
	NSString *_reasonForConnecting;
	NSDictionary *_initialAccessOptions;
	NSDictionary *_additionalAccessOptions;

	NSArray *_multiAccountArray;
}

// Properties
@property (strong, nonatomic) NSString *typeIdentifier;
@property (strong, nonatomic) NSString *reasonForConnecting;
@property (strong, nonatomic) NSDictionary *initialAccessOptions;
@property (strong, nonatomic) NSDictionary *additionalAccessOptions;

@property (strong, nonatomic) ACAccountStore *mainAccountStore;

@property (strong, nonatomic) ACAccountType *mainAccountType;
@property (strong, nonatomic) NSArray *multiAccountArray;
@property (strong, nonatomic) ACAccount *currentMainAccount;


#pragma mark - Public
+ (FXDsuperSocialManager*)sharedInstance;

- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromActionSheet:(FXDActionSheet*)actionSheet forButtonIndex:(NSInteger)buttonIndex withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock;

- (SLComposeViewController*)socialComposeControllerForServiceIdentifier:(NSString*)serviceIdentifier withInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;

#if ForDEVELOPER
- (void)evaluateResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;
#endif

//MARK: - Observer implementation
- (void)observedACAccountStoreDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#define maximumTweetLength	140

#define urlrootTwitterAPI			@"https://api.twitter.com/1.1/"
#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]

#define urlstringTwitterUserShow		urlstringTwitter(@"users/show.json")
#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")

#define objkeyTwitterScreenName			@"screen_name"
#define objkeyTwitterStatus				@"status"
#define objkeyTwitterLat				@"lat"
#define objkeyTwitterLong				@"long"
#define objkeyTwitterPlaceId			@"place_id"
#define objkeyTwitterDisplayCoordinates	@"display_coordinates"


@interface FXDsuperTwitterManager : FXDsuperSocialManager
- (void)twitterUserShowWithScreenName:(NSString*)screenName;
- (void)twitterStatusUpdateWithTweetText:(NSString*)tweetText atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude;
@end


#ifndef apikeyFacebookAppId
	#define apikeyFacebookAppId	@"000000000000000"
#endif

#define	facebookPermissionEmail		@"email"
#define facebookPermissionBasicInfo			@"basic_info"
#define	facebookPermissionPublishActions	@"publish_actions"
#define	facebookPermissionManagePages		@"manage_pages"
#define facebookPermissionPublishStream		@"publish_stream"

#define facebookGraphMe				@"me"
#define facebookGraphMeAccounts		@"me/accounts"
#define facebookGraphProfileFeed	@"%@/feed"
#define facebookGraphAccessToken	@"%@?fields=access_token"

#define urlrootFacebookAPI	@"https://graph.facebook.com/"
#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]

#define objkeyFacebookAccessToken	@"access_token"
#define objkeyFacebookID	@"id"
#define objkeyFacebookName	@"name"
#define objkeyFacebookLocale	@"locale"
#define objkeyFacebookUsername	@"username"
#define objkeyFacebookCategory	@"category"


@interface FXDsuperFacebookManager : FXDsuperSocialManager
- (void)facebookRequestForFacebookUserId:(NSString*)facebookUserId;
@end
