
@import Social;
@import Accounts;
@import CoreLocation;

#import "FXDKit.h"


#define userdefaultObjMainTwitterAccountIdentifier	@"MainTwitterAccountIdentifierObjKey"
#define userdefaultObjMainFacebookAccountIdentifier	@"MainFacebookAccountIdentifierObjKey"


@interface FXDmoduleSocial : FXDsuperModule {
	NSString *_typeIdentifier;
	NSString *_reasonForConnecting;
	NSDictionary *_initialAccessOptions;
	NSDictionary *_additionalAccessOptions;

	NSArray *_multiAccountArray;
}

@property (strong, nonatomic) NSString *typeIdentifier;
@property (strong, nonatomic) NSString *reasonForConnecting;
@property (strong, nonatomic) NSDictionary *initialAccessOptions;
@property (strong, nonatomic) NSDictionary *additionalAccessOptions;

@property (strong, nonatomic) ACAccountStore *mainAccountStore;

@property (strong, nonatomic) ACAccountType *mainAccountType;
@property (strong, nonatomic) NSArray *multiAccountArray;
@property (strong, nonatomic) ACAccount *currentMainAccount;


- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromActionSheet:(FXDActionSheet*)actionSheet forButtonIndex:(NSInteger)buttonIndex withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock;

- (SLComposeViewController*)socialComposeControllerForServiceIdentifier:(NSString*)serviceIdentifier withInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;

- (void)evaluateResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;


#pragma mark - Observer
- (void)observedACAccountStoreDidChange:(NSNotification*)notification;

#pragma mark - Delegate

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


@interface FXDmoduleTwitter : FXDmoduleSocial
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


@interface FXDmoduleFacebook : FXDmoduleSocial
- (void)facebookRequestForFacebookUserId:(NSString*)facebookUserId;
@end
