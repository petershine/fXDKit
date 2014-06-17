//
//  FXDconfigDeveloper.h
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigDeveloper_h
#define FXDKit_FXDconfigDeveloper_h


#if DEBUG & ForDEVELOPER
	#define USE_FXDLog	TRUE

#else
	#define USE_FXDLog	FALSE

#endif


#define _Object(object)		[[NSString stringWithFormat:@"%s: %@", #object, object] replacedSelf]
#define _Struct(struct)		[[NSString stringWithFormat:@"%s: %@", #struct, [NSValue valueWithBytes:&struct objCType:@encode(typeof(struct))]] replacedSelf]
#define _Variable(variable)	[[NSString stringWithFormat:@"%s: %@", #variable, @(variable)] replacedSelf]
#define _BOOL(boolean)		[[NSString stringWithFormat:@"%s: %@", #boolean, (boolean ? @"YES":@"NO")] replacedSelf]
#define _Selector(selector)	[[NSString stringWithFormat:@"%s: %@", #selector, NSStringFromSelector(selector)] replacedSelf]

#define _Point(point)			[[NSString stringWithFormat:@"%s: %@", #point, NSStringFromCGPoint(point)] replacedSelf]
#define _Size(size)				[[NSString stringWithFormat:@"%s: %@", #size, NSStringFromCGSize(size)] replacedSelf]
#define _Rect(rect)				[[NSString stringWithFormat:@"%s: %@", #rect, NSStringFromCGRect(rect)] replacedSelf]
#define _Transform(transform)	[[NSString stringWithFormat:@"%s: %@", #transform, NSStringFromCGAffineTransform(transform)] replacedSelf]

#define _Time(time)				[[NSString stringWithFormat:@"%s: %@", #time, ValueOfTime(time)] replacedSelf]
#define _TimeRange(timeRange)	[[NSString stringWithFormat:@"%s: %@", #timeRange, ValueOfTimeRange(timeRange)] replacedSelf]


#define _Orientation	[NSString stringWithFormat:@"statusBarOrientation: %ld", (long)[UIApplication sharedApplication].statusBarOrientation]


#define _Error(error)	[NSString\
						stringWithFormat:@"FILE: %s\nLINE: %d\n%@",\
						__FILE__,\
						__LINE__,\
						[error essentialParameters]]

#define _IsMainThread	[NSString\
						stringWithFormat:@"mainThread: %@",\
						([NSThread isMainThread] ? @"YES":@"NO")]


#define _SelectorShort(selector)	[[NSStringFromSelector(selector)\
									componentsSeparatedByString:@":"]\
									firstObject]

#define _ClassSelector(instance, selector)	[NSString\
											stringWithFormat:@"[%@ %@]",\
											NSStringFromClass([instance class]),\
											NSStringFromSelector(selector)]

#define _ClassSelectorSelf	_ClassSelector(self, _cmd)



#if USE_FXDLog
	#define FXDLog	NSLog

	#define FXDLog_EMPTY	FXDLog(@" ")

	#define FXDLogObject(object)		FXDLog(@"%@", _Object(object))
	#define FXDLogStruct(struct)		FXDLog(@"%@", _Struct(struct))
	#define FXDLogVariable(variable)			FXDLog(@"%@", _Variable(variable))
	#define FXDLogBOOL(boolean)			FXDLog(@"%@", _BOOL(boolean))
	#define FXDLogSelector(selector)	FXDLog(@"%@", _Selector(selector))

	#define FXDLogPoint(point)			FXDLog(@"%@", _Point(point))
	#define FXDLogSize(size)			FXDLog(@"%@", _Size(size))
	#define FXDLogRect(rect)			FXDLog(@"%@", _Rect(rect))
	#define FXDLogTransform(transform)	FXDLog(@"%@", _Transform(transform))

	#define FXDLogTime(time)			FXDLog(@"%@", _Time(time))
	#define FXDLogTimeRange(timeRange)	FXDLog(@"%@", _TimeRange(timeRange))


	#define FXDLog_IsMainThread	if ([NSThread isMainThread] == NO) {\
									FXDLog(@"%@ [%@ %@]",\
									_BOOL([NSThread isMainThread]),\
									[self class],\
									_SelectorShort(_cmd));}


	#define FXDLog_REMAINING	if ([UIApplication sharedApplication].backgroundTimeRemaining > 0.0\
								&& [UIApplication sharedApplication].backgroundTimeRemaining != DBL_MAX) {\
									FXDLogVariable([UIApplication sharedApplication].backgroundTimeRemaining);}


	#define FXDLog_DEFAULT	FXDLog_EMPTY;\
							if ([NSThread isMainThread]) {\
								FXDLog(@"%@", _ClassSelectorSelf);\
							} else {\
								FXDLog(@"%@ %@", _ClassSelectorSelf, _IsMainThread);}

	#define FXDLog_SEPARATE		FXDLog(@"\n\n	%@", _ClassSelectorSelf)


	#define FXDLog_FRAME	FXDLog_EMPTY;\
							FXDLog(@"%@: %@ %@", _ClassSelectorSelf, _Rect(self.view.frame), _Rect(self.view.bounds))

	#define FXDLog_SEPARATE_FRAME	FXDLog(@"\n\n	%@: %@ %@", _ClassSelectorSelf, _Rect(self.view.frame), _Rect(self.view.bounds))


	#define FXDLog_OVERRIDE	FXDLog_EMPTY;\
							FXDLog(@"OVERRIDE: %@", _ClassSelectorSelf)


	#define FXDLog_ERROR	if (error) {\
								FXDLog_EMPTY;\
								FXDLog(@"ERROR: %@\n%@", _ClassSelectorSelf, _Error(error));}\
							LOGEVENT_ERROR

	#define FXDLog_ERROR_ALERT if (error) {\
									[FXDAlertView\
									showAlertWithTitle:_ClassSelectorSelf\
									message:_Error(error)\
									cancelButtonTitle:nil\
									withAlertCallback:nil];\
									[[UIApplication sharedApplication]\
									 localNotificationWithAlertBody:_Error(error)\
									 afterDelay:0.0];}

	#define FXDLog_ERROR_ignored(ignoredCode)	if (error\
												&& [error code] != ignoredCode){\
													FXDLog_ERROR;}


	#define FXDLog_BLOCK(instance, caller)	FXDLog_EMPTY;\
											if ([NSThread isMainThread]) {\
												FXDLog(@"%@: ^[%@ %@]",\
												[self class],\
												[instance class],\
												_SelectorShort(caller));\
											} else {\
												FXDLog(@"%@: ^[%@ %@] %@",\
												[self class],\
												[instance class],\
												_SelectorShort(caller),\
												_IsMainThread);}



	#define FXDLog_REACT(keypath, value)	FXDLog_EMPTY;\
											if ([NSThread isMainThread]) {\
												FXDLog(@"REACT: [%@] %s: %@",\
												NSStringFromClass([self class]),\
												#keypath,\
												value);\
											} else {\
												FXDLog(@"REACT: [%@] %@ %s: %@",\
												NSStringFromClass([self class]),\
												_IsMainThread,\
												#keypath,\
												value);}

	#define FXDAssert_IsMainThread	NSAssert([NSThread isMainThread], nil)
	#define FXDAssert(queue)	NSAssert(queue, nil)

#else
	#define FXDLog(__FORMAT__, ...)	{}

	#define FXDLog_EMPTY

	#define FXDLogObject(object)
	#define FXDLogStruct(struct)
	#define FXDLogVariable(variable)
	#define FXDLogBOOL(boolean)
	#define FXDLogSelector(selector)

	#define FXDLogPoint(point)
	#define FXDLogSize(size)
	#define FXDLogRect(rect)
	#define FXDLogTransform(transform)

	#define FXDLogTime(time)
	#define FXDLogTimeRange(timeRange)


	#define FXDLog_IsMainThread


	#define FXDLog_REMAINING

	#define FXDLog_DEFAULT
	#define FXDLog_SEPARATE

	#define FXDLog_FRAME
	#define FXDLog_SEPARATE_FRAME

	#define FXDLog_OVERRIDE


	#define FXDLog_ERROR	LOGEVENT_ERROR
	#define FXDLog_ERROR_ALERT
	#define FXDLog_ERROR_ignored(ignoredCode)


	#define FXDLog_BLOCK(instance, caller)

	#define FXDLog_REACT(keypath, value)

	#define FXDAssert_IsMainThread
	#define FXDAssert(queue)

#endif


#endif