//
//  FXDNavigationController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDNavigationController.h"


#pragma mark - Private interface
@interface FXDNavigationController (Private)
@end


#pragma mark - Public implementation
@implementation FXDNavigationController

#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	FXDLog_SEPARATE;
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// IBOutlets
	self.addedShadowImageview = nil;
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
	FXDLog_SEPARATE;
}


#pragma mark - Initialization
- (id)initWithRootViewController:(UIViewController *)rootViewController {	FXDLog_SEPARATE;
	self  = [super initWithRootViewController:rootViewController];
	
	if (self) {
		[self awakeFromNib];
	}
	
	return self;
}

- (void)awakeFromNib {	FXDLog_SEPARATE;
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - at loadView


#pragma mark - at autoRotate
- (BOOL)shouldAutorotate {	//FXDLog_OVERRIDE;
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {	//FXDLog_OVERRIDE;
	return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {	//FXDLog_OVERRIDE;
	return [super preferredInterfaceOrientationForPresentation];
}


#pragma mark - at viewDidLoad
- (void)viewDidLoad {	FXDLog_SEPARATE_FRAME;
    [super viewDidLoad];
	
	/*
	 NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	 fontSystemBold20, UITextAttributeFont,
	 [UIColor whiteColor], UITextAttributeTextColor,
	 nil];
	 
	 [self.navigationBar setTitleTextAttributes:textAttributes];
	 */
	
	FXDLog(@"shouldUseDefaultNavigationBar: %d", self.shouldUseDefaultNavigationBar);
	
	if (self.shouldUseDefaultNavigationBar == NO) {
#ifdef imageNavibarBackground
		[self.navigationBar setBackgroundImage:imageNavibarBackground forBarMetrics:UIBarMetricsDefault];
#endif
		
#ifdef imageNavibarShadow
		if ([FXDsuperGlobalControl isSystemVersionLatest]) {
			[self.navigationBar setShadowImage:imageNavibarShadow];
		}
		else {
			if (self.addedShadowImageview == nil) {
				self.addedShadowImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.navigationBar.frame.size.height, self.navigationBar.frame.size.width, imageNavibarShadow.size.height)];
				self.addedShadowImageview.image = imageNavibarShadow;
			}
			
			[self.navigationBar addSubview:self.addedShadowImageview];
		}
#endif
	}
	
#ifdef imageToolbarBackground
	[self.toolbar setBackgroundImage:imageToolbarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];	
#endif
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Segues
#if USE_loggingSequeActions
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"identifier: %@", identifier);
	FXDLog(@"sender: %@", sender);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_OVERRIDE;
	// Invoked immediately prior to initiating a segue. Return NO to prevent the segue from firing. The default implementation returns YES. This method is not invoked when -performSegueWithIdentifier:sender: is used.
	FXDLog(@"identifier: %@", identifier);
	FXDLog(@"sender: %@", sender);

	return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	FXDLog_OVERRIDE;
	FXDLog(@"identifier: %@", segue.identifier);
	FXDLog(@"sender: %@", sender);
	FXDLog(@"segue: %@", segue);
	FXDLog(@"source: %@", segue.sourceViewController);
	FXDLog(@"destination: %@", segue.destinationViewController);


}

#pragma mark -
- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.

	return [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {	FXDLog_OVERRIDE;
	// Custom containers should override this method and search their children for an action handler (using -canPerformUnwindSegueAction:fromViewController:sender:). If a handler is found, the controller should return it. Otherwise, the result of invoking super's implementation should be returned.

	return [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_OVERRIDE;
	// Custom container view controllers should override this method and return segue instances that will perform the navigation portion of segue unwinding.

	return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];

}
#endif


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UINavigationController (Added)
@end