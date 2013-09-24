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
		#define TEST_loggingRotatingOrientation	0
		#define TEST_loggingViewDrawing	0
		#define TEST_loggingResultObjFiltering	0

		#define TEST_loggingManagedObject	0

		#ifndef TEST_loggingManagedDocumentAutoSaving
			#define TEST_loggingManagedDocumentAutoSaving	0
		#endif

		#define USE_FXDLog	1

	#else
		#define USE_FXDLog	0
	#endif

#else
	#define USE_FXDLog	0
#endif


#define strClassSelector	[NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]

#define intervalRemainingBackground	([UIApplication sharedApplication].backgroundTimeRemaining > 0.0 && [UIApplication sharedApplication].backgroundTimeRemaining != DBL_MAX) ? ([UIApplication sharedApplication].backgroundTimeRemaining):0.0


#if USE_FXDLog
	#define FXDLog NSLog

	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", strClassSelector)
	#define FXDLog_FRAME	FXDLog(@" ");FXDLog(@"%@: %@", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", strClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@: %@ __", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", strClassSelector)

	#define FXDLog_ERROR	if(error){FXDLog(@" ");FXDLog(@"\n\n%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %ld\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], (long)[error code], [error userInfo]);}

	#define FXDLog_ERROR_SIMPLE	if(error){FXDLog(@" ");FXDLog(@"\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", [error localizedDescription], [error domain], [error code], [error userInfo]);}

	#define FXDLog_ERRORexcept(v)	if(error){if([error code]!=v){FXDLog_ERROR;}}

	#define FXDLog_REMAINING	if(intervalRemainingBackground > 0.0){if((NSInteger)(intervalRemainingBackground)%2 == 0) {FXDLog(@"intervalRemainingBackground: %f", intervalRemainingBackground);}}


#else
	#define FXDLog(format, ...)	{}

	#define FXDLog_DEFAULT
	#define FXDLog_FRAME

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_OVERRIDE

	#define FXDLog_ERROR
	#define FXDLog_ERROR_SIMPLE
	#define FXDLog_ERRORexcept(v)

	#define FXDLog_REMAINING

#endif


#endif