

#import "FXDWindow.h"


@implementation FXDsubviewInformation
@end


@implementation FXDWindow

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)makeKeyAndVisible {	FXDLog_SEPARATE;
	[super makeKeyAndVisible];
	
}

#pragma mark - IBActions

#pragma mark - Public

#pragma mark -
- (void)configureRootViewController:(UIViewController*)rootScene shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	//MARK: fade in and replace rootViewController. DO NOT USE addChildViewController
	if (shouldAnimate == NO) {
		if (willBecomeBlock) {
			willBecomeBlock();
		}

		self.rootViewController = rootScene;

		if (didBecomeBlock) {
			didBecomeBlock();
		}

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	UIViewController *previousRootScene = self.rootViewController;

	if (willBecomeBlock) {
		willBecomeBlock();
	}

	self.rootViewController = rootScene;

	[self addSubview:previousRootScene.view];


	if (didBecomeBlock) {
		didBecomeBlock();
	}

	if ([previousRootScene isKindOfClass:[FXDsceneLaunching class]]) {

		[(FXDsceneLaunching*)previousRootScene
		 fadeOutSceneWithCallback:^(BOOL finished, id _Nullable responseObj) {
			 FXDLogBOOL(finished);

			 [previousRootScene.view removeFromSuperview];

			 if (finishCallback) {
				 finishCallback(_cmd, finished, responseObj);
			 }
		 }];

		return;
	}


	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 previousRootScene.view.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {

		 [previousRootScene.view removeFromSuperview];

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)showInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showInformationView) object:nil];
		 [self performSelector:@selector(showInformationView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInformationView) object:nil];
		 [self performSelector:@selector(hideInformationView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showInformationView {

	if (self.informationSubview) {
		return;
	}


	NSString *informationViewNibName = NSStringFromClass([FXDsubviewInformation class]);
	Class informationViewClass = [FXDsubviewInformation class];
	NSBundle *resourceBundle = [NSBundle bundleForClass:informationViewClass];

	UINib *nib = [UINib nibWithNibName:informationViewNibName bundle:resourceBundle];

	if (nib == nil) {
		return;
	}


	//MARK: If nib is manually loaded like this, should it NOT have inheriting Module specified?
	NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];

	for (id subview in viewArray) {	//Assumes there is only one root object

		if ([[subview class] isSubclassOfClass:informationViewClass]) {
			self.informationSubview = (FXDsubviewInformation*)subview;
			break;
		}
	}

	if (self.informationSubview == nil) {
		return;
	}


	CGRect modifiedFrame = self.informationSubview.frame;
	modifiedFrame.size = self.frame.size;
	self.informationSubview.frame = modifiedFrame;

	[self addSubview:self.informationSubview];
	[self bringSubviewToFront:self.informationSubview];


	self.informationSubview.alpha = 0.0;
	self.informationSubview.hidden = NO;

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.informationSubview.alpha = 1.0;
	 }];
}

- (void)hideInformationView {

	if (self.informationSubview == nil) {
		return;
	}


	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.informationSubview.alpha = 0.0;
	 } completion:^(BOOL finished) {
		 [self.informationSubview removeFromSuperview];
		 self.informationSubview = nil;
	 }];
}

@end
