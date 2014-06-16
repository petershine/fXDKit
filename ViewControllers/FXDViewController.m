//
//  FXDViewController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController.h"


#pragma mark - Public implementation
@implementation FXDViewController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	FXDLog_DEFAULT;
	[super didReceiveMemoryWarning];

	FXDLogObject(self.view.window);
	FXDLogObject(self.view.superview);
}

- (void)dealloc {	FXDLog_DEFAULT;	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_DEFAULT;

	if (nibNameOrNil == nil) {
		NSString *filename = NSStringFromClass([self class]);
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	//MARK: Should use nib instead of xib for file type
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			nibNameOrNil = filename;
		}
		else {
			FXDLog(@"NO fileExistsAtPath:%@", _Object(resourcePath));
		}
	}

	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
		[self awakeFromNib];
    }

    return self;
}

#pragma mark -
- (void)awakeFromNib {
	[super awakeFromNib];
	
	FXDLog(@"%@, %@", _Object(self.storyboard), _Object(self.nibName));
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

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
- (BOOL)shouldAutorotate {
	BOOL shouldAutorotate = [super shouldAutorotate];

	return shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
	BOOL supportedInterface = [super supportedInterfaceOrientations];
	//FXDLog(@"%@: %@", _ClassSelectorSelf, _Variable(supportedInterface));

	return supportedInterface;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	BOOL preferredInterfaceOrientation = [super preferredInterfaceOrientationForPresentation];
	FXDLog(@"%@: %@", _ClassSelectorSelf, _Variable(preferredInterfaceOrientation));

	return preferredInterfaceOrientation;
}

#pragma mark -
#warning //MARK: Deprecated for iOS 8
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {	FXDLog_DEFAULT;
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

	[self
	 rotateForSize:self.view.bounds.size
	 forTransform:CGAffineTransformIdentity
	 forDuration:duration
	 withFinishCallback:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark -
#ifdef __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {	FXDLog_DEFAULT;

	CGAffineTransform targetTransform = CGAffineTransformIdentity;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		targetTransform = [coordinator targetTransform];

		[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	}


	void (^AnimatingBlock)(id <UIViewControllerTransitionCoordinatorContext>context) =
	^(id <UIViewControllerTransitionCoordinatorContext>context){

		[self
		 rotateForSize:size
		 forTransform:targetTransform
		 forDuration:[coordinator transitionDuration]
		 withFinishCallback:nil];
	};


	if (coordinator == nil) {
		AnimatingBlock(nil);
		return;
	}


	[coordinator
	 animateAlongsideTransition:AnimatingBlock
	 completion:nil];
}
#endif

- (id <UIViewControllerTransitionCoordinator>)transitionCoordinator {	//FXDLog_DEFAULT;
	id <UIViewControllerTransitionCoordinator> coordinator = [super transitionCoordinator];
	//FXDLogObject(coordinator);

	return coordinator;
}

#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {	FXDLog_FRAME;
	[super viewWillAppear:animated];
}

#if TEST_loggingViewDrawing
- (void)viewWillLayoutSubviews {	FXDLog_FRAME;
	[super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {	FXDLog_FRAME;
	[super viewDidLayoutSubviews];
}
#endif

- (void)viewDidAppear:(BOOL)animated {	FXDLog_FRAME;
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark -
- (void)willMoveToParentViewController:(UIViewController *)parent {
#if ForDEVELOPER
	if (parent == nil) {	FXDLog_DEFAULT;
		FXDLogObject(parent);
	}
#endif

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];
}


#pragma mark - Property overriding

#pragma mark - Method overriding


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
	for (NSInteger index = [self.childViewControllers count]-1; index >= 0; index--) {
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
	[super
	 segueForUnwindingToViewController:toViewController
	 fromViewController:fromViewController
	 identifier:identifier];

	FXDLogObject(segue);

	return segue;
}

	 
#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation UIViewController (Added)

#pragma mark - IBActions
- (IBAction)popToRootSceneWithAnimation:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popSceneWithAnimation:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissSceneWithAnimation:(id)sender {	FXDLog_OVERRIDE;

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
- (void)rotateForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@ %@", _Size(size), _Transform(transform), _Variable(duration));

	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
}


@end