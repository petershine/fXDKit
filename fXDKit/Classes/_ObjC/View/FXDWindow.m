

#import "FXDWindow.h"

#import "FXDsceneLaunching.h"


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
+ (void)showWaiting {
	UIWindow *window = ([UIApplication sharedApplication].delegate).window;

	if ([window isKindOfClass:[self class]]) {
		[(FXDWindow*)window showInformationViewAfterDelay:0.0];
	}
}

+ (void)hideWaiting {
	UIWindow *window = ([UIApplication sharedApplication].delegate).window;

	if ([window isKindOfClass:[self class]]) {
		[(FXDWindow*)window	hideInformationViewAfterDelay:0.0];
	}
}

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
		 dismissLaunchSceneWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
			 FXDLog_BLOCK(previousRootScene, caller);
			 FXDLogBOOL(didFinish);

			 [previousRootScene.view removeFromSuperview];

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


/*
@implementation UIWindow (Essential)
+ (instancetype)newDefaultWindow {	FXDLog_SEPARATE;

	NSString *nibName = NSStringFromClass([self class]);
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];	//MARK: Should use nib instead of xib for file type

	BOOL nibExists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
	FXDLog(@"%@ %@", _BOOL(nibExists), _Object(resourcePath));

	if (nibExists) {
		UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
		NSArray *viewArray = [nib instantiateWithOwner:nil options:nil];
		UIWindow *newWindow = viewArray.firstObject;
		
		return newWindow;
	}


	CGRect screenBounds = [UIScreen mainScreen].bounds;
	FXDLogRect([UIScreen mainScreen].nativeBounds);
	FXDLogVariable([UIScreen mainScreen].nativeScale);
	FXDLogRect(screenBounds);

	UIWindow *newWindow = [[[self class] alloc] initWithFrame:screenBounds];
	newWindow.autoresizesSubviews = YES;
	
	return newWindow;
}
@end
 */