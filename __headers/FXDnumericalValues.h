//
//  FXDnumericalValues.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDnumericalValues_h
#define FXDKit_FXDnumericalValues_h


#define integerNotDefined	-1

#define doubleOneBillion	1000000000.0
#define doubleOneMillion	1000000.0
#define doubleOneThousand	1000.0
#define doubleSecondsInDay	(60.0*60.0*24.0)

#define durationAnimation	(1.0/3.0)
#define durationQuickAnimation	(durationAnimation/2.0)
#define durationSlowAnimation	(durationAnimation*2.0)

#define durationOneSecond	1.0

#define delayFullMinute		(durationOneSecond*60.0)
#define delayOneSecond		durationOneSecond
#define delayQuarterSecond	(durationOneSecond/4.0)
#define delayHalfSecond		(durationOneSecond/2.0)
#define delayExtremelyShort	(durationOneSecond/100.0)

#define intervalOneSecond	durationOneSecond


#define radiusCorner	5.0
#define radiusBigCorner	8.0


#define durationKeyboardAnimation	0.25
#define heightKeyboard_iPhone	216.0
#define heightKeyboard_iPad		352.0

#define alphaValue03	0.3
#define alphaValue05	0.5
#define alphaValue08	0.8


#define dimensionMinimumTouchable	44.0


#define heightStatusBar	20.0


#define heightNavigationBar	44.0
#define heightToolBar	heightNavigationBar


#define height35inch	480.0
#define height40inch	568.0

#define marginDefault	8.0

#define limitConcurrentOperationCount	1


#define rotationAngleLandscapeLeft	90.0
#define rotationAngleLandscapeRight	270.0

#endif