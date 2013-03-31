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
	destinationController.navigationItem.hidesBackButton = YES;	//MARK: Back button may not work with slideController

	[self addChildViewController:destinationController];	//MARK: Generic addChild~ is used even for navigationController
	
	
	NSInteger directionHorizontal = 0;
	NSInteger directionVertical = 0;
	
	CGFloat distanceHorizontal = 0.0;
	CGFloat distanceVertical = 0.0;

	switch ([destinationController slideDirectionType]) {
		case slideDirectionTop:
			directionVertical = -1;
			distanceVertical = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			directionHorizontal = -1;
			distanceHorizontal = 0.0 -self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			directionVertical = 1;
			distanceVertical = self.view.frame.size.height;
			break;

		case slideDirectionRight:
			directionHorizontal = 1;
			distanceHorizontal = self.view.frame.size.width;
			break;

		default:
			break;
	}
	
	
	CGRect animatedFrame = destinationController.view.frame;

	CGRect modifiedFrame = destinationController.view.frame;
	modifiedFrame.origin.x -= (modifiedFrame.size.width *directionHorizontal);
	modifiedFrame.origin.y -= (modifiedFrame.size.height *directionVertical);
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
	

	NSInteger directionHorizontal = 0;
	NSInteger directionVertical = 0;
	
	CGFloat distanceHorizontal = 0.0;
	CGFloat distanceVertical = 0.0;
	
	//TODO: generate full distance combining previously pushed viewControllers
	
	switch ([sourceController slideDirectionType]) {
		case slideDirectionTop:
			directionVertical = 1;
			distanceVertical = self.view.frame.size.height;
			break;

		case slideDirectionLeft:
			directionHorizontal = 1;
			distanceHorizontal = self.view.frame.size.width;
			break;

		case slideDirectionBottom:
			directionVertical = -1;
			distanceVertical = 0.0 -self.view.frame.size.height;
			break;

		case slideDirectionRight:
			directionHorizontal = -1;
			distanceHorizontal = 0.0 -self.view.frame.size.width;
			break;

		default:
			break;
	}

	CGRect animatedFrame = sourceController.view.frame;
	animatedFrame.origin.x += (animatedFrame.size.width *directionHorizontal);
	animatedFrame.origin.y += (animatedFrame.size.height *directionVertical);
	
	//TODO: assign proper distance for collapsed Timeline view
	

	FXDLog(@"1.self.navigationBar.topItem: %@ sourceController.navigationItem: %@", self.navigationBar.topItem, sourceController.navigationItem);
	
	if ([self.navigationBar.topItem isEqual:sourceController.navigationItem]) {
		[self.navigationBar popNavigationItemAnimated:YES];
	}
	
	FXDLog(@"2.self.navigationBar.topItem: %@ sourceController.navigationItem: %@", self.navigationBar.topItem, sourceController.navigationItem);
	
	
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
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {	FXDLog_DEFAULT;
	return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {	FXDLog_DEFAULT;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {	FXDLog_DEFAULT;
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
