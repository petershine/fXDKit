

#import "FXDViewController.h"


@implementation FXDViewController

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	FXDLogObject(_dismissedCallback);
	_dismissedCallback = nil;
}

#pragma mark - Initialization
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_SEPARATE;

	if (nibNameOrNil == nil) {
		NSString *filename = NSStringFromClass([self class]);
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	//MARK: Should use nib instead of xib for file type

		BOOL nibExists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];

		FXDLog(@"%@ %@", _BOOL(nibExists), _Object(resourcePath));
		
		if (nibExists) {
			nibNameOrNil = filename;
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
	
	FXDLog(@"%@, %@", _Object(self.storyboard), _Object(self.nibName));
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

	self.initialBounds = self.view.bounds;
}

#pragma mark - StatusBar
- (void)setNeedsStatusBarAppearanceUpdate {
	[super setNeedsStatusBarAppearanceUpdate];

	if ([UIApplication sharedApplication].statusBarHidden == NO) {	FXDLog_DEFAULT;
		FXDLogVariable([UIApplication sharedApplication].statusBarStyle);
	}
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

- (NSUInteger)supportedInterfaceOrientations {	//FXDLog_DEFAULT;
	NSUInteger supportedInterface = [super supportedInterfaceOrientations];
	//FXDLogVariable(supportedInterface);

	return supportedInterface;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_DEFAULT;
	BOOL preferredInterfaceOrientation = [super preferredInterfaceOrientationForPresentation];
	//FXDLogVariable(preferredInterfaceOrientation);

	return preferredInterfaceOrientation;
}

#pragma mark -
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {	//FXDLog_DEFAULT;
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

	[self sceneTransitionForSize:self.view.bounds.size
					forTransform:CGAffineTransformIdentity
					 forDuration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {	//FXDLog_DEFAULT;
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	NSAssert(coordinator, nil);
	[coordinator
	 animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		 [self sceneTransitionForSize:size
						 forTransform:[coordinator targetTransform]
						  forDuration:[coordinator transitionDuration]];

	 } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		 /*
		 FXDLog_BLOCK(coordinator, @selector(animateAlongsideTransition:completion:));
		 FXDLog(@"%@ %@ %@ %@", _Size(size), _Object([context containerView]), _Variable([context percentComplete]), _Variable([context completionVelocity]));
		  */
	 }];
}

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {	FXDLog_DEFAULT;
	}

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];

	if (parent) {	FXDLog_DEFAULT;
	}
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)prepareForInterfaceBuilder {	FXDLog_DEFAULT;
	[super prepareForInterfaceBuilder];
	
}

#pragma mark - Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	//MARK: This method is not invoked when -performSegueWithIdentifier:sender: is used.

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

	//MARK: Iterate backward
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
	
	
	NSArray *viewArray = [nib instantiateWithOwner:self options:nil];	//MARK: self must be the owner

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
- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@ %@", _Size(size), _Transform(transform), _Variable(duration));
}

- (void)forceSceneUpdatingForScreenSize:(CGSize)screenSize forTransform:(CGAffineTransform)transform forOrientation:(UIDeviceOrientation)forcedOrientation forDuration:(NSTimeInterval)duration {
	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@ %@ %@", _Size(screenSize), _Transform(transform), _Variable(forcedOrientation), _Variable(duration));
}

#pragma mark -
- (CGRect)animatedFrameForTransform:(CGAffineTransform)transform forSize:(CGSize)size forDeviceOrientation:(UIDeviceOrientation)deviceOrientation forXYratio:(CGPoint)xyRatio {

	CGRect animatedFrame = CGRectApplyAffineTransform(self.view.bounds, transform);

	return animatedFrame;
}

#pragma mark -
- (void)fadeInAndAddScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withDismissedCallback:(FXDcallbackFinish)dismissedCallback withFinishCallback:(FXDcallbackFinish)callback {

	if ([scene isKindOfClass:[FXDViewController class]]) {
		[(FXDViewController*)scene setDismissedCallback:dismissedCallback];
	}


	scene.view.alpha = 0.0;

	__weak UIViewController *weakSelf = self;
	
	[weakSelf addChildViewController:scene];
	[weakSelf.view addSubview:scene.view];
	[scene didMoveToParentViewController:weakSelf];

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 scene.view.alpha = 1.0;
	 }
	 completion:^(BOOL finished) {
		 if (callback) {
			 callback(_cmd, finished, nil);
		 }
	 }];
}

- (void)fadeOutAndRemoveScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)callback {

	[scene willMoveToParentViewController:nil];

	[UIView
	 animateWithDuration:duration
	 animations:^{
		 scene.view.alpha = 0.0;
	 }
	 completion:^(BOOL finished) {
		 [scene.view removeFromSuperview];
		 [scene removeFromParentViewController];

		 if (callback) {
			 callback(_cmd, finished, nil);
		 }
	 }];
}

@end