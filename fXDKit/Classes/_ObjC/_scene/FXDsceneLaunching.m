

#import "FXDsceneLaunching.h"


@implementation FXDsceneLaunching

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (BOOL)shouldAutorotate {
	return NO;
}

- (void)fadeOutSceneWithCallback:(void(^)(BOOL finished, id _Nullable responseObj))callback {
	__weak typeof(self) weakSelf = self;

	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 (weakSelf.view).alpha = 0.0;

	 } completion:^(BOOL finished) {

		 if (callback) {
			 callback(finished, nil);
		 }
	 }];
}
@end
