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

	#else

	#endif

	#define USE_FXDLog	1

	#define USE_TestFlight	1
	#define USE_Flurry	0

#else
	#define USE_FXDLog	0

	#define USE_TestFlight	0
	#define USE_Flurry	1

#endif


#define strClassSelector	[NSString stringWithFormat:@"%@%s", NSStringFromClass([self class]), __FUNCTION__]
#define FXDLog	NSLog

#if USE_FXDLog
	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", strClassSelector)

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", strClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@: %@ __", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_VIEW_FRAME	FXDLog(@" ");FXDLog(@"%@: %@", strClassSelector, NSStringFromCGRect(self.frame));

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", strClassSelector)

	#define FXDLog_ERROR	if(error){FXDLog(@" ");FXDLog(@"\n\n%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]);}
	#define FXDLog_ERRORexcept(v)	if(error){if([error code]!=v){FXDLog_ERROR;}}

	#define FXDLog_NOTIFIED	FXDLog(@" ");FXDLog(@"NOTIFIED: %@: %@", NSStringFromClass([self class]), note.name)

#else
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

	#define NSLog	TFLog

	#define	CHECKPOINT(v)		[TestFlight passCheckpoint:v]
	#define CHECKPOINT_DEFAULT	CHECKPOINT(strClassSelector)

#else
	#define	CHECKPOINT(v)
	#define CHECKPOINT_DEFAULT

#endif


#if USE_Flurry
	#import "Flurry.h"

	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#define	LOGEVENT(v)			[Flurry logEvent:v]
	#define LOGEVENT_DEFAULT	LOGEVENT(strClassSelector)

#else
	#define	LOGEVENT(v)
	#define LOGEVENT_DEFAULT

#endif


#ifndef ENVIRONMENT_newestSDK
	#define ENVIRONMENT_newestSDK	__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
#endif
