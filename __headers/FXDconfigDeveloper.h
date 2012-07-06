//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 Ensight. All rights reserved.
//


#if DEBUG
	#if ForDEVELOPER
		#define USE_FXDLog	1

		#define USE_TestFlight	0

		#define USE_loggingRotatingInterface	0
		#define USE_loggingViewDrawing	0
		#define USE_loggingSequeActions	0

	#else
		#define USE_FXDLog	0

		#define USE_TestFlight	1

	#endif

	#define USE_Flurry	0

#else
	#define USE_FXDLog		0

	#define USE_TestFlight	1
	#define USE_Flurry	1

#endif


#define strClassSelector	[NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
#define FXDLog	NSLog

#if USE_FXDLog
	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", strClassSelector)

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", strClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@ : %@ __", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_VIEW_FRAME	FXDLog(@" ");FXDLog(@"%@ : %@", strClassSelector, NSStringFromCGRect(self.frame));

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", strClassSelector)

	#define FXDLog_ERROR	FXDLog(@"error code: %d\nlocalizedDescription: %@\nuserInfo: %@",[error code],[error localizedDescription],[error userInfo])

#else
	#define FXDLog_DEFAULT

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_VIEW_FRAME

	#define FXDLog_OVERRIDE

	#define FXDLog_ERROR

#endif


#ifndef application_AppStoreID
	#define application_AppStoreID	524312409
#endif

#define versionMaximumSupported	6.0


#if	USE_TestFlight
	#import "TestFlight.h"

	#ifndef testflightTeamToken
		#define testflightTeamToken	@"c22710bbb9f61076a6111ca395109328_MzY2NQ"
	#endif

	#define CHECKPOINT_DEFAULT	[TestFlight passCheckpoint:strClassSelector]

#else
	#define CHECKPOINT_DEFAULT
#endif


#if USE_Flurry
	#import "FlurryAnalytics.h"

	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"MG21RAFW4CXACSJL2JF9"
	#endif

	#define	LOGEVENT(v)			[FlurryAnalytics logEvent:v]
	#define LOGEVENT_DEFAULT	LOGEVENT(strClassSelector)

#else
	#define	LOGEVENT(v)
	#define LOGEVENT_DEFAULT

#endif