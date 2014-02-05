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


#warning @"//TODO: If following error occur, import "libz.dylib" for TestFlight\
Undefined symbols for architecture armv7s:\
"_deflate", referenced from:\
__tf_remote_log_compress_data in libTestFlight.a(tf_remote_log_io.o)\
"_deflateInit_", referenced from:\
__tf_remote_log_compress_data in libTestFlight.a(tf_remote_log_io.o)\
"_deflateEnd", referenced from:\
__tf_remote_log_compress_data in libTestFlight.a(tf_remote_log_io.o)\
ld: symbol(s) not found for architecture armv7s\
clang: error: linker command failed with exit code 1 (use -v to see invocation)

#if	USE_TestFlight
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


#if USE_Appsee
	#import <Appsee/Appsee.h>
	#ifndef appseeAPIkey
		#define appseeAPIkey	@"appseeAPIkey"
	#endif
#else

#endif


#endif