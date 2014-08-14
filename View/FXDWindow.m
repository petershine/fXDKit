

#import "FXDWindow.h"

#import "FXDsubviewInformation.h"

#import "FXDsceneLaunching.h"


@implementation FXDWindow

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_hitTestBlock);
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {	FXDLog_OVERRIDE;

	UIView *testedView = [super hitTest:point withEvent:event];
	FXDLog(@"%@ %@ %@ %@", _Point(point), _Object(event), _Object(testedView), _Object(_hitTestBlock));

	return testedView;
}

#pragma mark -
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

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInformationView) object:nil];
		 [self performSelector:@selector(hideInformationView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showInformationViewWithClassName:(NSString*)className {

	if (self.informationSubview) {
		return;
	}


	if (className == nil) {
		className = NSStringFromClass([FXDsubviewInformation class]);
	}


	Class informationClass = NSClassFromString(className);
	NSAssert([informationClass isSubclassOfClass:[FXDsubviewInformation class]], nil);

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

	[self.informationSubview fadeInFromHidden];
}

- (void)hideInformationView {

	if (self.informationSubview == nil) {
		return;
	}


	[self
	 removeAsFadeOutSubview:self.informationSubview
	 afterRemovedBlock:^{
		 self.informationSubview = nil;
	 }];
}

@end


@implementation UIWindow (Essential)
+ (instancetype)newDefaultWindow {	FXDLog_SEPARATE;

	NSString *filename = NSStringFromClass([self class]);
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	//MARK: Should use nib instead of xib for file type

	BOOL nibExists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
	FXDLog(@"%@ %@", _BOOL(nibExists), _Object(resourcePath));

	if (nibExists) {
		UIWindow *newWindow = [[self class] viewFromNib:nil];
		return newWindow;
	}


	CGRect screenBounds = [UIScreen mainScreen].bounds;
	FXDLogRect(screenBounds);

	UIWindow *newWindow = [[[self class] alloc] initWithFrame:screenBounds];
	newWindow.backgroundColor = [UIColor blackColor];

	return newWindow;
}

@end
