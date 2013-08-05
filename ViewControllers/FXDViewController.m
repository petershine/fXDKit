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

	FXDLog(@"self.view.window: %@ self.view.superview: %@", self.view.window, self.view.superview);
}

- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_DEFAULT;

	if (!nibNameOrNil) {
		NSString *filename = NSStringFromClass([self class]);
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	// Should use nib instead of xib for file type
		
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

#pragma mark -
- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

}

#pragma mark - StatusBar
#if __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle {
	UIStatusBarStyle statusBarStyle = [super preferredStatusBarStyle];
	FXDLog(@"statusBarStyle: %d", statusBarStyle);
	
	return statusBarStyle;
}
#endif

#pragma mark - Autorotating
#if TEST_loggingRotatingOrientation
- (BOOL)shouldAutorotate {	FXDLog_SEPARATE_FRAME;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	FXDLog_SEPARATE_FRAME;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	FXDLog_SEPARATE_FRAME;
	return [super preferredInterfaceOrientationForPresentation];
}

//MARK: For older iOS 5"
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@ %@: %d, duration: %f frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), toInterfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	FXDLog(@"%@ %@: %d, duration: %f frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), interfaceOrientation, duration, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	FXDLog(@"%@ %@: %d frame: %@ bounds: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), fromInterfaceOrientation, NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
}
#endif


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

- (void)viewWillDisappear:(BOOL)animated {	//FXDLog_FRAME;
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {	//FXDLog_FRAME;
	[super viewDidDisappear:animated];
}

#pragma mark -
- (void)willMoveToParentViewController:(UIViewController *)parent {
	if (!parent) {
		FXDLog_DEFAULT;
	}

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {	//FXDLog_DEFAULT;
	//FXDLog(@"parent: %@", parent);

	[super didMoveToParentViewController:parent];
}

#pragma mark -
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(FXDblockDidFinish)completion {	//FXDLog_DEFAULT;

	/*
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"toViewController: %@", toViewController);
	FXDLog(@"duration: %f", duration);
	FXDLog(@"options: %u", options);
	 */

	[super transitionFromViewController:fromViewController toViewController:toViewController duration:duration options:options animations:animations completion:completion];
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

	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	BOOL shouldPerform = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	FXDLog(@"shouldPerform: %d", shouldPerform);

	return shouldPerform;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"sender: %@", sender);

	if ([segue isKindOfClass:[FXDStoryboardSegue class]]) {
		FXDLog(@"segue: %@", segue);
	}
	else {
		FXDLog(@"segue:\n%@", [segue fullDescription]);
	}

	[super prepareForSegue:segue sender:sender];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.

	FXDLog(@"action: %@", NSStringFromSelector(action));
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"sender: %@", sender);

	BOOL canPerform = [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
	FXDLog(@"canPerform: %d", canPerform);

	return canPerform;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// Custom containers should override this method and search their children for an action handler (using -canPerformUnwindSegueAction:fromViewController:sender:). If a handler is found, the controller should return it. Otherwise, the result of invoking super's implementation should be returned.

	FXDLog(@"action: %@", NSStringFromSelector(action));
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"sender: %@", sender);

	__block UIViewController *viewController = nil;

	//MARK: Iterate backward
	[self.childViewControllers
	 enumerateObjectsWithOptions:NSEnumerationReverse
	 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		 FXDLog(@"idx: %u obj: %@ viewController: %@", idx, obj, viewController);

		 if (obj && !viewController) {
			 if ([(UIViewController*)obj canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
				 viewController = (UIViewController*)obj;
				 FXDLog(@"1.(obj)viewController: %@", viewController);
			 }
		 }
		 else if (!obj && !viewController) {
			 viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
			 FXDLog(@"1.([super])viewController: %@", viewController);
		 }
	 }];

	FXDLog(@"2.viewController: %@", viewController);

	return viewController;
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_OVERRIDE;
	// Custom container view controllers should override this method and return segue instances that will perform the navigation portion of segue unwinding.

	FXDLog(@"toViewController: %@", toViewController);
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"identifier: %@", identifier);

	UIStoryboardSegue *segue = [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];

	FXDLog(@"segue: %@", segue);

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
- (IBAction)exitSceneUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;
	FXDLog(@"unwindSegue: %@", unwindSegue);
}

- (IBAction)popToRootSceneWithAnimationForSender:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popSceneWithAnimationForSender:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissSceneWithAnimationForSender:(id)sender {	FXDLog_OVERRIDE;
	//TEST: Use parentController
	
	/*
	if (self.navigationController) {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
	 */
	if (self.parentViewController) {
		[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark - Public
- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil {	FXDLog_DEFAULT;
	
	if (!nibNameOrNil) {
		nibNameOrNil = NSStringFromClass([self class]);
	}
	
	UINib *nib = [UINib nibWithNibName:nibNameOrNil bundle:nil];
	
	UIView *sceneView = nil;
	
	NSArray *viewArray = [nib instantiateWithOwner:self options:nil];	//MARK: self must be the owner
	
	if ([viewArray count] > 0) {
		sceneView = viewArray[0];
	}
	
	FXDLog(@"sceneView: %@", sceneView);
	
#if ForDEVELOPER
	if (!sceneView) {
		FXDLog(@"self class: %@ viewArray:\n%@", [self class], viewArray);
	}
#endif
	
	return sceneView;
}

- (void)reframeForStatusBarFrame:(CGRect)statusBarFrame {
	CGRect modifiedFrame = self.view.frame;
	modifiedFrame.origin.y += statusBarFrame.size.height;
	modifiedFrame.size.height -= statusBarFrame.size.height;
		
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseInOut
	 animations:^{
		 [self.view setFrame:modifiedFrame];		 
	 }
	 completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 FXDLog(@"statusBarFrame: %@", NSStringFromCGRect(statusBarFrame));
		 FXDLog(@"self.view: %@", self.view);
	 }];
}

@end