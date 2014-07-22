

#import "FXDWindow.h"

#import "FXDviewInformation.h"

#import "FXDsceneLaunching.h"


@implementation FXDWindow

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
}

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)makeKeyAndVisible {	FXDLog_SEPARATE;
	[super makeKeyAndVisible];
}

#pragma mark - IBActions

#pragma mark - Public
- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene {	FXDLog_DEFAULT;
	if (launchScene == nil) {
		launchScene = [[FXDsceneLaunching alloc] initWithNibName:nil bundle:nil];
	}

	CGRect modifiedFrame = launchScene.view.frame;
	modifiedFrame.size.height = self.frame.size.height;
	launchScene.view.frame = modifiedFrame;

	modifiedFrame = launchScene.imageviewDefault.frame;
	modifiedFrame.origin.y = 0.0;
	modifiedFrame.size.height = self.frame.size.height;
	launchScene.imageviewDefault.frame = modifiedFrame;

	self.rootViewController = launchScene;
}

- (void)configureRootViewController:(UIViewController*)rootScene shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	//MARK: fade in and replace rootViewController. DO NOT USE addChildViewController
	if (shouldAnimate == NO) {
		if (willBecomeBlock) {
			willBecomeBlock();
		}

		[self setRootViewController:rootScene];

		if (didBecomeBlock) {
			didBecomeBlock();
		}

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	if (willBecomeBlock) {
		willBecomeBlock();
	}

	UIViewController *launchScene = self.rootViewController;

	[self setRootViewController:rootScene];

	[self addSubview:launchScene.view];


	if (didBecomeBlock) {
		didBecomeBlock();
	}

	if ([launchScene isKindOfClass:[FXDsceneLaunching class]]) {

		[(FXDsceneLaunching*)launchScene
		 dismissLaunchSceneWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
			 FXDLog_BLOCK(launchScene, caller);
			 FXDLogBOOL(didFinish);

			 [launchScene.view removeFromSuperview];

			 if (finishCallback) {
				 finishCallback(_cmd, didFinish, responseObj);
			 }
		 }];

		return;
	}


	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 launchScene.view.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {

		 [launchScene.view removeFromSuperview];

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)showInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showInformationViewWithClassName:) object:nil];
		 [self performSelector:@selector(showInformationViewWithClassName:) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
		 [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showInformationViewWithClassName:(NSString*)className {

	if (self.informationView) {
		return;
	}


	if (className == nil) {
		className = NSStringFromClass([FXDviewInformation class]);
	}


	Class informationClass = NSClassFromString(className);
	NSAssert([informationClass isSubclassOfClass:[FXDviewInformation class]], nil);

	if (informationClass == nil) {
		return;
	}


	UINib *nib = [UINib nibWithNibName:className bundle:nil];

	if (nib == nil) {
		return;
	}


	NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];

	for (id subview in viewArray) {	//Assumes there is only one root object

		if ([informationClass isSubclassOfClass:[subview class]]) {
			self.informationView = (FXDviewInformation*)subview;
			break;
		}
	}

	if (self.informationView == nil) {
		return;
	}


	CGRect modifiedFrame = self.informationView.frame;
	modifiedFrame.size = self.frame.size;
	self.informationView.frame = modifiedFrame;

	[self addSubview:self.informationView];
	[self bringSubviewToFront:self.informationView];

	[self.informationView fadeInFromHidden];
}

- (void)hideProgressView {

	if (self.informationView == nil) {
		return;
	}


	[self
	 removeAsFadeOutSubview:self.informationView
	 afterRemovedBlock:^{
		 self.informationView = nil;
	 }];
}

@end


@implementation UIWindow (Essential)
+ (instancetype)newDefaultWindow {	FXDLog_SEPARATE;
	CGRect screenBounds = [UIScreen mainScreen].bounds;
	FXDLogRect(screenBounds);

	UIWindow *newWindow = [[[self class] alloc] initWithFrame:screenBounds];
	newWindow.backgroundColor = [UIColor blackColor];

	return newWindow;
}

@end
