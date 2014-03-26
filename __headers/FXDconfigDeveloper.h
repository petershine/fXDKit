//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigDeveloper_h
#define FXDKit_FXDconfigDeveloper_h


#if DEBUG & ForDEVELOPER
	#ifndef TEST_loggingViewDrawing
		#define TEST_loggingViewDrawing	FALSE
	#endif

	#ifndef TEST_loggingResultObjFiltering
		#define TEST_loggingResultObjFiltering	FALSE
	#endif

	#ifndef TEST_loggingManagedObject
		#define TEST_loggingManagedObject	FALSE
	#endif

	#ifndef TEST_loggingManagedDocumentAutoSaving
		#define TEST_loggingManagedDocumentAutoSaving	FALSE
	#endif

	#ifndef TEST_loggingRotatingOrientation
		#define TEST_loggingRotatingOrientation	FALSE
	#endif

	#ifndef TEST_loggingMemoryWarning
		#define TEST_loggingMemoryWarning	FALSE
	#endif

	#define USE_FXDLog	TRUE

#else
	#define USE_FXDLog	FALSE

#endif


#define strBOOL(boolValue)	(boolValue ? @"YES":@"NO")

#define strSimpleSelector(selector)	[[NSStringFromSelector(selector)\
									componentsSeparatedByString:@":"]\
									firstObject]

#define strCurrentError	[NSString\
						stringWithFormat:@"FILE: %s\nLINE: %d\nDescription: %@\nFailureReason: %@\nUserinfo: %@",\
						__FILE__,\
						__LINE__,\
						[error localizedDescription],\
						[error localizedFailureReason],\
						[error userInfo]]

#define strIsMainThread	[NSString\
						stringWithFormat:@"isMain: %@",\
						strBOOL([NSThread isMainThread])]

#define formattedClassSelector(instance, selector)	[NSString\
													stringWithFormat:@"[%@ %@]",\
													NSStringFromClass([instance class]),\
													NSStringFromSelector(selector)]

#define selfClassSelector	formattedClassSelector(self, _cmd)

#define intervalRemainingBackground	[UIApplication sharedApplication].backgroundTimeRemaining


#if USE_FXDLog
	#define FXDLog	NSLog

	#define FXDLog_EMPTY	FXDLog(@" ")

	#define FXDLogObj(object)		FXDLog(@"%s: %@", #object, object)
	#define FXDLogVar(variable)		FXDLogObj(@(variable))
	#define FXDLogBOOL(boolean)		FXDLogObj(strBOOL(boolean))

	#define FXDLog_IsMainThread	FXDLog(@"THREAD %@", strIsMainThread)

	#define FXDLog_REMAINING	if (intervalRemainingBackground > 0.0\
								&& intervalRemainingBackground != DBL_MAX) {\
									FXDLog(@"intervalRemainingBackground: %f", intervalRemainingBackground);}


	#define FXDLog_DEFAULT	FXDLog_EMPTY;\
							if ([NSThread isMainThread]) {\
								FXDLog(@"%@", selfClassSelector);\
							} else {\
								FXDLog(@"%@ %@", selfClassSelector, strIsMainThread);}


	#define FXDLog_FRAME	FXDLog_EMPTY;\
							FXDLog(@"%@: %@", selfClassSelector, [self.view describeFrameAndBounds])

	#define FXDLog_SEPARATE			FXDLog(@"\n\n	%@", selfClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n	%@: %@", selfClassSelector, [self.view describeFrameAndBounds])

	#define FXDLog_OVERRIDE	FXDLog_EMPTY;\
							FXDLog(@"OVERRIDE: %@", selfClassSelector)


	#define FXDLog_ERROR	if (error) {\
								NSMutableDictionary *parameters = [[error essentialParameters] mutableCopy];\
								parameters[@"file"] = @(__FILE__);\
								parameters[@"line"] = @(__LINE__);\
								FXDLog(@"ERROR: %@\n%@", selfClassSelector, parameters);}

	#define FXDLog_ERROR_ALERT if (error) {\
									[FXDAlertView\
									showAlertWithTitle:selfClassSelector\
									message:strCurrentError\
									clickedButtonAtIndexBlock:nil\
									cancelButtonTitle:nil];}

	#define FXDLog_ERROR_ignored(ignoredCode)	if (error\
												&& [error code] != ignoredCode){\
													FXDLog_ERROR;}


	#define FXDLog_FINISHED	FXDLogBOOL(finished)

	#define FXDLog_BLOCK(instance, selector)	FXDLog_EMPTY;\
												FXDLog(@"BLOCK: [%@ %@] %@",\
												[instance class],\
												strSimpleSelector(selector),\
												strIsMainThread)

	#define FXDLog_REACT(keypath, value)	FXDLog_EMPTY;\
											FXDLog(@"REACT: [%@ %@] %@ %s: %@",\
											NSStringFromClass([self class]),\
											strSimpleSelector(_cmd),\
											strIsMainThread,\
											#keypath,\
											value)


	#define FXDAssert1	NSAssert1
	#define FXDAssert_IsMainThread	FXDAssert1([NSThread isMainThread],\
									@"THREAD %@", strIsMainThread)


#else
	#define FXDLog(__FORMAT__, ...)	{}

	#define FXDLog_EMPTY

	#define FXDLogObj(object)
	#define FXDLogVar(variable)
	#define FXDLogBOOL(boolean)

	#define FXDLog_IsMainThread
	#define FXDLog_REMAINING

	#define FXDLog_DEFAULT
	#define FXDLog_FRAME

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_OVERRIDE


	#define FXDLog_ERROR
	#define FXDLog_ERROR_ALERT
	#define FXDLog_ERROR_ignored(ignoredCode)


	#define FXDLog_BLOCK(instance, selector)
	#define FXDLog_FINISHED

	#define FXDLog_REACT(keypath, value)

	#define FXDAssert1(condition, desc, arg1)	{}
	#define FXDAssert_IsMainThread

#endif


#endif