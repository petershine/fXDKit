

#ifndef FXDKit_FXDmacroValue_h
#define FXDKit_FXDmacroValue_h


#define integerNotDefined	-1

#define doubleOneBillion	1000000000.0
#define doubleOneMillion	1000000.0
#define doubleOneThousand	1000.0
#define doubleSecondsInDay	(60.0*60.0*24.0)

#define durationAnimation	(1.0/3.0)
#define durationQuickAnimation	(durationAnimation/2.0)
#define durationSlowAnimation	(durationAnimation*2.0)

#define durationOneSecond	1.0

#define delayFullMinute		(durationOneSecond*60.0)
#define delayOneSecond		durationOneSecond
#define delayQuarterSecond	(durationOneSecond/4.0)
#define delayHalfSecond		(durationOneSecond/2.0)
#define delayExtremelyShort	(durationOneSecond/100.0)

#define intervalOneSecond	durationOneSecond


#define radiusCorner	4.0
#define radiusBigCorner	(radiusCorner*2.0)


#define durationKeyboardAnimation	0.25
#define heightKeyboard_iPhone	216.0
#define heightKeyboard_iPad		352.0

#define alphaValue03	0.3
#define alphaValue05	0.5
#define alphaValue08	0.8


#define dimensionMinimumTouchable	44.0


#define heightStatusBar	20.0


#define heightNavigationBar	44.0
#define heightToolBar	heightNavigationBar


#define marginDefault	8.0


#define rotationAngleLandscapeLeft	90.0
#define rotationAngleLandscapeRight	270.0


#define keychainAccountAccessToken	@"AccessTokenAccount"
#define keychainAccountAccessSecret	@"AccessSecretAccount"


//Twitter
#define maximumTweetLength	140


//Facebook
#define facebookGraphProfileFeed	@"%@/feed"
#define facebookGraphProfileVideos	@"%@/videos"
#define facebookGraphAccessToken	@"%@?fields=access_token"

#define urlrootFacebookAPI	@"https://graph.facebook.com/"
#define urlhostFacebookVideoGraph	@"https://graph-video.facebook.com/"

#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]
#define urlstringFacebookVideoGraph(method)	[NSString stringWithFormat:@"%@%@", urlhostFacebookVideoGraph, method]

#define objkeyFacebookAccessToken	@"access_token"
#define objkeyFacebookID	@"id"
#define objkeyFacebookName	@"name"
#define objkeyFacebookLocale	@"locale"
#define objkeyFacebookUsername	@"username"
#define objkeyFacebookCategory	@"category"


#endif
