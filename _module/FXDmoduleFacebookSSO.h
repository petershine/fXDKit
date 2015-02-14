//
//  FXDmoduleFacebookSSO.h
//  FXDFramework
//
//  Created by petershine on 2/14/15.
//  Copyright (c) 2015 fXceed. All rights reserved.
//

#if USE_SocialFrameworks


#define userdefaultObjKeyFacebookAuthenticationURL	@"FacebookAuthenticationURLObjKey"
#define userdefaultObjKeyFacebookAccessToken		@"FacebookAccessTokenObjKey"


#import "FXDmoduleSocial.h"
@interface FXDmoduleFacebookSSO : FXDmoduleFacebook {
	FBSessionLoginBehavior _sessionLoginBehavior;

	NSDictionary *_currentFacebookAccount;
	NSString *_currentPageAccessToken;
}

@property (nonatomic) BOOL isAskingForMorePermissions;

@property (nonatomic) FBSessionLoginBehavior sessionLoginBehavior;

@property (strong, nonatomic) NSDictionary *currentFacebookAccount;
@property (strong, nonatomic) NSString *currentPageAccessToken;


- (void)resetCredential;

- (void)startObservingFBSessionNotifications;

- (BOOL)shouldContinueWithError:(NSError*)error;

- (void)updateSessionPermissionWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)facebookRequestForMeWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)facebookRequestForAccountsWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)facebookRequestPageAccessTokenWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)facebookRequestToPostWithMessage:(NSString*)message withMediaLink:(NSString*)mediaLink atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude withFinishCallback:(FXDcallbackFinish)finishCallback;


- (void)observedFBSessionDidSetActiveSession:(NSNotification*)notification;
- (void)observedFBSessionDidUnsetActiveSession:(NSNotification*)notification;
- (void)observedFBSessionDidBecomeOpenActiveSession:(NSNotification*)notification;
- (void)observedFBSessionDidBecomeClosedActiveSession:(NSNotification*)notification;

@end


#endif