//
//  FXDsuperSlideController.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperSlideController.h"


@implementation FXDsegueTransition
@end


@implementation FXDsegueCovering
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *coverController = (FXDsuperSlideController*)[self.sourceViewController navigationController];

	[coverController coverWithCoveringSegue:self];
}

@end


@implementation FXDsegueUncovering
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *coverController = (FXDsuperSlideController*)[self.sourceViewController navigationController];

	[coverController uncoverWithUncoveringSegue:self];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperSlideController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	// Instance variables

}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

}

- (void)viewDidLoad {
	[super viewDidLoad];

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

	
	FXDViewController *destinationController = (FXDViewController*)coveringSegue.destinationViewController;

	//MARK: Back button may not work with coverController
	destinationController.navigationItem.hidesBackButton = YES;

	[self addChildViewController:destinationController];
	
	
	CGRect modifiedFrame = destinationController.view.frame;
	CGRect animatedFrame = destinationController.view.frame;

	switch ([destinationController coverDirectionType]) {
		case slideDirectionTop:
			modifiedFrame.origin.y = self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			modifiedFrame.origin.x = self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			modifiedFrame.origin.y = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionRight:
			modifiedFrame.origin.x = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}

	[destinationController.view setFrame:modifiedFrame];


	//MARK: Making toolbar push and pop much easier
	if (destinationController.toolbarItems == nil) {
		[destinationController setToolbarItems:[coveringSegue.sourceViewController toolbarItems]];
	}

	if (destinationController.navigationItem && [destinationController shouldSkipPushingNavigationItems] == NO) {
		[self.navigationBar pushNavigationItem:destinationController.navigationItem animated:YES];
	}


	[self.view insertSubview:destinationController.view belowSubview:self.navigationBar];

	[destinationController didMoveToParentViewController:self];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [destinationController.view setFrame:animatedFrame];
					 }
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"childViewControllers:\n%@", self.childViewControllers);
					 }];
}

- (void)uncoverWithUncoveringSegue:(FXDsegueUncovering*)uncoveringSegue {	FXDLog_DEFAULT;
	if ([self canAnimateWithTransitionSegue:uncoveringSegue] == NO) {
		return;
	}


	FXDViewController *sourceController = (FXDViewController*)uncoveringSegue.sourceViewController;
	
	
	CGRect animatedFrame = sourceController.view.frame;

	switch ([sourceController coverDirectionType]) {
		case slideDirectionTop:
			animatedFrame.origin.y = self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			animatedFrame.origin.x = self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			animatedFrame.origin.y = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionRight:
			animatedFrame.origin.x = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}


	if ([self.navigationBar.topItem isEqual:sourceController.navigationItem]) {
		[self.navigationBar popNavigationItemAnimated:YES];
	}

	[sourceController willMoveToParentViewController:nil];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [sourceController.view setFrame:animatedFrame];
					 }
					 completion:^(BOOL finished) {
						 [sourceController.view removeFromSuperview];
						 [sourceController removeFromParentViewController];

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

#pragma mark - IBActions
- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;
	FXDLog(@"unwindSegue fullDescription:\n%@", [unwindSegue fullDescription]);
}

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)coverDirectionType {	FXDLog_OVERRIDE;
	SLIDE_DIRECTION_TYPE coverDirectionType = slideDirectionTop;

	return coverDirectionType;
}

- (BOOL)shouldSkipPushingNavigationItems {	FXDLog_OVERRIDE;
	BOOL shouldSkip = NO;

	return shouldSkip;
}

@end
