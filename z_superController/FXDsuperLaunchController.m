//
//  FXDsuperLaunchImageController.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDsuperLaunchController.h"


#pragma mark - Public implementation
@implementation FXDsuperLaunchController


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
- (void)dismissLaunchControllerWithFinishCallback:(FXDcallbackFinish)finishCallback {
	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [self.view setAlpha:0.0];
	 } completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 
		 if (finishCallback) {
			 finishCallback(YES, nil, _cmd);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end