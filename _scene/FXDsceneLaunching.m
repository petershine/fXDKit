

#import "FXDsceneLaunching.h"


@implementation FXDsceneLaunching

#pragma mark - Memory management
- (void)dealloc {    FXDLog_DEFAULT;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


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
		 (weakSelf.view).alpha = 0.0;

	 } completion:^(BOOL didFinish) {
		 
		 if (callback) {
			 callback(_cmd, YES, nil);
		 }
	 }];
}

@end
