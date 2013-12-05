//
//  FXDconfigAnalytics.h
//
//
//  Created by petershine on 4/30/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigAnalytics_h
#define FXDKit_FXDconfigAnalytics_h


#ifndef USE_Flurry
	#define USE_Flurry	1
#endif

#if DEBUG
	#if ForDEVELOPER
		#ifndef USE_TestFlight
			#define USE_TestFlight	0
		#endif

	#else
		#ifndef USE_TestFlight
			#define USE_TestFlight	1
		#endif
	#endif

	#ifndef USE_Appsee
		#define USE_Appsee	0
	#endif

#else
	#ifndef USE_TestFlight
		#define USE_TestFlight	0
	#endif

	#ifndef USE_Appsee
		#define USE_Appsee	1
	#endif

#endif


#if USE_Flurry
	#import "Flurry.h"
	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#define LOGEVENT(format, ...)	[Flurry logEvent:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	[Flurry logEvent:identifier withParameters:parameters timed:shouldTime]
	#define LOGEVENT_END(identifier, parameters)	[Flurry endTimedEvent:identifier withParameters:parameters];
	#define LOGEVENT_DEFAULT	LOGEVENT(@"%@",strClassSelector)

	#define LOGEVENT_ERROR	if(error){\
								NSMutableDictionary *parameters = [[error essentialParameters] mutableCopy];\
								parameters[@"file"] = @(__FILE__);\
								parameters[@"line"] = @(__LINE__);\
								LOGEVENT_FULL(strClassSelector, parameters, NO);}
#else
	#define LOGEVENT(format, ...)	{}
	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	{}
	#define LOGEVENT_END(identifier, parameters)	{}
	#define LOGEVENT_DEFAULT
	#define LOGEVENT_ERROR
#endif


#if USE_Appsee
	#import <Appsee/Appsee.h>
	#ifndef appseeAPIkey
		#define appseeAPIkey	@"appseeAPIkey"
	#endif
#else

#endif


#if	USE_TestFlight	//TODO: import "libz.dylib" for TestFlight
	#import "TestFlight.h"
	#ifndef testflightAppToken
		#define testflightAppToken	@"testflightAppToken"
	#endif

	#define NSLog	TFLog

	#define CHECKPOINT(format, ...)	[TestFlight passCheckpoint:[NSString stringWithFormat:format, ##__VA_ARGS__]]
	#define CHECKPOINT_DEFAULT	CHECKPOINT(@"%@",strClassSelector)
#else
	#define CHECKPOINT(format, ...)	{}
	#define CHECKPOINT_DEFAULT
#endif


#endif