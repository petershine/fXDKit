//
//  FXDsuperSocialManager.h
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define userdefaultObjKeyMainTwitterAccountIdentifier	@"MainTwitterAccountIdentifierObjKey"
#define userdefaultObjKeyMainFacebookAccountIdentifier	@"MainFacebookAccountIdentifierObjKey"


@interface FXDsuperSocialManager : FXDObject {
	NSString *_reasonForTwitterAccount;
	NSString *_reasonForFacebookAccount;

	NSDictionary *_accountAccessOptions;
}

// Properties
@property (strong, nonatomic) NSString *reasonForTwitterAccount;
@property (strong, nonatomic) NSString *reasonForFacebookAccount;

@property (strong, nonatomic) NSDictionary *accountAccessOptions;

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (strong, nonatomic) NSArray *twitterAccountArray;
@property (strong, nonatomic) ACAccount *mainTwitterAccount;

@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) NSArray *facebookAccountArray;
@property (strong, nonatomic) ACAccount *mainFacebookAccount;


#pragma mark - Public
+ (FXDsuperSocialManager*)sharedInstance;

- (void)signInBySelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withPresentingView:(UIView*)presentingView withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromAlertObj:(id)actionSheet forButtonIndex:(NSInteger)buttonIndex withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(void))requestingBlock;

- (SLComposeViewController*)socialComposeControllerForServiceIdentifier:(NSString*)serviceIdentifier withInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;

#if ForDEVELOPER
- (void)evaluateResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;
#endif

//MARK: - Observer implementation

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

@interface FXDsuperSocialManager (Twitter)
- (void)twitterUserShowWithScreenName:(NSString*)screenName;
- (void)twitterStatusUpdateWithTweetText:(NSString*)tweetText atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude;
@end


#define urlrootFacebookAPI	@"https://graph.facebook.com/"
#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]

#define urlstringFacebookUserMe		urlstringTwitter(@"me")

#define objkeyFacebookUserId	@"id"
#define objkeyFacebookFullName	@"name"
#define objkeyFacebookLocale	@"locale"
#define objkeyFacebookUsername	@"username"

@interface FXDsuperSocialManager (Facebook)
- (void)facebookRequestForFacebookUserId:(NSString*)facebookUserId;
@end
