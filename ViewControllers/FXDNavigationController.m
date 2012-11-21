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

- (id)initWithRootViewController:(UIViewController *)rootViewController {	FXDLog_SEPARATE;
	self  = [super initWithRootViewController:rootViewController];

	if (self) {
		[self awakeFromNib];
	}

	return self;
}

- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets

}

- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
	[super viewDidLoad];

	// Primitives

	// Instance variables

	// Properties
	FXDLog(@"shouldUseDefaultNavigationBar: %d", self.shouldUseDefaultNavigationBar);

	// IBOutlet
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
@implementation UINavigationController (Added)
@end