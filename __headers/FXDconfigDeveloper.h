//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 Ensight. All rights reserved.
//

#if DEBUG
	#if ForDEVELOPER
		#define USE_loggingViewControllerLifeCycle	0
		#define USE_loggingRotatingOrientation	0
		#define USE_loggingViewDrawing	0
		#define USE_loggingBorderLine	0
		#define USE_loggingResultObjFiltering	0
		#define USE_loggingManagedObjectActivities	0

		#define TEST_appirater	1

	#else

	#endif


	#define USE_FXDLog	1

	#define USE_TestFlight	1
	#define USE_Flurry	0
	#define USE_GoogleAnalytics	1

#else
	#define USE_FXDLog	0

	#define USE_TestFlight	0
	#define USE_Flurry	1
	#define USE_GoogleAnalytics	1

#endif


#define strClassSelector	[NSString stringWithFormat:@"%@%s", NSStringFromClass([self class]), __FUNCTION__]

#if USE_FXDLog
	#define FXDLog	NSLog

	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", strClassSelector)

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", strClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@: %@ __", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_VIEW_FRAME	FXDLog(@" ");FXDLog(@"%@: %@", strClassSelector, NSStringFromCGRect(self.frame));

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", strClassSelector)

	#define FXDLog_ERROR	if(error){FXDLog(@" ");FXDLog(@"\n\n%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]);}
	#define FXDLog_ERRORexcept(v)	if(error){if([error code]!=v){FXDLog_ERROR;}}

	#define FXDLog_NOTIFIED	FXDLog(@" ");FXDLog(@"NOTIFIED: %@: %@", NSStringFromClass([self class]), note.name)

#else
	#define FXDLog(format, ...)	{}

	#define FXDLog_DEFAULT

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_VIEW_FRAME

	#define FXDLog_OVERRIDE

	#define FXDLog_ERROR
	#define FXDLog_ERRORexcept(v)

	#define FXDLog_NOTIFIED

#endif


#if	USE_TestFlight
	#import "TestFlight.h"

	#ifndef testflightTeamToken
		#define testflightTeamToken	@"testflightTeamToken"
	#endif

	#ifndef testflightAppToken
		#define testflightAppToken	@"testflightAppToken"
	#endif


	#define NSLog	TFLog

	#define	CHECKPOINT(format, ...)	[TestFlight passCheckpoint:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define CHECKPOINT_DEFAULT	CHECKPOINT(@"%@",strClassSelector)
	#define CHECKPOINT_ERROR	if(error){CHECKPOINT(@"%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]);}

#else
	#define	CHECKPOINT(format, ...)	{}
	#define CHECKPOINT_DEFAULT
	#define CHECKPOINT_ERROR

#endif


#if USE_Flurry
	#import "Flurry.h"

	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#define	LOGEVENT(format, ...)	[Flurry logEvent:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define LOGEVENT_DEFAULT		LOGEVENT(@"%@",strClassSelector)
	#define LOGEVENT_ERROR			if(error){NSException *exception=[[NSException alloc] initWithName:[error domain] reason:[error localizedDescription] userInfo:[error userInfo]];[Flurry logError:[NSString stringWithFormat:@"error code: %d", [error code]] message:[NSString stringWithFormat:@"%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]] exception:exception];}

#else
	#define	LOGEVENT(format, ...)	{}
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


#ifndef ENVIRONMENT_newestSDK
	#define ENVIRONMENT_newestSDK	(__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1)
#endif


#ifndef SCREEN_SIZE_35inch
	#define SCREEN_SIZE_35inch	(MAX([[FXDWindow applicationWindow] bounds].size.width, [[FXDWindow applicationWindow] bounds].size.height) <= 480.0)
#endif


