

#ifndef FXDKit_FXDconfigDeveloper_h
#define FXDKit_FXDconfigDeveloper_h


#if ForDEVELOPER
	#define USE_FXDLog	TRUE
#else
	#define USE_FXDLog	FALSE
#endif


#define _Object(object)		[NSString stringWithFormat:@"%s: %@", #object, object]
#define _Struct(struct)		[NSString stringWithFormat:@"%s: %@", #struct, [NSValue valueWithBytes:&struct objCType:@encode(typeof(struct))]]
#define _Variable(variable)	[NSString stringWithFormat:@"%s: %@", #variable, @(variable)]
#define _BOOL(boolean)		[NSString stringWithFormat:@"%s: %@", #boolean, (boolean ? @"YES":@"NO")]
#define _Selector(selector)	[NSString stringWithFormat:@"%s: %@", #selector, NSStringFromSelector(selector)]

#define _Point(point)			[NSString stringWithFormat:@"%s: %@", #point, NSStringFromCGPoint(point)]
#define _Size(size)				[NSString stringWithFormat:@"%s: %@", #size, NSStringFromCGSize(size)]
#define _Rect(rect)				[NSString stringWithFormat:@"%s: %@", #rect, NSStringFromCGRect(rect)]
#define _Transform(transform)	[NSString stringWithFormat:@"%s: %@", #transform, NSStringFromCGAffineTransform(transform)]

#define _Time(time)				[NSString stringWithFormat:@"%s: %@", #time, ValueOfTime(time)]
#define _TimeRange(timeRange)	[NSString stringWithFormat:@"%s: %@", #timeRange, ValueOfTimeRange(timeRange)]


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
	#define FXDLog(__FORMAT__, ...)	NSLog(__FORMAT__, ##__VA_ARGS__)

	#define FXDLog_EMPTY	FXDLog(@" ")

	#define FXDLogObject(object)		FXDLog(@"%@", _Object(object))
	#define FXDLogStruct(struct)		FXDLog(@"%@", _Struct(struct))
	#define FXDLogVariable(variable)	FXDLog(@"%@", _Variable(variable))
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

	#define FXDLog_VIEW		FXDLog_EMPTY;\
							if ([NSThread isMainThread]) {\
								FXDLog(@"%@ %@ %@", _ClassSelectorSelf, _Rect(self.view.frame), _Rect(self.view.bounds));\
							} else {\
								FXDLog(@"%@ %@ %@ %@", _ClassSelectorSelf, _Rect(self.view.frame), _Rect(self.view.bounds), _IsMainThread);}

	#define FXDLog_SEPARATE	if ([NSThread isMainThread]) {\
								FXDLog(@"\n\n	%@", _ClassSelectorSelf);\
							} else {\
								FXDLog(@"\n\n	%@ %@", _ClassSelectorSelf, _IsMainThread);}

	#define FXDLog_OVERRIDE	FXDLog_EMPTY;\
							if ([NSThread isMainThread]) {\
								FXDLog(@"OVERRIDE: %@", _ClassSelectorSelf);\
							} else {\
								FXDLog(@"OVERRIDE: %@ %@", _ClassSelectorSelf, _IsMainThread);}


	#define FXDLog_ERROR	if (error) {\
								FXDLog_EMPTY;\
								FXDLog(@"ERROR: %@\n%@", _ClassSelectorSelf, _Error(error));}


	#define FXDLog_ERROR_ignored(ignoredCode)	if (error\
												&& [error code] != ignoredCode){\
													FXDLog_ERROR;\
												} else {\
													FXDLogVariable(ignoredCode);}


	#define FXDLog_BLOCK(instance, caller)	FXDLog_EMPTY;\
											if ([NSThread isMainThread]) {\
												FXDLog(@"%@ %@: ^[%@ %@]",\
												[self class],\
												_SelectorShort(_cmd),\
												[instance class],\
												_SelectorShort(caller));\
											} else {\
												FXDLog(@"%@ %@: ^[%@ %@] %@",\
												[self class],\
												_SelectorShort(_cmd),\
												[instance class],\
												_SelectorShort(caller),\
												_IsMainThread);}



	#define FXDLog_REACT(value)	FXDLog_EMPTY;\
								if ([NSThread isMainThread]) {\
									FXDLog(@"REACT: %@ %s: %@",\
									_ClassSelectorSelf,\
									#value,\
									value);\
								} else {\
									FXDLog(@"REACT: %@ %@ %s: %@",\
									_ClassSelectorSelf,\
									_IsMainThread,\
									#value,\
									value);}

	#define FXDAssert_IsMainThread	NSAssert([NSThread isMainThread], nil)


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
	#define FXDLog_VIEW
	#define FXDLog_SEPARATE
	#define FXDLog_OVERRIDE


	#define FXDLog_ERROR	if (error) {}
	#define FXDLog_ERROR_ignored(ignoredCode)	if (error) {}


	#define FXDLog_BLOCK(instance, caller)

	#define FXDLog_REACT(value)

	#define FXDAssert_IsMainThread


#endif


#endif