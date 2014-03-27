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
	#define USE_Flurry	TRUE
#endif

#if USE_Flurry & ForDEVELOPER
	#ifndef USE_FlurryWithLogging
		#define USE_FlurryWithLogging	FALSE
	#endif
#endif


#if DEBUG
	#ifndef USE_TestFlight
		#define USE_TestFlight	TRUE
	#endif

	#ifndef USE_Appsee
		#define USE_Appsee	FALSE
	#endif

#else
	#ifndef USE_TestFlight
		#define USE_TestFlight	FALSE
	#endif

	#ifndef USE_Appsee
		#define USE_Appsee	TRUE
	#endif

#endif


#if USE_Flurry
	#ifndef flurryApplicationKey
		#warning //TODO: Define flurryApplicationKey
		#define	flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#import "Flurry.h"

	#define LOGEVENT(__FORMAT__, ...)	[Flurry logEvent:[NSString stringWithFormat:__FORMAT__, ##__VA_ARGS__]]

	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	[Flurry\
																logEvent:identifier\
																withParameters:parameters\
																timed:shouldTime]

	#define LOGEVENT_END(identifier, parameters)	[Flurry endTimedEvent:identifier withParameters:parameters];

	#define LOGEVENT_DEFAULT	LOGEVENT(@"%@", selfClassSelector)
	#define LOGEVENT_ERROR	if(error){\
								NSMutableDictionary *parameters = [[error essentialParameters] mutableCopy];\
								parameters[@"file"] = @(__FILE__);\
								parameters[@"line"] = @(__LINE__);\
								LOGEVENT_FULL(selfClassSelector, parameters, NO);}

#else
	#define LOGEVENT(__FORMAT__, ...)	{}

	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	{}

	#define LOGEVENT_END(identifier, parameters)	{}

	#define LOGEVENT_DEFAULT
	#define LOGEVENT_ERROR

#endif



#if	USE_TestFlight
	#ifndef testflightAppToken
		#warning	//TODO: Define testflightAppToken
		#define testflightAppToken	@"testflightAppToken"
	#endif

	#import "TestFlight.h"

	#warning //TODO: Should add libz.dylib for TestFlight

#endif


#if USE_Appsee
	#ifndef appseeAPIkey
		#warning //TODO: Define appseeAPIkey
		#define appseeAPIkey	@"appseeAPIkey"
	#endif

	#import <Appsee/Appsee.h>
#endif


#endif