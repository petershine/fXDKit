//
//  FXDsuperCoverController.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoverController.h"


@implementation FXDsegueTransition
@end

@implementation FXDsegueCovering
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperCoverController *coverController = (FXDsuperCoverController*)[self.sourceViewController navigationController];

	[coverController coverWithCoveringSegue:self];
}

@end

@implementation FXDsegueUncovering
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperCoverController *coverController = (FXDsuperCoverController*)[self.sourceViewController navigationController];

	[coverController uncoverWithUncoveringSegue:self];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperCoverController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.

	// Instance variables

	// Properties
}

- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	
}

- (void)viewDidLoad {
	[super viewDidLoad];

    // Primitives

    // Instance variables

    // Properties

    // IBOutlets

	//MARK: Necessary to nullify regular Navigation push and pop
	[self.navigationBar setDelegate:self];
}


#pragma mark - Autorotating


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Segues
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_DEFAULT;

	FXDLog(@"toViewController: %@", toViewController);
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"identifier: %@", identifier);

	FXDsegueUncovering *uncoveringSegue = [[FXDsegueUncovering alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];

	return uncoveringSegue;
}


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)canAnimateWithTransitionSegue:(FXDsegueTransition*)transitionSegue {	FXDLog_DEFAULT;

	BOOL canAnimate = NO;

	FXDViewController *destination = (FXDViewController*)transitionSegue.destinationViewController;
	FXDViewController *source = (FXDViewController*)transitionSegue.sourceViewController;

	FXDLog(@"destination: %@", destination);
	FXDLog(@"source: %@", source);

	if ([source isKindOfClass:[FXDViewController class]]
		&& [destination isKindOfClass:[FXDViewController class]]) {
		canAnimate = YES;
	}
	else {
		FXDLog(@"WRONG CLASSES!");
	}

	return canAnimate;
}

- (void)coverWithCoveringSegue:(FXDsegueCovering*)coveringSegue {	FXDLog_DEFAULT;
	if ([self canAnimateWithTransitionSegue:coveringSegue] == NO) {
		return;
	}

	
	FXDViewController *destination = (FXDViewController*)coveringSegue.destinationViewController;

	//MARK: Back button may not work with coverController
	destination.navigationItem.hidesBackButton = YES;

	[self addChildViewController:destination];
	
	
	CGRect modifiedFrame = destination.view.frame;
	CGRect animatedFrame = destination.view.frame;

	switch ([destination coverDirectionType]) {
		case coverDirectionTop:
			modifiedFrame.origin.y = self.view.frame.size.height;
			break;

		case coverDirectionLeft:
			modifiedFrame.origin.x = self.view.frame.size.width;
			break;

		case coverDirectionBottom:
			modifiedFrame.origin.y = 0.0 -self.view.frame.size.height;
			break;

		case coverDirectionRight:
			modifiedFrame.origin.x = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}

	[destination.view setFrame:modifiedFrame];


	//MARK: Making toolbar push and pop much easier
	if (destination.toolbarItems == nil) {
		[destination setToolbarItems:[coveringSegue.sourceViewController toolbarItems]];
	}

	if (destination.navigationItem && [destination shouldSkipPushingNavigationItems] == NO) {
		[self.navigationBar pushNavigationItem:destination.navigationItem animated:YES];
	}


	[self.view insertSubview:destination.view belowSubview:self.navigationBar];

	[destination didMoveToParentViewController:self];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 [destination.view setFrame:animatedFrame];
					 }
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"childViewControllers:\n%@", self.childViewControllers);
					 }];
}

- (void)uncoverWithUncoveringSegue:(FXDsegueUncovering*)uncoveringSegue {	FXDLog_DEFAULT;
	if ([self canAnimateWithTransitionSegue:uncoveringSegue] == NO) {
		return;
	}


	FXDViewController *source = (FXDViewController*)uncoveringSegue.sourceViewController;
	
	
	CGRect animatedFrame = source.view.frame;

	switch ([source coverDirectionType]) {
		case coverDirectionTop:
			animatedFrame.origin.y = self.view.frame.size.height;
			break;

		case coverDirectionLeft:
			animatedFrame.origin.x = self.view.frame.size.width;
			break;

		case coverDirectionBottom:
			animatedFrame.origin.y = 0.0 -self.view.frame.size.height;
			break;

		case coverDirectionRight:
			animatedFrame.origin.x = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}


	if ([self.navigationBar.topItem isEqual:source.navigationItem]) {
		[self.navigationBar popNavigationItemAnimated:YES];
	}

	[source willMoveToParentViewController:nil];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:^{
						 [source.view setFrame:animatedFrame];
					 }
					 completion:^(BOOL finished) {
						 [source.view removeFromSuperview];
						 [source removeFromParentViewController];

						 FXDLog_DEFAULT;
						 FXDLog(@"finished: %d", finished);
					 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation	//MARK: Necessary to nullify regular Navigation push and pop
#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {	//FXDLog_DEFAULT;
	BOOL shouldPush = YES;

	return shouldPush;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {	FXDLog_DEFAULT;

}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {	//FXDLog_DEFAULT;
	BOOL shouldPush = YES;

	return shouldPush;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {	FXDLog_DEFAULT;

}

@end


#pragma mark - Category
@implementation FXDViewController (Covering)

- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;

}

- (COVER_DIRECTION_TYPE)coverDirectionType {	FXDLog_OVERRIDE;
	COVER_DIRECTION_TYPE coverDirectionType = coverDirectionLeft;

	return coverDirectionType;
}

- (BOOL)shouldSkipPushingNavigationItems {	FXDLog_OVERRIDE;
	BOOL shouldSkip = NO;

	return shouldSkip;
}

@end
