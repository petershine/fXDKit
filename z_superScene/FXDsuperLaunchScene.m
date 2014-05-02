//
//  FXDsuperLaunchScene.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDsuperLaunchScene.h"


#pragma mark - Public implementation
@implementation FXDsuperLaunchScene


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	if (self.imageviewDefault && self.imageviewDefault.image == nil) {
		if (SCREEN_SIZE_35inch) {
			self.imageviewDefault.image = [UIImage bundledImageForName:imageDefaulLaunch];
		}
		else {
			self.imageviewDefault.image = [UIImage bundledImageForName:imageDefaulLaunch568h];
		}
	}
}

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
- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)finishCallback {
	__weak FXDsuperLaunchScene *weakSelf = self;

	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [weakSelf.view setAlpha:0.0];

	 } completion:^(BOOL finished) {
		 
		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end