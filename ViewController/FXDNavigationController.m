//
//  FXDNavigationController.m
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDNavigationController.h"



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
	[self.navigationBar setBackgroundImage:[UIImage bundledImageForName:imageNavibarBackground] forBarMetrics:UIBarMetricsDefault];
#endif
	
#ifdef imageNavibarShadow
	[self.navigationBar setShadowImage:[UIImage bundledImageForName:imageNavibarShadow]];
#endif

#ifdef imageToolbarBackground
	[self.toolbar setBackgroundImage:[UIImage bundledImageForName:imageToolbarBackground] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
#endif
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Segues
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	FXDLogObject(sender);
	FXDLogObject(identifier);

	[super performSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {	FXDLog_DEFAULT;
	//MARK: This method is not invoked when -performSegueWithIdentifier:sender: is used.

	FXDLogObject(sender);
	FXDLogObject(identifier);

	BOOL shouldPerform = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
	FXDLogBOOL(shouldPerform);

	return shouldPerform;
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


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end