

#import "FXDViewController.h"


@implementation FXDViewController

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_SEPARATE;

	if (nibNameOrNil == nil) {
		nibNameOrNil = NSStringFromClass([self class]);
	}


	//NOTE: Should use nib instead of xib for file type
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:nibNameOrNil ofType:@"nib"];
	BOOL nibExists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
	FXDLog(@"SELF: %@ %@", _BOOL(nibExists), _Object(resourcePath));

	if (nibExists == NO) {
		nibNameOrNil = NSStringFromClass([self superclass]);

		resourcePath = [[NSBundle mainBundle] pathForResource:nibNameOrNil ofType:@"nib"];
		nibExists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
		FXDLog(@"SUPER: %@ %@", _BOOL(nibExists), _Object(resourcePath));

		if (nibExists == NO) {
			nibNameOrNil = nil;
		}
	}

	
	FXDLog(@"%@ %@", _Object(nibNameOrNil), _Object(nibBundleOrNil));

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
		[self awakeFromNib];
    }

    return self;
}

#pragma mark -
- (void)awakeFromNib {	FXDLog_SEPARATE;
	[super awakeFromNib];
	
	FXDLog(@"%@ %@", _Object(self.storyboard), _Object(self.nibName));
}

- (void)viewDidLoad {	FXDLog_SEPARATE;
	[super viewDidLoad];

	FXDLog(@"%@ %@", _Rect(self.view.frame), _Rect(self.view.bounds));

	self.initialBounds = self.view.bounds;
}


#pragma mark - Property overriding


#pragma mark - StatusBar
- (void)setNeedsStatusBarAppearanceUpdate {
	[super setNeedsStatusBarAppearanceUpdate];

#if TARGET_APP_EXTENSION
#else
	if ([UIApplication sharedApplication].statusBarHidden == NO) {	//FXDLog_DEFAULT;
		//FXDLogVariable([UIApplication sharedApplication].statusBarStyle);
	}
#endif
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	UIStatusBarAnimation updateAnimation = [super preferredStatusBarUpdateAnimation];
	//FXDLogVariable(updateAnimation);

	return updateAnimation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	UIStatusBarStyle statusBarStyle = [super preferredStatusBarStyle];
	//FXDLogVariable(statusBarStyle);

	return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
	BOOL prefers = [super prefersStatusBarHidden];
	//FXDLogBOOL(prefers);

	return prefers;
}


#pragma mark - Autorotating
- (BOOL)shouldAutorotate {	//FXDLog_DEFAULT;
	BOOL shouldAutorotate = [super shouldAutorotate];
	//FXDLogBOOL(shouldAutorotate);

	return shouldAutorotate;
}

#ifdef __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
#else
- (NSUInteger)supportedInterfaceOrientations {
#endif
	UIInterfaceOrientationMask supportedInterface = [super supportedInterfaceOrientations];

	return supportedInterface;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_DEFAULT;
	UIInterfaceOrientation preferredInterfaceOrientation = [super preferredInterfaceOrientationForPresentation];
	//FXDLogVariable(preferredInterfaceOrientation);

	return preferredInterfaceOrientation;
}

#pragma mark - For <= iOS 7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {	//FXDLog_DEFAULT;
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

	[self sceneTransitionForSize:self.view.bounds.size
					forTransform:CGAffineTransformIdentity
					 forDuration:duration
					withCallback:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {	//FXDLog_DEFAULT;
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	[coordinator
	 animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

		 [self sceneTransitionForSize:size
						 forTransform:[coordinator targetTransform]
						  forDuration:[coordinator transitionDuration]
						 withCallback:nil];

	 } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		 //FXDLog_BLOCK(coordinator, @selector(animateAlongsideTransition:completion:));
		 //FXDLog(@"%@ %@ %@ %@", _Size(size), _Object([context containerView]), _Variable([context percentComplete]), _Variable([context completionVelocity]));
	 }];
}


#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		FXDLog_DEFAULT;
	}

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];

	if (parent) {
		FXDLog_DEFAULT;
	}
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {	FXDLog_VIEW;
	[super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {	//FXDLog_VIEW;
	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {	//FXDLog_VIEW;
	[super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {	FXDLog_VIEW;
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Method overriding

#pragma mark - Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	//NOTE: This method is not invoked when -performSegueWithIdentifier:sender: is used.

	FXDLogObject(sender);
	FXDLogObject(identifier);

	BOOL shouldPerform = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	FXDLogBOOL(shouldPerform);

	return shouldPerform;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLogObject(sender);
	FXDLogObject(identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;
	FXDLogObject(sender);

	if ([segue isKindOfClass:[FXDStoryboardSegue class]]) {
		FXDLogObject(segue);
	}
	else {
		FXDLogObject([segue fullDescription]);
	}

	[super prepareForSegue:segue sender:sender];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.

	FXDLogSelector(action);
	FXDLogObject(fromViewController);
	FXDLogObject(sender);

	BOOL canPerform = [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
	FXDLogBOOL(canPerform);

	return canPerform;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// Custom containers should override this method and search their children for an action handler (using -canPerformUnwindSegueAction:fromViewController:sender:). If a handler is found, the controller should return it. Otherwise, the result of invoking super's implementation should be returned.

	FXDLogSelector(action);
	FXDLogObject(fromViewController);
	FXDLogObject(sender);

	__block UIViewController *viewController = nil;

	//NOTE: Iterate backward
	for (NSInteger index = self.childViewControllers.count-1; index >= 0; index--) {
		UIViewController *childScene = self.childViewControllers[index];

		FXDLog(@"%@ %@ %@", _Variable(index), _Object(childScene), _Object(viewController));

		if (viewController == nil) {
			if (childScene) {
				if ([(UIViewController*)childScene canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
					viewController = (UIViewController*)childScene;
					FXDLog(@"1.%@", _Object(viewController));
				}
			}
			else {
				viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
				FXDLog(@"1.([super]) %@", _Object(viewController));
			}
		}
	}

	FXDLog(@"2.%@", _Object(viewController));

	return viewController;
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_OVERRIDE;
	// Custom container view controllers should override this method and return segue instances that will perform the navigation portion of segue unwinding.

	FXDLogObject(toViewController);
	FXDLogObject(fromViewController);
	FXDLogObject(identifier);

	UIStoryboardSegue *segue =
	[super segueForUnwindingToViewController:toViewController
						  fromViewController:fromViewController
								  identifier:identifier];

	FXDLogObject(segue);

	return segue;
}

@end


@implementation UIViewController (Essential)

#pragma mark - IBActions
- (IBAction)dismissSceneForEventSender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@", _Object(self.parentViewController), _Object(self.presentingViewController));

	if (self.parentViewController) {
		[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark - Public
- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil {	FXDLog_DEFAULT;
	
	if (nibNameOrNil == nil) {
		nibNameOrNil = NSStringFromClass([self class]);
	}
	
	UINib *nib = [UINib nibWithNibName:nibNameOrNil bundle:nil];
	
	
	NSArray *viewArray = [nib instantiateWithOwner:self options:nil];	//NOTE: self must be the owner

	UIView *sceneView = [viewArray firstObject];	
	FXDLogObject(sceneView);
	
#if ForDEVELOPER
	if (sceneView == nil) {
		FXDLog(@"%@ %@", _Object([self class]), _Object(viewArray));
	}
#endif
	
	return sceneView;
}

#pragma mark -
- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@ %@", _Size(size), _Transform(transform), _Variable(duration));
}

- (void)animateSceneUpdatingForForcedSize:(CGSize)forcedSize forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@ %@", _Size(forcedSize), _Transform(transform), _Variable(duration));
}

#pragma mark -
- (CGRect)sceneFrameForTransform:(CGAffineTransform)transform forXYratio:(CGPoint)xyRatio insideSize:(CGSize)size {

	CGRect sceneFrame = CGRectApplyAffineTransform(self.view.bounds, transform);

	sceneFrame.origin.x = (size.width-sceneFrame.size.width)*xyRatio.x;
	sceneFrame.origin.y = (size.height-sceneFrame.size.height)*xyRatio.y;

	return sceneFrame;
}

#pragma mark -
- (void)addChildScene:(UIViewController*)childScene forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)callback withDismissedBlock:(FXDcallbackFinish)dismissedBlock {

	if ([childScene isKindOfClass:[FXDViewController class]]) {
		[(FXDViewController*)childScene setDismissedBlock:dismissedBlock];
	}

	if (duration == 0.0) {
		[self addChildViewController:childScene];
		[self.view addSubview:childScene.view];
		[childScene didMoveToParentViewController:self];

		if (callback) {
			callback(_cmd, YES, nil);
		}
		return;
	}


	[self addChildViewController:childScene];
	childScene.view.alpha = 0.0;

	[self.view addSubview:childScene.view];
	[childScene didMoveToParentViewController:self];


	[UIView
	 animateWithDuration:duration
	 animations:^{
		 childScene.view.alpha = 1.0;
	 }
	 completion:^(BOOL finished) {
		 if (callback) {
			 callback(_cmd, YES, nil);
		 }
	 }];
}

- (void)removeChildScene:(UIViewController*)childScene forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback {

	[childScene willMoveToParentViewController:nil];

	if (duration == 0.0) {
		[childScene.view removeFromSuperview];
		[childScene removeFromParentViewController];

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	[UIView
	 animateWithDuration:duration
	 animations:^{
		 childScene.view.alpha = 0.0;
	 }
	 completion:^(BOOL finished) {
		 [childScene.view removeFromSuperview];
		 [childScene removeFromParentViewController];

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)presentBySlidingForDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	CGRect sceneFrame = self.view.frame;
	FXDLogRect(sceneFrame);

	CGRect modifiedFrame = sceneFrame;
	modifiedFrame.origin.y = self.view.frame.size.height;
	FXDLogRect(modifiedFrame);


	self.view.frame = modifiedFrame;

	self.view.hidden = NO;

	[UIView
	 animateWithDuration:duration
	 animations:^{
		 self.view.frame = sceneFrame;

	 } completion:^(BOOL finished) {

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

- (void)dismissBySlidingForDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	CGRect sceneFrame = self.view.frame;
	sceneFrame.origin.y = self.view.frame.size.height;
	FXDLogRect(sceneFrame);


	[UIView
	 animateWithDuration:duration
	 animations:^{
		 self.view.frame = sceneFrame;

	 } completion:^(BOOL finished) {

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)presentScene:(UIViewController*)presentedScene shouldSlide:(BOOL)shouldSlide withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLogObject(self.view);
	FXDLogObject(presentedScene.view);
	FXDLogBOOL(shouldSlide);

	if (shouldSlide == NO) {
		[self
		 presentViewController:presentedScene
		 animated:YES
		 completion:^{
			 if (finishCallback) {
				 finishCallback(_cmd, YES, nil);
			 }
		 }];
		return;
	}


	CGRect modifiedFrame = presentedScene.view.frame;
	modifiedFrame.size = self.view.frame.size;

	if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
		modifiedFrame.size = CGSizeMake(MAX(self.view.frame.size.width, self.view.frame.size.height),
										MIN(self.view.frame.size.width, self.view.frame.size.height));
	}

	presentedScene.view.frame = modifiedFrame;

	FXDLogRect(self.view.frame);
	FXDLogRect(presentedScene.view.frame);


	UIView *snapshot = [presentedScene.view snapshotViewAfterScreenUpdates:YES];

	modifiedFrame = presentedScene.view.frame;
	modifiedFrame.origin.x = presentedScene.view.frame.size.width;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8) == NO) {
		//modifiedFrame.origin.y = MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
	}

	snapshot.frame = modifiedFrame;
	FXDLogObject(snapshot);

	[self.view addSubview:snapshot];


	CGRect animatedFrame = modifiedFrame;
	animatedFrame.origin.x = 0.0;

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 snapshot.frame = animatedFrame;

	 } completion:^(BOOL finished) {

		 [self
		  presentViewController:presentedScene
		  animated:NO
		  completion:^{
			  [snapshot removeFromSuperview];

			  if (finishCallback) {
				  finishCallback(_cmd, YES, nil);
			  }
		  }];
	 }];
}

- (void)dismissScene:(UIViewController*)dismissedScene shouldSlide:(BOOL)shouldSlide withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLogObject(self.view);
	FXDLogObject(dismissedScene.view);
	FXDLogBOOL(shouldSlide);

	if (shouldSlide == NO) {
		[dismissedScene
		 dismissViewControllerAnimated:YES
		 completion:^{
			 if (finishCallback) {
				 finishCallback(_cmd, YES, nil);
			 }
		 }];
		return;
	}


	UIView *snapshot = [dismissedScene.view snapshotViewAfterScreenUpdates:YES];
	[self.view insertSubview:snapshot aboveSubview:dismissedScene.view];


	[dismissedScene
	 dismissViewControllerAnimated:NO
	 completion:^{

		 CGRect animatedFrame = snapshot.frame;
		 animatedFrame.origin.x = snapshot.frame.size.width;

		 [UIView
		  animateWithDuration:durationAnimation
		  animations:^{
			  snapshot.frame = animatedFrame;

		  } completion:^(BOOL finished) {
			  [snapshot removeFromSuperview];

			  if (finishCallback) {
				  finishCallback(_cmd, YES, nil);
			  }
		  }];
	 }];
}

#pragma mark -
- (id)lastChildSceneOfClass:(Class)sceneClass {

	__block UIViewController *lastChildScene = nil;

	[self.childViewControllers
	 enumerateObjectsWithOptions:NSEnumerationReverse
	 usingBlock:^(UIViewController *childScene, NSUInteger idx, BOOL *stop) {
		 if (lastChildScene) {
			 *stop = YES;
			return;
		 }

		 if ([childScene isKindOfClass:sceneClass]) {
			lastChildScene = childScene;
		 }
	 }];

	return lastChildScene;
}

#pragma mark -
- (CGRect)centeredDisplayFrameForForcedSize:(CGSize)forcedSize withPresentationSize:(CGSize)presentationSize {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Size(forcedSize), _Size(presentationSize));

	if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
		presentationSize = forcedSize;
	}


	CGFloat forcedAspect = MAX(forcedSize.width, forcedSize.height)/MIN(forcedSize.width, forcedSize.height);
	FXDLogVariable(forcedAspect);

	CGFloat presentationAspect = MAX(presentationSize.width, presentationSize.height)/MIN(presentationSize.width, presentationSize.height);
	FXDLogVariable(presentationAspect);

	CGFloat displayAspect = MAX(forcedAspect, presentationAspect);
	FXDLogVariable(displayAspect);


	CGRect displayFrame = CGRectMake(0, 0, forcedSize.width, forcedSize.height);

	if (forcedSize.width < forcedSize.height) {
		displayFrame.size.width = forcedSize.width;

		if (presentationSize.width < presentationSize.height) {
			displayFrame.size.height = displayFrame.size.width*displayAspect;
		}
		else {
			displayFrame.size.height = displayFrame.size.width/displayAspect;
		}
	}
	else {
		displayFrame.size.height = forcedSize.height;

		if (presentationSize.width < presentationSize.height) {
			displayFrame.size.width = displayFrame.size.height/displayAspect;
		}
		else {
			displayFrame.size.width = displayFrame.size.height*displayAspect;
		}
	}

	FXDLog(@"1.%@", _Rect(displayFrame));

	displayFrame.origin.x = (forcedSize.width -displayFrame.size.width)/2.0;
	displayFrame.origin.y = (forcedSize.height -displayFrame.size.height)/2.0;

	FXDLog(@"2.%@", _Rect(displayFrame));

	
	return displayFrame;
}

@end