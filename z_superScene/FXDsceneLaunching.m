//
//  FXDsceneLaunching.m
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDsceneLaunching.h"


#pragma mark - Public implementation
@implementation FXDsceneLaunching


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	//MARK: Just use default asset name
	if (self.imageviewDefault && self.imageviewDefault.image == nil) {
		self.imageviewDefault.image = [UIImage bundledImageForName:@"LaunchImage"];
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
	__weak FXDsceneLaunching *weakSelf = self;

	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [weakSelf.view setAlpha:0.0];

	 } completion:^(BOOL didFinish) {
		 
		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end