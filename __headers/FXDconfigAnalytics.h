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
		#ifndef USE_TestFlight
			#define USE_TestFlight	0
		#endif

	#else
		#ifndef USE_TestFlight
			#define USE_TestFlight	1
		#endif

	#endif

#else
	#ifndef USE_TestFlight
		#define USE_TestFlight	0
	#endif

#endif


#ifndef USE_Flurry
	#define USE_Flurry	1
#endif


#if	USE_TestFlight	//TODO: import "libz.dylib" for TestFlight
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


#endif


//MARK: For TestFlight
/*
 void HandleExceptions(NSException *exception) {
 FXDLog(@"exception: %@", exception);
 }
 
 void SignalHandler(int sig) {
 FXDLog(@"sig: %d", sig);
 }
*/

/*
 NSSetUncaughtExceptionHandler(&HandleExceptions);
 
 struct sigaction newSignalAction;
 memset(&newSignalAction, 0, sizeof(newSignalAction));
 newSignalAction.sa_handler = &SignalHandler;
 
 sigaction(SIGABRT, &newSignalAction, NULL);
 sigaction(SIGILL, &newSignalAction, NULL);
 sigaction(SIGBUS, &newSignalAction, NULL);
*/