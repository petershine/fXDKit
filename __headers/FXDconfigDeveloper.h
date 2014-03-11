//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigDeveloper_h
#define FXDKit_FXDconfigDeveloper_h


#if DEBUG
	#if ForDEVELOPER
		#ifndef TEST_loggingViewDrawing
			#define TEST_loggingViewDrawing	0
		#endif

		#ifndef TEST_loggingResultObjFiltering
			#define TEST_loggingResultObjFiltering	0
		#endif

		#ifndef TEST_loggingManagedObject
			#define TEST_loggingManagedObject	0
		#endif

		#ifndef TEST_loggingManagedDocumentAutoSaving
			#define TEST_loggingManagedDocumentAutoSaving	0
		#endif

		#ifndef TEST_loggingRotatingOrientation
			#define TEST_loggingRotatingOrientation	0
		#endif

		#define USE_FXDLog	1

	#else
		#define USE_FXDLog	0
	#endif

#else
	#define USE_FXDLog	0
#endif


#define formattedClassSelector(instance, identifier)	[NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([instance class]), NSStringFromSelector(identifier)]

#define selfClassSelector	formattedClassSelector(self, _cmd)

#define intervalRemainingBackground	(([UIApplication sharedApplication].backgroundTimeRemaining > 0.0 && [UIApplication sharedApplication].backgroundTimeRemaining != DBL_MAX) ? ([UIApplication sharedApplication].backgroundTimeRemaining):0.0)


#if USE_FXDLog
	#define FXDLog NSLog

	#define FXDLog_isMainThread	FXDLog(@"isMainThread: %@", ([NSThread isMainThread]) ? @"YES":@"NO")

	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", selfClassSelector);\
							if([NSThread isMainThread]==NO){FXDLog_isMainThread;}

	#define FXDLog_FRAME	FXDLog(@" ");FXDLog(@"%@: %@", selfClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", selfClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@: %@ __", selfClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", selfClassSelector)


	#define FXDLog_ERROR	if(error){\
								NSMutableDictionary *parameters = [[error essentialParameters] mutableCopy];\
								parameters[@"file"] = @(__FILE__);\
								parameters[@"line"] = @(__LINE__);\
								FXDLog_DEFAULT;\
								FXDLog(@"parameters: %@", parameters);}

	#define FXDLog_ERROR_ALERT	FXDLog_ERROR;\
								if(error){\
									NSString *title = [NSString stringWithFormat:@"%@", selfClassSelector];\
									NSString *message = [NSString stringWithFormat:@"FILE: %s\nLINE: %d\nDescription: %@\nFailureReason: %@\nUserinfo: %@", __FILE__, __LINE__, [error localizedDescription], [error localizedFailureReason], [error userInfo]];\
									[FXDAlertView showAlertWithTitle:title message:message clickedButtonAtIndexBlock:nil cancelButtonTitle:nil];}

	#define FXDLog_ERRORexcept(v)	if(error && [error code]!=v) {\
										FXDLog_ERROR;}


	#define FXDLog_REMAINING	if(intervalRemainingBackground != 0.0\
									&& (NSInteger)(intervalRemainingBackground)%2 == 0){\
									FXDLog(@"intervalRemainingBackground: %f", intervalRemainingBackground);}

	#define FXDLog_Block(instance, identifier)	FXDLog(@" ");FXDLog(@"BLOCK: %@", formattedClassSelector(instance, identifier));FXDLog_isMainThread


	#define FXDAssert1	NSAssert1
	#define FXDAssert_MainThread	FXDAssert1([NSThread isMainThread], @"[NSThread isMainThread]: %@", ([NSThread isMainThread]) ? @"YES":@"NO")


#else
	#define FXDLog(format, ...)	{}

	#define FXDLog_isMainThread

	#define FXDLog_DEFAULT
	#define FXDLog_FRAME

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_OVERRIDE

	#define FXDLog_ERROR
	#define FXDLog_ERROR_ALERT
	#define FXDLog_ERRORexcept(v)

	#define FXDLog_REMAINING

	#define FXDLog_Block(instance, block)


	#define FXDAssert1(condition, desc, arg1)	{}
	#define FXDAssert_MainThread


#endif


#endif