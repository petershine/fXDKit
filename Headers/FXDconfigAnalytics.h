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
	#warning //TODO: Decide if Flurry is used
	#define USE_Flurry	FALSE
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

	#define LOGEVENT_DEFAULT	LOGEVENT(@"%@", _ClassSelectorSelf)
	#define LOGEVENT_ERROR	if(error){\
								NSString *logString = [NSString stringWithFormat:@"ERROR: %@", _ClassSelectorSelf];\
								LOGEVENT_FULL(logString, [error essentialParameters], NO);}

#else
	#define LOGEVENT(__FORMAT__, ...)	{}

	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	{}

	#define LOGEVENT_END(identifier, parameters)	{}

	#define LOGEVENT_DEFAULT
	#define LOGEVENT_ERROR

#endif


#endif