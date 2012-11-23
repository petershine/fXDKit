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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
	FXDLog_DEFAULT;
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {	FXDLog_SEPARATE;

	BOOL shouldUseAwakeFromNib = NO;

	if (nibNameOrNil == nil) {
		NSString *filename = NSStringFromClass([self class]);
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"nib"];	// Should use nib instead of xib for file type
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			nibNameOrNil = filename;
		}
		else {
			shouldUseAwakeFromNib = YES;
		}

		FXDLog(@"resourcePath: %@ for %@", resourcePath, filename);
	}

	FXDLog(@"shouldUseAwakeFromNib: %d", shouldUseAwakeFromNib);
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
		if (shouldUseAwakeFromNib) {
			[self awakeFromNib];
		}
    }

    return self;
}

- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];

	// Primitives

	// Instance variables

	// Properties

#warning @"//TODO: remove IBOutlets configuration from awakeFromNib
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

	// IBOutlets
#warning @"//TODO: remove NON IBOutlets configuration from viewDidLoad
}


#pragma mark - Autorotating
- (BOOL)shouldAutorotate {	//FXDLog_SEPARATE_FRAME;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	//FXDLog_SEPARATE_FRAME;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_SEPARATE_FRAME;
	return [super preferredInterfaceOrientationForPresentation];
	
}

//MARK: For older iOS 5
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#if USE_loggingRotatingOrientation
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
#warning @"//TODO: review viewcontroller lifecycle, make sure self.view is not confusing viewLoading and view appearing
}

- (void)viewWillDisappear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewWillDisappear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated {	FXDLog_SEPARATE_FRAME;
	[super viewDidDisappear:animated];
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {	FXDLog_DEFAULT;
	FXDLog(@"parent: %@", parent);

	[super willMoveToParentViewController:parent];
}

- (void)removeFromParentViewController {	FXDLog_DEFAULT;
	[super removeFromParentViewController];
}

#warning @"//TODO: find why this is being called more than once"
- (void)didMoveToParentViewController:(UIViewController *)parent {	FXDLog_DEFAULT;
	FXDLog(@"parent: %@", parent);

	[super didMoveToParentViewController:parent];
}


#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	// Invoked immediately prior to initiating a segue. Return NO to prevent the segue from firing. The default implementation returns YES. This method is not invoked when -performSegueWithIdentifier:sender: is used.
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	BOOL shouldPerform = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	FXDLog(@"shouldPerform: %d", shouldPerform);

	return shouldPerform;
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

	UIViewController *viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];

	FXDLog(@"1.viewController: %@", viewController);

	if (viewController == nil) {
		for (UIViewController *childScene in self.childViewControllers) {
			if ([childScene canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender]) {
				viewController = childScene;
				break;
			}
		}
	}

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

#pragma mark - Public
- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot {	FXDLog_DEFAULT;
	
	UIImage *offImage = nil;
	UIImage *onImage = nil;
	
	BOOL shouldUseBackTitle = NO;
	
#ifdef imageNavibarBtnBackOff
	offImage = imageNavibarBtnBackOff;
#else
	shouldUseBackTitle = YES;
#endif
	
#ifdef imageNavibarBtnBackOn
	onImage = imageNavibarBtnBackOn;
#endif
	
	SEL action = nil;
	
	FXDLog(@"navigationController.viewControllers count: %d", [self.navigationController.viewControllers count]);
	
	if ([self.navigationController.viewControllers count] > 1) {	// If there is more than 1 navigated interfaces
		
		if ([self.navigationController.viewControllers count] == 2) {			
			action = @selector(popToRootInterfaceWithAnimation:);
		}
		else {
			action = @selector(popInterfaceWithAnimation:);
		}
		
		FXDLog(@"onImage: %@, offImage: %@", onImage, offImage);
		
	}
	else {
		if (shouldHideForRoot) {
			// Do not show back button
		}
		else {
			action = @selector(dismissInterfaceWithAnimation:);
		}
	}
	
	if (action) {
		if (shouldUseBackTitle) {
			[self customizeLeftBarbuttonWithText:NSLocalizedString(text_Back, nil)
								  andWithOnImage:onImage
								 andWithOffImage:offImage
									   forTarget:target
									   forAction:action];
		}
		else {
			[self customizeLeftBarbuttonWithOnImage:onImage andWithOffImage:offImage forTarget:target forAction:action];
		}
	}
	else {
		self.navigationItem.hidesBackButton = YES;
		self.navigationItem.leftItemsSupplementBackButton = YES;
	}
}

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
	UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:text];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
}

- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage forTarget:target forAction:action];
	
	if (barButtonItem) {
		[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
	}
}

- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {
	
	UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:text];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
}

- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;
	
	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage forTarget:target forAction:action];
	
	if (barButtonItem) {
		[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
	}
}

- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action {
	
	UIBarButtonItem *barButtonItem = nil;
	
	if (offImage) {
		UIButton *button = [self buttonWithOnImage:onImage andOffImage:offImage orWithText:nil];
		[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	}
	else {
		if (action == @selector(dismissInterfaceWithAnimation:)) {
			barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:target action:action];
		}
	}
	
	return barButtonItem;
}

- (UIButton*)buttonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage orWithText:(NSString*)text {
	CGRect buttonFrame = CGRectMake(0.0, 0.0, onImage.size.width, onImage.size.height);
	
	UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
	
	[button setBackgroundImage:offImage forState:UIControlStateNormal];
	
	if (onImage) {
		[button setBackgroundImage:onImage forState:UIControlStateHighlighted];
		[button setBackgroundImage:onImage forState:UIControlStateSelected];
	}
	
	if (text) {
		CGRect modifiedFrame = buttonFrame;

		/*
		if ([text isEqualToString:NSLocalizedString(text_Back, nil)]) {
			modifiedFrame.origin.x = 7.0;
		}
		 */
		
		UILabel *backLabel = [[UILabel alloc] initWithFrame:modifiedFrame];
		backLabel.text = text;
		backLabel.textColor = [UIColor whiteColor];
		
		//backLabel.font = [UIFont systemFontOfSize:12.0];
		backLabel.font = [UIFont boldSystemFontOfSize:12.0];

		/*
		if ([text isEqualToString:NSLocalizedString(text_Back, nil)]) {
			backLabel.textColor = [UIColor colorUsingIntegersForRed:234 forGreen:234 forBlue:234];
		}
		else if ([text isEqualToString:NSLocalizedString(text_Reset, nil)]) {
			backLabel.font = [UIFont systemFontOfSize:13.0];
		}
		 */
		
		backLabel.textAlignment = NSTextAlignmentCenter;
		backLabel.backgroundColor = [UIColor clearColor];
		backLabel.adjustsFontSizeToFitWidth = YES;
		backLabel.userInteractionEnabled = NO;
		
		[button addSubview:backLabel];
	}
	
	return button;
}


@end