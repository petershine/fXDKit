//
//  FXDconfigAnalytics.h
//
//
//  Created by petershine on 4/30/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigAnalytics_h
#define FXDKit_FXDconfigAnalytics_h


#if DEBUG
	#if ForDEVELOPER
		#define USE_TestFlight	0
	#else
		#define USE_TestFlight	1
	#endif

	#define USE_Flurry	0
	#define USE_GoogleAnalytics	0

#else
	#define USE_TestFlight	0

	#define USE_Flurry	1
	#define USE_GoogleAnalytics	0

#endif


#if	USE_TestFlight
	//import "libz.dylib"

	#import "TestFlight.h"

	#ifndef testflightTeamToken
		#define testflightTeamToken	@"testflightTeamToken"
	#endif

	#ifndef testflightAppToken
		#define testflightAppToken	@"testflightAppToken"
	#endif


	#define NSLog	TFLog

	#define CHECKPOINT(format, ...)	[TestFlight passCheckpoint:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define CHECKPOINT_DEFAULT	CHECKPOINT(@"%@",strClassSelector)
	#define CHECKPOINT_ERROR	if(error){CHECKPOINT(@"%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]);}

#else
	#define CHECKPOINT(format, ...)	{}
	#define CHECKPOINT_DEFAULT
	#define CHECKPOINT_ERROR

#endif


#if USE_Flurry
	#import "Flurry.h"

	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#define LOGEVENT(format, ...)	[Flurry logEvent:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define LOGEVENT_DEFAULT		LOGEVENT(@"%@",strClassSelector)
	#define LOGEVENT_ERROR			if(error){NSException *exception=[[NSException alloc] initWithName:[error domain] reason:[error localizedDescription] userInfo:[error userInfo]];[Flurry logError:[NSString stringWithFormat:@"error code: %d", [error code]] message:[NSString stringWithFormat:@"%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]] exception:exception];}

#else
	#define LOGEVENT(format, ...)	{}
	#define LOGEVENT_DEFAULT
	#define LOGEVENT_ERROR

#endif


#if USE_GoogleAnalytics
	#import "GAI.h"
	#import "GAITrackedViewController.h"

	#ifndef googleAnalyticsTrackingID
		#define googleAnalyticsTrackingID	@"UA-xxxxxxxx-x"
	#endif
#else

#endif


#endif