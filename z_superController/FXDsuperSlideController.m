//
//  FXDsuperSlideController.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperSlideController.h"

@implementation FXDsegueEmbeddingFrontController
- (void)perform {	FXDLog_DEFAULT;
	[super perform];
	
	FXDsuperSlideController *slideController = (FXDsuperSlideController*)self.sourceViewController;
	
	slideController.frontController = (FXDViewController*)self.destinationViewController;
	FXDLog(@"slideController.frontController: %@", slideController.frontController);
}

@end


@implementation FXDsegueSlidingIn
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *slideController = (FXDsuperSlideController*)[self.sourceViewController parentViewController];

	[slideController slideInWithSegue:self];
}

@end


@implementation FXDsegueSlidingOut
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlideController *slideController = (FXDsuperSlideController*)[self.sourceViewController parentViewController];

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
	[self performSegueWithIdentifier:seguenameFrontController sender:self];
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
- (BOOL)canAnimateWithTransitionSegue:(FXDsuperTransitionSegue*)transitionSegue {

	BOOL canAnimate = NO;

	FXDViewController *destination = (FXDViewController*)transitionSegue.destinationViewController;
	FXDViewController *source = (FXDViewController*)transitionSegue.sourceViewController;

	FXDLog(@"destination: %@", destination);
	FXDLog(@"source: %@", source);

	if ([source isKindOfClass:[FXDViewController class]]
		&& [destination isKindOfClass:[FXDViewController class]]) {
		canAnimate = YES;
	}
	
	FXDLog(@"canAnimate: %d", canAnimate);
	

	return canAnimate;
}

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:slidingInSegue] == NO) {
		return;
	}

	
	FXDViewController *destinationController = (FXDViewController*)slidingInSegue.destinationViewController;
	[self addChildViewController:destinationController];
	
	destinationController.navigationItem.hidesBackButton = YES;	//MARK: Back button may not work with slideController
	
	//MARK: Making toolbar push and pop much easier
	FXDLog(@"destinationController.toolbarItems: %@", destinationController.toolbarItems);
	
	if (destinationController.toolbarItems == nil) {
		[destinationController setToolbarItems:[slidingInSegue.sourceViewController toolbarItems]];
	}

	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:destinationController.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:destinationController.slideDirectionType];
	
	
	CGRect animatedFrame = destinationController.view.frame;

	CGRect modifiedFrame = destinationController.view.frame;
	modifiedFrame.origin.x -= (modifiedFrame.size.width *slidingDirection.x);
	modifiedFrame.origin.y -= (modifiedFrame.size.height *slidingDirection.y);
	[destinationController.view setFrame:modifiedFrame];

	
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
					animatedPushedFrame.origin.x += slidingOffset.x;
					animatedPushedFrame.origin.y += slidingOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childController.view.frame;
					modifiedPushedFrame.origin.x += slidingOffset.x;
					modifiedPushedFrame.origin.y += slidingOffset.y;
					
					[childController.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pushedController: %@ animatedPushedFrame: %@", pushedController, NSStringFromCGRect(animatedPushedFrame));

	[self.view insertSubview:destinationController.view belowSubview:self.frontController.view];
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
						 FXDLog(@"finished: %d", finished);
						 
						 FXDLog(@"childViewControllers:\n%@", self.childViewControllers);
					 }];
}

- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOurSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:slidingOurSegue] == NO) {
		return;
	}


	FXDViewController *sourceController = (FXDViewController*)slidingOurSegue.sourceViewController;
	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:sourceController.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:sourceController.slideDirectionType];
	

	CGRect animatedFrame = sourceController.view.frame;
	animatedFrame.origin.x -= (animatedFrame.size.width *slidingDirection.x);
	
	
	CGFloat slidingOutDistance = [[sourceController distanceNumberForSlidingOut] floatValue];
	FXDLog(@"1.slidingOutDistance: %f", slidingOutDistance);
	
	if (slidingOutDistance > 0.0) {
		animatedFrame.origin.y -= (slidingOutDistance *slidingDirection.y);
	}
	else {
		animatedFrame.origin.y -= (animatedFrame.size.height *slidingDirection.y);
	}
	FXDLog(@"2.CALCULATED distance: %f - %f = %f", sourceController.view.frame.origin.y, animatedFrame.origin.y, (sourceController.view.frame.origin.y -animatedFrame.origin.y));
	
	
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
					animatedPushedFrame.origin.x -= slidingOffset.x;
					animatedPushedFrame.origin.y -= slidingOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childController.view.frame;
					modifiedPushedFrame.origin.x -= slidingOffset.x;
					modifiedPushedFrame.origin.y -= slidingOffset.y;
					
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
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"finished: %d sourceController: %@", finished, sourceController);
	
						 [sourceController.view removeFromSuperview];
						 [sourceController removeFromParentViewController];
					 }];
}

#pragma mark -
- (SLIDING_OFFSET)slidingOffsetForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType {
	//MARK: be careful if there will be statusBar confusion"
	
	SLIDING_OFFSET slidingOffset = {0.0, 0.0};
	
	switch (slideDirectionType) {
		case slideDirectionTop:
			slidingOffset.y = 0.0 -(self.view.frame.size.height -heightStatusBar);
			break;
			
		case slideDirectionLeft:
			slidingOffset.x = 0.0 -self.view.frame.size.width;
			break;
			
		case slideDirectionBottom:
			slidingOffset.y = (self.view.frame.size.height -heightStatusBar);
			break;
			
		case slideDirectionRight:
			slidingOffset.x = self.view.frame.size.width;
			break;
			
		default:
			break;
	}
	
	return slidingOffset;
}

- (SLIDING_DIRECTION)slidingDirectionForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType {
	SLIDING_DIRECTION slidingDirection = {0, 0};
	
	switch (slideDirectionType) {
		case slideDirectionTop:
			slidingDirection.y = -1;
			break;
			
		case slideDirectionLeft:
			slidingDirection.x = -1;
			break;
			
		case slideDirectionBottom:
			slidingDirection.y = 1;
			break;
			
		case slideDirectionRight:
			slidingDirection.x = 1;
			break;
			
		default:
			break;
	}
	
	return slidingDirection;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation FXDViewController (Sliding)

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)slideDirectionType {	FXDLog_OVERRIDE;
	return slideDirectionTop;
}

#pragma mark -
- (BOOL)shouldCoverWhenSlidingIn {
	return NO;
}

- (BOOL)shouldStayCovered {
	return NO;
}

#pragma mark -
- (NSNumber*)distanceNumberForSlidingOut {	FXDLog_OVERRIDE;
	return nil;
}

@end
