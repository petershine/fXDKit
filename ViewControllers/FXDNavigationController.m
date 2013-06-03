//
//  FXDNavigationController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDNavigationController.h"


#pragma mark - Public implementation
@implementation FXDNavigationController


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	//GUIDE: Remove observer, Deallocate timer, Nilify delegates, etc
}


#pragma mark - Initialization
- (id)initWithRootViewController:(UIViewController *)rootViewController {	FXDLog_DEFAULT;
	self  = [super initWithRootViewController:rootViewController];

	if (self) {
		[self awakeFromNib];
	}

	return self;
}

- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];

	//GUIDE: Initialize BEFORE LOADING View
}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

	FXDLog(@"shouldUseDefaultNavigationBar: %d", self.shouldUseDefaultNavigationBar);


	if (self.shouldUseDefaultNavigationBar == NO) {
#ifdef imageNavibarBackground
		[self.navigationBar setBackgroundImage:imageNavibarBackground forBarMetrics:UIBarMetricsDefault];
#endif

#ifdef imageNavibarShadow
		[self.navigationBar setShadowImage:imageNavibarShadow];
#endif
	}

#ifdef imageToolbarBackground
	[self.toolbar setBackgroundImage:imageToolbarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
#endif
}


#pragma mark - Autorotating
- (BOOL)shouldAutorotate {	//FXDLog_OVERRIDE;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	//FXDLog_OVERRIDE;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_OVERRIDE;
	return [super preferredInterfaceOrientationForPresentation];
}


#pragma mark - View Appearing


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLog(@"sender: %@", sender);
	FXDLog(@"identifier: %@", identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	//MARK: This method is not invoked when -performSegueWithIdentifier:sender: is used.

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

#pragma mark -
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
				 FXDLog(@"1.(obj)viewController: %@", viewController);
			 }
		 }
		 else if (obj == nil && viewController == nil) {
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
@implementation UINavigationController (Added)
@end