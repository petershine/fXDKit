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


@implementation FXDsegueSlidingIn
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *slideController = (FXDsuperSlideController*)[self.sourceViewController navigationController];

	[slideController slideInWithSegue:self];
}

@end


@implementation FXDsegueSlidingOut
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *slideController = (FXDsuperSlideController*)[self.sourceViewController navigationController];

	[slideController slideOutWithSegue:self];
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

#warning "//MARK: Necessary to nullify regular Navigation push and pop"
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

	FXDsegueSlidingOut *slidingOutSegue = [[FXDsegueSlidingOut alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];

	return slidingOutSegue;
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

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:slidingInSegue] == NO) {
		return;
	}

	
	FXDViewController *destinationController = (FXDViewController*)slidingInSegue.destinationViewController;

	//MARK: Back button may not work with slideController
	destinationController.navigationItem.hidesBackButton = YES;

	[self addChildViewController:destinationController];
	
	
	CGRect animatedFrame = destinationController.view.frame;
	
	CGRect modifiedFrame = destinationController.view.frame;
	CGFloat distanceHorizontal = 0.0;
	CGFloat distanceVertical = 0.0;

	switch ([destinationController slideDirectionType]) {
		case slideDirectionTop:
			modifiedFrame.origin.y = self.view.frame.size.height;
			distanceVertical = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			modifiedFrame.origin.x = self.view.frame.size.width;
			distanceHorizontal = 0.0 -self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			modifiedFrame.origin.y = 0.0 -self.view.frame.size.height;
			distanceVertical = self.view.frame.size.height;
			break;

		case slideDirectionRight:
			modifiedFrame.origin.x = 0.0 -self.view.frame.size.width;
			distanceHorizontal = self.view.frame.size.width;
			break;

		default:
			break;
	}

	[destinationController.view setFrame:modifiedFrame];


	//MARK: Making toolbar push and pop much easier
	if (destinationController.toolbarItems == nil) {
		[destinationController setToolbarItems:[slidingInSegue.sourceViewController toolbarItems]];
	}

	if (destinationController.navigationItem
		&& [destinationController shouldPushNavigationItems]) {
		[self.navigationBar pushNavigationItem:destinationController.navigationItem animated:YES];
	}
	
	
	FXDViewController *pushedController = nil;
	CGRect animatedPushedFrame = CGRectZero;
		
	if ([destinationController shouldCoverWhenSlidingIn] == NO && [self.childViewControllers count] > 1) {
		//MARK: Including newly added child, the count should be bigger than one
		
		for (FXDViewController *childController in self.childViewControllers) {
			FXDLog(@"childController: %@ shouldStayCovered: %d", childController, [childController shouldStayCovered]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childController];
			NSInteger destinationIndex = [self.childViewControllers indexOfObject:destinationController];
			
			if (childIndex < destinationIndex && [childController shouldStayCovered] == NO) {
				
				if (childIndex == destinationIndex-1) {	//MARK: If the childController is last slid one, which is in previous index
					pushedController = childController;
					animatedPushedFrame = pushedController.view.frame;
					animatedPushedFrame.origin.x += distanceHorizontal;
					animatedPushedFrame.origin.y += distanceVertical;
				}
				else {
					CGRect modifiedPushedFrame = childController.view.frame;
					modifiedPushedFrame.origin.x += distanceHorizontal;
					modifiedPushedFrame.origin.y += distanceVertical;
					
					[childController.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pushedController: %@ animatedPushedFrame: %@", pushedController, NSStringFromCGRect(animatedPushedFrame));


	[self.view insertSubview:destinationController.view belowSubview:self.navigationBar];

	[destinationController didMoveToParentViewController:self];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [destinationController.view setFrame:animatedFrame];
						 
						 if (pushedController) {
							 [pushedController.view setFrame:animatedPushedFrame];
						 }
					 }
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"childViewControllers:\n%@", self.childViewControllers);
					 }];
}

- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOurSegue {	FXDLog_DEFAULT;
	if ([self canAnimateWithTransitionSegue:slidingOurSegue] == NO) {
		return;
	}


	FXDViewController *sourceController = (FXDViewController*)slidingOurSegue.sourceViewController;
	
	
	CGRect animatedFrame = sourceController.view.frame;

	CGFloat distanceHorizontal = 0.0;
	CGFloat distanceVertical = 0.0;
	
	//TODO: generate full distance combining previously pushed viewControllers
	
	switch ([sourceController slideDirectionType]) {
		case slideDirectionTop:
			animatedFrame.origin.y = self.view.frame.size.height;
			distanceVertical = self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			animatedFrame.origin.x = self.view.frame.size.width;
			distanceHorizontal = self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			animatedFrame.origin.y = 0.0 -self.view.frame.size.height;
			distanceVertical = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionRight:
			animatedFrame.origin.x = 0.0 -self.view.frame.size.width;
			distanceHorizontal = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}


	if ([self.navigationBar.topItem isEqual:sourceController.navigationItem]) {
		[self.navigationBar popNavigationItemAnimated:YES];
	}
	
	
	FXDViewController *pushedController = nil;
	CGRect animatedPushedFrame = CGRectZero;
	
	if ([sourceController shouldCoverWhenSlidingIn] == NO && [self.childViewControllers count] > 1) {
		//MARK: Including newly added child, the count should be bigger than one
		
		for (FXDViewController *childController in self.childViewControllers) {
			FXDLog(@"childController: %@ shouldStayCovered: %d", childController, [childController shouldStayCovered]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childController];
			NSInteger sourceIndex = [self.childViewControllers indexOfObject:sourceController];
			
			if (childIndex < sourceIndex && [childController shouldStayCovered] == NO) {
				
				if (childIndex == sourceIndex-1) {	//MARK: If the childController is last slid one, which is in previous index
					pushedController = childController;
					animatedPushedFrame = pushedController.view.frame;
					animatedPushedFrame.origin.x += distanceHorizontal;
					animatedPushedFrame.origin.y += distanceVertical;
				}
				else {
					CGRect modifiedPushedFrame = childController.view.frame;
					modifiedPushedFrame.origin.x += distanceHorizontal;
					modifiedPushedFrame.origin.y += distanceVertical;
					
					[childController.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pushedController: %@ animatedPushedFrame: %@", pushedController, NSStringFromCGRect(animatedPushedFrame));
	

	[sourceController willMoveToParentViewController:nil];

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [sourceController.view setFrame:animatedFrame];
						 
						 if (pushedController) {
							 [pushedController.view setFrame:animatedPushedFrame];
						 }
					 }
					 completion:^(BOOL finished) {
						 [sourceController.view removeFromSuperview];
						 [sourceController removeFromParentViewController];

						 FXDLog_DEFAULT;
						 FXDLog(@"finished: %d", finished);
					 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UINavigationBarDelegate
#warning "//MARK: Empty implementation is needed to nullify regular Navigation push and pop
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {	//FXDLog_DEFAULT;
	return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {	FXDLog_DEFAULT;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {	//FXDLog_DEFAULT;
	return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {	FXDLog_DEFAULT;
}

@end


#pragma mark - Category
@implementation FXDViewController (Sliding)

#pragma mark - IBActions
- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;
	FXDLog(@"unwindSegue fullDescription:\n%@", [unwindSegue fullDescription]);
}

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)slideDirectionType {	FXDLog_OVERRIDE;
	return slideDirectionTop;
}

#pragma mark -
- (BOOL)shouldPushNavigationItems {	FXDLog_OVERRIDE;
	return NO;
}

- (BOOL)shouldCoverWhenSlidingIn {	FXDLog_OVERRIDE;
	return NO;
}

- (BOOL)shouldStayCovered {
	return NO;
}

@end
