//
//  FXDsceneLaunching.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDsceneLaunching.h"



@implementation FXDsceneLaunching


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - StatusBar
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}


#pragma mark - Autorotating
- (BOOL)shouldAutorotate {
	return NO;
}


#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)callback {
	__weak FXDsceneLaunching *weakSelf = self;

	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [weakSelf.view setAlpha:0.0];

	 } completion:^(BOOL didFinish) {
		 
		 if (callback) {
			 callback(_cmd, YES, nil);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end