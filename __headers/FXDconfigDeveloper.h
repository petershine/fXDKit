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


#define _Object(object)		[[NSString stringWithFormat:@"%s: %@", #object, object] replacedSelf]
#define _Struct(struct)		[[NSString stringWithFormat:@"%s: %@", #struct, [NSValue valueWithBytes:&struct objCType:@encode(typeof(struct))]] replacedSelf]
#define _Variable(variable)	[[NSString stringWithFormat:@"%s: %@", #variable, @(variable)] replacedSelf]
#define _BOOL(boolean)		[[NSString stringWithFormat:@"%s: %@", #boolean, (boolean ? @"YES":@"NO")] replacedSelf]
#define _Selector(selector)	[[NSString stringWithFormat:@"%s: %@", #selector, NSStringFromSelector(selector)] replacedSelf]

#define _Point(point)	[[NSString stringWithFormat:@"%s: %@", #point, NSStringFromCGPoint(point)] replacedSelf]
#define _Size(size)	[[NSString stringWithFormat:@"%s: %@", #size, NSStringFromCGSize(size)] replacedSelf]
#define _Rect(rect)	[[NSString stringWithFormat:@"%s: %@", #rect, NSStringFromCGRect(rect)] replacedSelf]


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
						stringWithFormat:@"mainQueue: %@",\
						([NSThread isMainThread] ? @"YES":@"NO")]


#define formattedClassSelector(instance, selector)	[NSString\
													stringWithFormat:@"[%@ %@]",\
													NSStringFromClass([instance class]),\
													NSStringFromSelector(selector)]

#define selfClassSelector	formattedClassSelector(self, _cmd)


#if USE_FXDLog
	#define FXDLog	NSLog

	#define FXDLog_EMPTY	FXDLog(@" ")

	#define FXDLogObject(object)		FXDLog(@"%@", _Object(object))
	#define FXDLogStruct(struct)		FXDLog(@"%@", _Struct(struct))
	#define FXDLogVar(variable)			FXDLog(@"%@", _Variable(variable))
	#define FXDLogBOOL(boolean)			FXDLog(@"%@", _BOOL(boolean))
	#define FXDLogSelector(selector)	FXDLog(@"%@", _Selector(selector))

	#define FXDLogPoint(point)		FXDLog(@"%@", _Point(point))
	#define FXDLogSize(size)		FXDLog(@"%@", _Size(size))
	#define FXDLogRect(rect)		FXDLog(@"%@", _Rect(rect))

	#define FXDLog_IsMainThread	FXDLog(@"THREAD %@", strIsMainThread)

	#define FXDLog_REMAINING	if (intervalRemainingBackground > 0.0\
								&& intervalRemainingBackground != DBL_MAX) {\
									FXDLogVar(intervalRemainingBackground);}


	#define FXDLog_DEFAULT	FXDLog_EMPTY;\
							if ([NSThread isMainThread]) {\
								FXDLog(@"%@", selfClassSelector);\
							} else {\
								FXDLog(@"%@ %@", selfClassSelector, strIsMainThread);}


	#define FXDLog_FRAME	FXDLog_EMPTY;\
							FXDLog(@"%@: %@ %@", selfClassSelector, _Rect(self.view.frame), _Rect(self.view.bounds))

	#define FXDLog_SEPARATE			FXDLog(@"\n\n	%@", selfClassSelector)
	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n	%@: %@ %@", selfClassSelector, _Rect(self.view.frame), _Rect(self.view.bounds))

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
									cancelButtonTitle:nil\
									withAlertCallback:nil];}

	#define FXDLog_ERROR_ignored(ignoredCode)	if (error\
												&& [error code] != ignoredCode){\
													FXDLog_ERROR;}


	#define FXDLog_BLOCK(instance, selector)	FXDLog_EMPTY;\
												FXDLog(@"BLOCK: [%@ %@] %@",\
												[instance class],\
												strSimpleSelector(selector),\
												strIsMainThread)

	#define FXDLog_REACT(keypath, value)	FXDLog_EMPTY;\
											FXDLog(@"REACT: [%@ %@] %@ %s: %@",\
											NSStringFromClass([self class]),\
											NSStringFromSelector(_cmd),\
											strIsMainThread,\
											#keypath,\
											value)

#else
	#define FXDLog(__FORMAT__, ...)	{}

	#define FXDLog_EMPTY

	#define FXDLogObject(object)
	#define FXDLogStruct(struct)
	#define FXDLogVar(variable)
	#define FXDLogBOOL(boolean)
	#define FXDLogSelector(selector)

	#define FXDLogPoint(point)
	#define FXDLogSize(size)
	#define FXDLogRect(rect)

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

	#define FXDLog_REACT(keypath, value)

#endif


#endif