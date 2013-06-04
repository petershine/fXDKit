//
//  FXDsuperSlidingContainer.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperSlidingContainer.h"

@implementation FXDsegueEmbeddingFrontController
- (void)perform {	FXDLog_DEFAULT;
	[super perform];
	
	FXDsuperSlidingContainer *slidingContainer = [self mainContainerOfClass:[FXDsuperSlidingContainer class]];
	
	slidingContainer.frontController = (FXDViewController*)self.destinationViewController;
}

@end


@implementation FXDsegueSlidingIn
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlidingContainer *slidingContainer = [self mainContainerOfClass:[FXDsuperSlidingContainer class]];

	[slidingContainer slideInWithSegue:self];
}

@end


@implementation FXDsegueSlidingOut
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperSlidingContainer *slidingContainer = [self mainContainerOfClass:[FXDsuperSlidingContainer class]];

	[slidingContainer slideOutWithSegue:self];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperSlidingContainer


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	[self performSegueWithIdentifier:segueIdFrontController sender:self];
	
	self.minimumChildCount = [self.childViewControllers count];
	FXDLog(@"self.minimumChildCount: %d", self.minimumChildCount);
}


#pragma mark - Autorotating

#pragma mark - View Appearing

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
	
	
	FXDLog(@"destinationController.toolbarItems: %@", destinationController.toolbarItems);
	
	if (destinationController.toolbarItems == nil) {
		[destinationController setToolbarItems:[slidingInSegue.sourceViewController toolbarItems]];
	}
	
	if (self.mainToolbar) {
		[self.mainToolbar setItems:destinationController.toolbarItems animated:YES];
	}

	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:destinationController.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:destinationController.slideDirectionType];
	
	
	CGRect animatedFrame = destinationController.view.frame;
	animatedFrame.origin.y = 0.0;
	FXDLog(@"1.animatedFrame: %@", NSStringFromCGRect(animatedFrame));

	CGRect modifiedFrame = destinationController.view.frame;
	modifiedFrame.origin.x -= slidingOffset.x;
	modifiedFrame.origin.y -= slidingOffset.y;
	modifiedFrame.origin.y += (heightStatusBar *slidingDirection.y);
	[destinationController.view setFrame:modifiedFrame];

	
	FXDViewController *pushedController = nil;
	CGRect animatedPushedFrame = CGRectZero;
		
	if ([destinationController shouldCoverWhenSlidingIn] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger destinationIndex = [self.childViewControllers indexOfObject:destinationController];
		
		for (FXDViewController *childController in self.childViewControllers) {
			FXDLog(@"childController: %@ shouldStayFixed: %d", childController, [childController shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childController];
			
			if (childIndex < destinationIndex && [childController shouldStayFixed] == NO) {
				
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

	destinationController.view.autoresizingMask = UIViewAutoresizingNone;
	destinationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:destinationController.view belowSubview:self.frontController.view];
	[destinationController didMoveToParentViewController:self];

	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
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

- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOutSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:slidingOutSegue] == NO) {
		return;
	}


	FXDViewController *sourceController = (FXDViewController*)slidingOutSegue.sourceViewController;
	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:sourceController.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:sourceController.slideDirectionType];
	

	CGRect animatedFrame = sourceController.view.frame;
	animatedFrame.origin.x -= (animatedFrame.size.width *slidingDirection.x);
	
	
	CGFloat slidingOutOffsetY = [[sourceController offsetYforSlidingOut] floatValue];
	FXDLog(@"1.slidingOutOffsetY: %f", slidingOutOffsetY);
	
	if (slidingOutOffsetY > 0.0) {
		animatedFrame.origin.y -= (slidingOutOffsetY *slidingDirection.y);
	}
	else {
		animatedFrame.origin.y -= (animatedFrame.size.height *slidingDirection.y);
	}
	FXDLog(@"2.CALCULATED slidingOutOffsetY: %f - %f = %f", sourceController.view.frame.origin.y, animatedFrame.origin.y, (sourceController.view.frame.origin.y -animatedFrame.origin.y));
	
	
	FXDViewController *pulledController = nil;
	CGRect animatedPulledFrame = CGRectZero;
	
	if ([sourceController shouldCoverWhenSlidingIn] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger sourceIndex = [self.childViewControllers indexOfObject:sourceController];
		
		for (FXDViewController *childController in self.childViewControllers) {
			FXDLog(@"childController: %@ shouldStayFixed: %d", childController, [childController shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childController];
			
			if (childIndex < sourceIndex && [childController shouldStayFixed] == NO) {		
				if (childIndex == sourceIndex-1) {	//MARK: If the childController is last slid one, which is in previous index
					pulledController = childController;
					animatedPulledFrame = pulledController.view.frame;
					animatedPulledFrame.origin.x -= slidingOffset.x;
					animatedPulledFrame.origin.y -= slidingOffset.y;
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
	
	FXDLog(@"pulledController: %@ animatedPulledFrame: %@", pulledController, NSStringFromCGRect(animatedPulledFrame));
	
	if (pulledController) {
		[self.mainToolbar setItems:pulledController.toolbarItems animated:YES];
	}
	else {
		FXDViewController *destinationController = (FXDViewController*)slidingOutSegue.destinationViewController;
		[self.mainToolbar setItems:destinationController.toolbarItems animated:YES];
	}
	
	
	[sourceController willMoveToParentViewController:nil];
	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 [sourceController.view setFrame:animatedFrame];
		 
		 if (pulledController) {
			 [pulledController.view setFrame:animatedPulledFrame];
		 }
	 }
	 completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 FXDLog(@"finished: %d pulledController: %@", finished, pulledController);
		 
		 [sourceController.view removeFromSuperview];
		 [sourceController removeFromParentViewController];
	 }];
}

#pragma mark -
- (void)slideOutAllLateAddedController {	FXDLog_DEFAULT;
	//MARK: Assume direction is only vertical
	
	FXDLog(@"1.self.childViewControllers: %@", self.childViewControllers);
	
	if ([self.childViewControllers count] == 0
		|| [self.childViewControllers lastObject] == self.frontController) {
		return;
	}
	
	
	__block NSMutableArray *lateAddedControllerArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	NSInteger frontIndex = [self.childViewControllers indexOfObject:self.frontController];
	FXDLog(@"frontIndex: %d", frontIndex);
	
	for (FXDViewController *childController in self.childViewControllers) {
		FXDLog(@"childController: %@ shouldStayFixed: %d", childController, [childController shouldStayFixed]);
		
		NSInteger childIndex = [self.childViewControllers indexOfObject:childController];
		
		if (childIndex > frontIndex && [childController shouldStayFixed] == NO) {
			[lateAddedControllerArray addObject:childController];
		}
	}
	
	FXDLog(@"lateAddedControllerArray: %@", lateAddedControllerArray);
	
	if ([lateAddedControllerArray count] == 0) {
		lateAddedControllerArray = nil;
		return;
	}
	
	
	CGFloat totalSlidingOffsetY = 0.0;
	
	for (FXDViewController *childController in lateAddedControllerArray) {
		totalSlidingOffsetY += childController.view.frame.size.height;
	}
	
	FXDLog(@"totalSlidingOffsetY: %f", totalSlidingOffsetY);
	
	
	__block NSMutableArray *animatedFrameObjArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childController in lateAddedControllerArray) {
		CGRect animatedFrame = childController.view.frame;
		animatedFrame.origin.y += totalSlidingOffsetY;
		
		[animatedFrameObjArray addObject:NSStringFromCGRect(animatedFrame)];
		
		[childController willMoveToParentViewController:nil];
	}
	
	FXDLog(@"animatedFrameObjArray: %@", animatedFrameObjArray);
	
	
	FXDViewController *rootController = self.childViewControllers[0];
	[self.mainToolbar setItems:rootController.toolbarItems animated:YES];
	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseInOut
	 animations:^{
		 
		 for (FXDViewController *childController in lateAddedControllerArray) {
			 NSInteger childIndex = [lateAddedControllerArray indexOfObject:childController];
			 CGRect animatedFrame = CGRectFromString(animatedFrameObjArray[childIndex]);
			 
			 [childController.view setFrame:animatedFrame];
		 }
		 
	 } completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 for (FXDViewController *childController in lateAddedControllerArray) {
			 [childController.view removeFromSuperview];
			 [childController removeFromParentViewController];
		 }
		 
		 lateAddedControllerArray = nil;
		 animatedFrameObjArray = nil;
		 
		 FXDLog(@"2.self.childViewControllers: %@", self.childViewControllers);
	 }];
}

#pragma mark -
- (SLIDING_OFFSET)slidingOffsetForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType {
	
	SLIDING_OFFSET slidingOffset = {0.0, 0.0};
	
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:slideDirectionType];
	
	slidingOffset.x = (self.view.frame.size.width *(CGFloat)slidingDirection.x);
	slidingOffset.y = (self.view.frame.size.height *(CGFloat)slidingDirection.y);
	
	return slidingOffset;
}

- (SLIDING_DIRECTION)slidingDirectionForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType {
	
	SLIDING_DIRECTION slidingDirection = {0, 0};
	
	switch (slideDirectionType) {
		case slideDirectionTop:
			slidingDirection.y = -1;
			break;
						
		case slideDirectionBottom:
			slidingDirection.y = 1;
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
- (SLIDE_DIRECTION_TYPE)slideDirectionType {
	return slideDirectionTop;
}

#pragma mark -
- (BOOL)shouldCoverWhenSlidingIn {
	return NO;
}

- (BOOL)shouldStayFixed {
	return NO;
}

#pragma mark -
- (NSNumber*)offsetYforSlidingOut {
	return nil;
}

@end
