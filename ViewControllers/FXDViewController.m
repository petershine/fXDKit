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

	FXDLogObj(self.view.window);
	FXDLogObj(self.view.superview);


#if TEST_loggingMemoryWarning
	UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightStatusBar)];
	warningLabel.backgroundColor = [UIColor redColor];
	warningLabel.textColor = [UIColor whiteColor];
	warningLabel.font = [UIFont boldSystemFontOfSize:20.0];
	warningLabel.textAlignment = NSTextAlignmentCenter;
	warningLabel.text = selfClassSelector;

	[self.view.window addSubview:warningLabel];

	[warningLabel
	 performSelector:@selector(removeFromSuperview)
	 withObject:nil
	 afterDelay:delayOneSecond
	 inModes:@[NSRunLoopCommonModes]];
#endif
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
			FXDLog(@"NO fileExistsAtPath:resourcePath: %@ for %@", resourcePath, filename);
		}
	}

	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
		[self awakeFromNib];
    }

    return self;
}

#pragma mark -
- (void)awakeFromNib {	//FXDLog_DEFAULT;
	[super awakeFromNib];
	
	FXDLog(@"storyboard: %@, nibName: %@", self.storyboard, self.nibName);
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

}

#pragma mark - StatusBar
- (void)setNeedsStatusBarAppearanceUpdate {	FXDLog_DEFAULT;
	[super setNeedsStatusBarAppearanceUpdate];

	FXDLog(@"sharedApplication.statusBarHidden: %@ statusBarStyle: %@", strBOOL([UIApplication sharedApplication].statusBarHidden), @([UIApplication sharedApplication].statusBarStyle));
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	UIStatusBarAnimation updateAnimation = [super preferredStatusBarUpdateAnimation];
	FXDLogVar(updateAnimation);

	return updateAnimation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	UIStatusBarStyle statusBarStyle = [super preferredStatusBarStyle];
	FXDLogVar(statusBarStyle);

	return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
	BOOL prefers = [super prefersStatusBarHidden];
	FXDLogBOOL(prefers);

	return prefers;
}


#pragma mark - Autorotating
#if TEST_loggingRotatingOrientation
- (BOOL)shouldAutorotate {
	BOOL shouldAutorotate = [super shouldAutorotate];

	//FXDLog(@"%@: %@", selfClassSelector, strBOOL(shouldAutorotate));

	return shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
	BOOL supportedInterface = [super supportedInterfaceOrientations];
	FXDLog(@"%@: supportedInterface: %u", selfClassSelector, supportedInterface);

	return supportedInterface;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	BOOL preferredInterfaceOrientation = [super preferredInterfaceOrientationForPresentation];
	FXDLog(@"%@: preferredInterfaceOrientation: %u", selfClassSelector, preferredInterfaceOrientation);

	return preferredInterfaceOrientation;
}

#pragma mark -
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@: %ld, duration: %f %@", selfClassSelector, (long)toInterfaceOrientation, duration, [self.view describeFrameAndBounds]);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@: %ld, duration: %f %@", selfClassSelector, (long)interfaceOrientation, duration, [self.view describeFrameAndBounds]);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FXDLog(@"%@: %ld, %@", selfClassSelector, (long)fromInterfaceOrientation, [self.view describeFrameAndBounds]);
}
#endif


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {	FXDLog_FRAME;
	[super viewWillAppear:animated];

#if	ForDEVELOPER
	if (self.didFinishInitialAppearing) {
		FXDLogBOOL(self.didFinishInitialAppearing);
	}
#endif
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

#if ForDEVELOPER
	if (self.didFinishInitialAppearing == NO) {
		FXDLog(@"didFinishInitialAppearing: %@", strBOOL(YES));
	}
#endif

	self.didFinishInitialAppearing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {	//FXDLog_FRAME;
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {	//FXDLog_FRAME;
	[super viewDidDisappear:animated];
}

#pragma mark -
- (void)willMoveToParentViewController:(UIViewController *)parent {
#if ForDEVELOPER
	if (parent == nil) {	FXDLog_DEFAULT;
		FXDLogObj(parent);
	}
#endif

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {	//FXDLog_DEFAULT;
	//FXDLogObj(parent);

	[super didMoveToParentViewController:parent];
}

#pragma mark -
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {	//FXDLog_DEFAULT;

	[super
	 transitionFromViewController:fromViewController
	 toViewController:toViewController
	 duration:duration
	 options:options
	 animations:animations
	 completion:completion];
}

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {	//FXDLog_DEFAULT;
	//FXDLog(@"isAppearing: %d animated: %d", isAppearing, animated);

	[super beginAppearanceTransition:isAppearing animated:animated];

}

- (void)endAppearanceTransition {	//FXDLog_DEFAULT;
	[super endAppearanceTransition];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	//MARK: This method is not invoked when -performSegueWithIdentifier:sender: is used.

	FXDLogObj(sender);
	FXDLogObj(identifier);

	BOOL shouldPerform = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	FXDLogBOOL(shouldPerform);

	return shouldPerform;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLogObj(sender);
	FXDLogObj(identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;
	FXDLogObj(sender);

	if ([segue isKindOfClass:[FXDStoryboardSegue class]]) {
		FXDLogObj(segue);
	}
	else {
		FXDLogObj([segue fullDescription]);
	}

	[super prepareForSegue:segue sender:sender];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.

	FXDLogObj(NSStringFromSelector(action));
	FXDLogObj(fromViewController);
	FXDLogObj(sender);

	BOOL canPerform = [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
	FXDLogBOOL(canPerform);

	return canPerform;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// Custom containers should override this method and search their children for an action handler (using -canPerformUnwindSegueAction:fromViewController:sender:). If a handler is found, the controller should return it. Otherwise, the result of invoking super's implementation should be returned.

	FXDLogObj(NSStringFromSelector(action));
	FXDLogObj(fromViewController);
	FXDLogObj(sender);

	__block UIViewController *viewController = nil;

	//MARK: Iterate backward
	[self.childViewControllers
	 enumerateObjectsWithOptions:NSEnumerationReverse
	 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		 FXDLog(@"idx: %lu obj: %@ viewController: %@", (unsigned long)idx, obj, viewController);

		 if (viewController == nil) {
			 if (obj) {
				 if ([(UIViewController*)obj canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
					 viewController = (UIViewController*)obj;
					 FXDLog(@"1.(obj)viewController: %@", viewController);
				 }
			 }
			 else {
				 viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
				 FXDLog(@"1.([super])viewController: %@", viewController);
			 }
		 }
	 }];

	FXDLog(@"2.viewController: %@", viewController);

	return viewController;
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_OVERRIDE;
	// Custom container view controllers should override this method and return segue instances that will perform the navigation portion of segue unwinding.

	FXDLogObj(toViewController);
	FXDLogObj(fromViewController);
	FXDLogObj(identifier);

	UIStoryboardSegue *segue = [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];

	FXDLogObj(segue);

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
	FXDLogObj(sceneView);
	
#if ForDEVELOPER
	if (sceneView == nil) {
		FXDLog(@"self class: %@ viewArray:\n%@", [self class], viewArray);
	}
#endif
	
	return sceneView;
}

@end