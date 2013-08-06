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

#pragma mark - Initialization
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {	FXDLog_DEFAULT;
	self  = [super initWithRootViewController:rootViewController];

	if (self) {
		[self awakeFromNib];
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

#ifdef imageNavibarBackground
	[self.navigationBar setBackgroundImage:imageNavibarBackground forBarMetrics:UIBarMetricsDefault];
#endif
	
#ifdef imageNavibarShadow
	[self.navigationBar setShadowImage:imageNavibarShadow];
#endif

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


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation UINavigationController (Added)
@end