//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#if DEBUG
	#if ForDEVELOPER
		#define USE_loggingViewControllerLifeCycle	0
		#define USE_loggingRotatingOrientation	0
		#define USE_loggingViewDrawing	0
		#define USE_loggingBorderLine	0
		#define USE_loggingResultObjFiltering	0
		#define USE_loggingManagedObjectActivities	0

		#define TEST_withSlowAnimationDuration	0
		#define TEST_appirater	1

		#define USE_FXDLog	1
	#else
		#define USE_FXDLog	0
	#endif

#else
	#define USE_FXDLog	0
#endif


//#define strClassSelector	[NSString stringWithFormat:@"%@%s", NSStringFromClass([self class]), __FUNCTION__]
#define strClassSelector	[NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]

#if USE_FXDLog
	#define FXDLog NSLog

	#define FXDLog_DEFAULT	FXDLog(@" ");FXDLog(@"%@", strClassSelector)

	#define FXDLog_SEPARATE			FXDLog(@"\n\n__  %@  __", strClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n__  %@: %@ __", strClassSelector, NSStringFromCGRect(self.view.frame))

	#define FXDLog_VIEW_FRAME	FXDLog(@" ");FXDLog(@"%@: %@", strClassSelector, NSStringFromCGRect(self.frame));

	#define FXDLog_OVERRIDE	FXDLog(@" ");FXDLog(@"OVERRIDE: %@", strClassSelector)

	#define FXDLog_NOTIFIED	FXDLog(@" ");FXDLog(@"NOTIFIED: %@: %@", NSStringFromClass([self class]), note.name)


	#define FXDLog_ERROR	if(error){FXDLog(@" ");FXDLog(@"\n\n%@\nfile: %s\nline: %d\n\nlocalizedDescription: %@\ndomain: %@\ncode: %d\nuserInfo:\n%@\n\n", strClassSelector, __FILE__, __LINE__, [error localizedDescription], [error domain], [error code], [error userInfo]);}

	#define FXDLog_ERRORexcept(v)	if(error){if([error code]!=v){FXDLog_ERROR;}}


#else
	#define FXDLog(format, ...)	{}

	#define FXDLog_DEFAULT

	#define FXDLog_SEPARATE
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_VIEW_FRAME

	#define FXDLog_OVERRIDE

	#define FXDLog_NOTIFIED

	#define FXDLog_ERROR
	#define FXDLog_ERRORexcept(v)

#endif


#ifndef SYSTEM_VERSION_lowerThan
	#define SYSTEM_VERSION_lowerThan(versionNumber)	([[[UIDevice currentDevice] systemVersion] floatValue] < versionNumber)
#endif


#ifndef SCREEN_SIZE_35inch
	#define SCREEN_SIZE_35inch	(MAX([[FXDWindow applicationWindow] bounds].size.width, [[FXDWindow applicationWindow] bounds].size.height) <= 480.0)
#endif


#ifndef DEVICE_IDIOM_iPad
	#define DEVICE_IDIOM_iPad	(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#endif


#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;\
static id _sharedInstance = nil;\
dispatch_once(&once,^{\
	_sharedInstance = [[[self class] alloc] init];\
});\
return _sharedInstance
