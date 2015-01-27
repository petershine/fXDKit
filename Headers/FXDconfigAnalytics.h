

#ifndef FXDKit_FXDconfigAnalytics_h
#define FXDKit_FXDconfigAnalytics_h


#ifndef USE_Crashlytics
	#define USE_Crashlytics	TRUE
#endif

#if USE_Crashlytics
	#import <Fabric/Fabric.h>
	#import <Crashlytics/Crashlytics.h>

	#define CLSEvent_DEFAULT	CLSLog(@"%@", _ClassSelectorSelf)
	#define CLSEvent_CMD	CLSLog(@"%@", NSStringFromSelector(_cmd))
	#define CLSEvent_ERROR	if(error){CLSLog(@"%@", [error essentialParameters]);}
#else

	#define CLSEvent_DEFAULT
	#define CLSEvent_CMD
	#define CLSEvent_ERROR
#endif


#ifndef USE_Flurry
	#define USE_Flurry	FALSE
#endif


#if USE_Flurry
	#ifndef flurryApplicationKey
		#warning //TODO: Define flurryApplicationKey
		#define	flurryApplicationKey	@"flurryApplicationKey"
	#endif

	#import "Flurry.h"

	#define LOGEVENT(__FORMAT__, ...)	[[NSOperationQueue mainQueue]\
										addOperationWithBlock:^{\
										[Flurry\
										logEvent:[NSString stringWithFormat:__FORMAT__,\
										##__VA_ARGS__]];}]

	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	[[NSOperationQueue mainQueue]\
																addOperationWithBlock:^{\
																[Flurry\
																logEvent:identifier\
																withParameters:parameters\
																timed:shouldTime];}]

	#define LOGEVENT_END(identifier, parameters)	[[NSOperationQueue mainQueue]\
													addOperationWithBlock:^{\
													[Flurry\
													endTimedEvent:identifier\
													withParameters:parameters];}]

	#define LOGEVENT_DEFAULT	LOGEVENT(@"%@", _ClassSelectorSelf)
	#define LOGEVENT_CMD	LOGEVENT(@"%@", NSStringFromSelector(_cmd))
	#define LOGEVENT_ERROR	if(error){\
								NSString *logString = [NSString stringWithFormat:@"ERROR: %@", NSStringFromSelector(_cmd)];\
								LOGEVENT_FULL(logString, [error essentialParameters], NO);}


	#define LOGEVENT_ALERT(alertView, didCancel)	NSDictionary *parameters = @{\
													@"title": (alertView.title.length > 0) ? alertView.title:@"",\
													@"message": (alertView.message.length > 0) ? alertView.message:@"",\
													@"didCancel": (didCancel) ? @"YES":@"NO"};\
													LOGEVENT_FULL((alertView.title.length > 0) ? alertView.title:NSStringFromSelector(_cmd), parameters, NO);


#else
	#define LOGEVENT(__FORMAT__, ...)	{}

	#define LOGEVENT_FULL(identifier, parameters, shouldTime)	{}

	#define LOGEVENT_END(identifier, parameters)	{}

	#define LOGEVENT_DEFAULT
	#define LOGEVENT_CMD
	#define LOGEVENT_ERROR


	#define LOGEVENT_ALERT(alertView, didCancel)

#endif


#endif