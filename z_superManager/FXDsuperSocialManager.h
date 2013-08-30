//
//  FXDsuperSocialManager.h
//
//
//  Created by petershine on 5/3/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define userdefaultObjKeyMainAccountIdentifier	@"MainAccountIdentifierObjKey"


#define maximumTweetLength	140

#define urlrootTwitterAPI			@"https://api.twitter.com/1.1/"
#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]

//#define urlstringTwitterUserLookUp		urlstringTwitter(@"users/lookup.json")
#define urlstringTwitterUserShow		urlstringTwitter(@"users/show.json")
#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")

#define objkeyTwitterScreenName			@"screen_name"
#define objkeyTwitterStatus				@"status"
#define objkeyTwitterLat				@"lat"
#define objkeyTwitterLong				@"long"
#define objkeyTwitterPlaceId			@"place_id"
#define objkeyTwitterDisplayCoordinates	@"display_coordinates"


@interface FXDsuperSocialManager : FXDObject

// Properties
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;

@property (strong, nonatomic) NSArray *twitterAccountArray;
@property (strong, nonatomic) ACAccount *mainTwitterAccount;


#pragma mark - Public
+ (FXDsuperSocialManager*)sharedInstance;

- (void)signInBySelectingTwitterAccountWithPresentingView:(UIView*)presentingView withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)showAlertViewForSelectingTwitterAccountWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingTwitterAccountWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)selectTwitterAccountFromAlertView:(id)alertView forButtonIndex:(NSInteger)buttonIndex withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)userShowWithScreenName:(NSString*)screenName;
- (void)statusUpdateWithTweetText:(NSString*)tweetText atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude;

- (void)renewTwitterCredentialWithRequestingBlock:(void(^)(void))requestingBlock;

- (SLComposeViewController*)socialComposeControllerWithInitialText:(NSString*)initialText withImageArray:(NSArray*)imageArray withURLarray:(NSArray*)URLarray;

#if ForDEVELOPER
- (void)logTwitterResponseWithResponseData:(NSData*)responseData withURLresponse:(NSURLResponse*)urlResponse withError:(NSError*)error;
#endif


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
