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

	//MARK: Not necessary for iOS 6: find the right way to nullify unusable view for memory management
	/*
	if (self.view.superview == nil) {
		self.view = nil;
	}
	 */
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {	
	// Instance variables
		
	FXDLog_DEFAULT;
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_DEFAULT;
	self = [super initWithCoder:aDecoder];

	if (self) {
		//MARK: awakeFromNib is called automatically
	}

	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_DEFAULT;

	if (nibNameOrNil == nil) {
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
- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];

	FXDLog(@"self.storyboard: %@, self.nibName: %@", self.storyboard, self.nibName);

	// Primitives
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= latestSupportedSystemVersion) {
		_isSystemVersionLatest = YES;
	}

	// Instance variables

	// Properties
}

- (void)loadView {	FXDLog_DEFAULT;
	[super loadView];

}

#pragma mark -
- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

	// IBOutlets
	
}


#pragma mark - Autorotating
#if USE_loggingRotatingOrientation
- (BOOL)shouldAutorotate {	FXDLog_SEPARATE_FRAME;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	FXDLog_SEPARATE_FRAME;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	FXDLog_SEPARATE_FRAME;
	return [super preferredInterfaceOrientationForPresentation];
}


#warning "//MARK: For older iOS 5"
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
- (void)viewWillAppear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewWillAppear:animated];
}

#if USE_loggingViewDrawing
- (void)viewWillLayoutSubviews {	FXDLog_SEPARATE_FRAME;
	[super viewWillLayoutSubviews];
	
	// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
}

- (void)viewDidLayoutSubviews {	FXDLog_SEPARATE_FRAME;
	[super viewDidLayoutSubviews];
	
	// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
}
#endif

- (void)viewDidAppear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewDidDisappear:animated];
	
}

#pragma mark -
- (void)addChildViewController:(UIViewController *)childController {	FXDLog_DEFAULT;
	FXDLog(@"childController: %@", childController);

	[super addChildViewController:childController];
}

- (void)removeFromParentViewController {	FXDLog_DEFAULT;
	FXDLog(@"parentViewController: %@", self.parentViewController);

	[super removeFromParentViewController];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {	//FXDLog_DEFAULT;
	//FXDLog(@"parent: %@", parent);

	[super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {	//FXDLog_DEFAULT;
	//FXDLog(@"parent: %@", parent);

	[super didMoveToParentViewController:parent];
}

#pragma mark -
- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {	//FXDLog_DEFAULT;

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
- (NSDictionary*)segueNameDictionary {

	if (_segueNameDictionary == nil) {	FXDLog_OVERRIDE;
		//
	}

	return _segueNameDictionary;
}


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

		 if (obj && viewController == nil) {
			 if ([(UIViewController*)obj canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
				 viewController = (UIViewController*)obj;
				 FXDLog(@"1.viewController: %@", viewController);
			 }
		 }
		 else if (obj == nil && viewController == nil) {
			 viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
			 FXDLog(@"1.viewController: %@", viewController);
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

- (IBAction)popToRootInterfaceWithAnimation:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popInterfaceWithAnimation:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissInterfaceWithAnimation:(id)sender {

	if (self.navigationController) {
		[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}


@end