//
//  FXDnumericalValues.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define integerNotDefined	-1


#if TEST_slowAnimationDuration
	#define durationAnimation	2.0
#else
	#define durationAnimation	0.3
#endif

#define durationQuickAnimation	(durationAnimation/2.0)
#define durationSlowAnimation	(durationAnimation*2.0)

#define durationOneSecond	1.0


#define intervalOneSecond	durationOneSecond

#define delayFullMinute		(durationOneSecond*60.0)
#define delayOneSecond		durationOneSecond
#define delayQuarterSecond	0.25
#define delayHalfSecond		0.5
#define delayExtremelyShort	0.01


#define radiusCorner	5.0
#define radiusBigCorner	8.0


#define durationKeyboardAnimation	0.25
#define heightKeyboard_iPhone	216.0
#define heightKeyboard_iPad	352.0

#define alphaValue05	0.5


#define dimensionMinimumTouchable	44.0

#define heightNavigationBar	44.0
#define heightToolBar	heightNavigationBar	//MARK: Assume they are identical
#define heightStatusBar	[[UIApplication sharedApplication] statusBarFrame].size.height


#define marginDefault	8.0


#define limitConcurrentOperationCount	1
