//
//  FXDsuperSlidingContainer.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperSlidingContainer.h"


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

	FXDViewController *destinationScene = (FXDViewController*)transitionSegue.destinationViewController;
	FXDViewController *sourceScene = (FXDViewController*)transitionSegue.sourceViewController;

	FXDLog(@"destinationScene: %@", destinationScene);
	FXDLog(@"sourceScene: %@", sourceScene);

	if ([sourceScene isKindOfClass:[FXDViewController class]]
		&& [destinationScene isKindOfClass:[FXDViewController class]]) {
		canAnimate = YES;
	}
	
	FXDLog(@"canAnimate: %d", canAnimate);
	
	return canAnimate;
}

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:slidingInSegue] == NO) {
		return;
	}

	
	FXDViewController *destinationScene = (FXDViewController*)slidingInSegue.destinationViewController;
	[self addChildViewController:destinationScene];
	
	
	FXDLog(@"destinationController.toolbarItems: %@", destinationScene.toolbarItems);
	
	if (destinationScene.toolbarItems == nil) {
		[destinationScene setToolbarItems:[slidingInSegue.sourceViewController toolbarItems]];
	}
	
	if (self.mainToolbar) {
		[self.mainToolbar setItems:destinationScene.toolbarItems animated:YES];
	}

	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:destinationScene.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:destinationScene.slideDirectionType];
	
	
	CGRect animatedFrame = destinationScene.view.frame;
	animatedFrame.origin.y = 0.0;
	FXDLog(@"1.animatedFrame: %@", NSStringFromCGRect(animatedFrame));

	CGRect modifiedFrame = destinationScene.view.frame;
	modifiedFrame.origin.x -= slidingOffset.x;
	modifiedFrame.origin.y -= slidingOffset.y;
	modifiedFrame.origin.y += (heightStatusBar *slidingDirection.y);
	[destinationScene.view setFrame:modifiedFrame];

	
	FXDViewController *pushedScene = nil;
	CGRect animatedPushedFrame = CGRectZero;
		
	if ([destinationScene shouldCoverWhenSlidingIn] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger destinationIndex = [self.childViewControllers indexOfObject:destinationScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"childScene: %@ shouldStayFixed: %d", childScene, [childScene shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childScene];
			
			if (childIndex < destinationIndex && [childScene shouldStayFixed] == NO) {
				
				if (childIndex == destinationIndex-1) {	//MARK: If the childScene is last slid one, which is in previous index
					pushedScene = childScene;
					animatedPushedFrame = pushedScene.view.frame;
					animatedPushedFrame.origin.x += slidingOffset.x;
					animatedPushedFrame.origin.y += slidingOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childScene.view.frame;
					modifiedPushedFrame.origin.x += slidingOffset.x;
					modifiedPushedFrame.origin.y += slidingOffset.y;
					
					[childScene.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pushedController: %@ animatedPushedFrame: %@", pushedScene, NSStringFromCGRect(animatedPushedFrame));

	destinationScene.view.autoresizingMask = UIViewAutoresizingNone;
	destinationScene.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	
	[self.view insertSubview:destinationScene.view belowSubview:self.groupUpperMenu];
	[destinationScene didMoveToParentViewController:self];

	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 [destinationScene.view setFrame:animatedFrame];
		 
		 if (pushedScene) {
			 [pushedScene.view setFrame:animatedPushedFrame];
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


	FXDViewController *sourceScene = (FXDViewController*)slidingOutSegue.sourceViewController;
	
	SLIDING_OFFSET slidingOffset = [self slidingOffsetForSlideDirectionType:sourceScene.slideDirectionType];
	SLIDING_DIRECTION slidingDirection = [self slidingDirectionForSlideDirectionType:sourceScene.slideDirectionType];
	

	CGRect animatedFrame = sourceScene.view.frame;
	animatedFrame.origin.x -= (animatedFrame.size.width *slidingDirection.x);
	
	
	CGFloat slidingOutOffsetY = [[sourceScene offsetYforSlidingOut] floatValue];
	FXDLog(@"1.slidingOutOffsetY: %f", slidingOutOffsetY);
	
	if (slidingOutOffsetY > 0.0) {
		animatedFrame.origin.y -= (slidingOutOffsetY *slidingDirection.y);
	}
	else {
		animatedFrame.origin.y -= (animatedFrame.size.height *slidingDirection.y);
	}
	FXDLog(@"2.CALCULATED slidingOutOffsetY: %f - %f = %f", sourceScene.view.frame.origin.y, animatedFrame.origin.y, (sourceScene.view.frame.origin.y -animatedFrame.origin.y));
	
	
	FXDViewController *pulledScene = nil;
	CGRect animatedPulledFrame = CGRectZero;
	
	if ([sourceScene shouldCoverWhenSlidingIn] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger sourceIndex = [self.childViewControllers indexOfObject:sourceScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"childScene: %@ shouldStayFixed: %d", childScene, [childScene shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childScene];
			
			if (childIndex < sourceIndex && [childScene shouldStayFixed] == NO) {
				if (childIndex == sourceIndex-1) {	//MARK: If the childController is last slid one, which is in previous index
					pulledScene = childScene;
					animatedPulledFrame = pulledScene.view.frame;
					animatedPulledFrame.origin.x -= slidingOffset.x;
					animatedPulledFrame.origin.y -= slidingOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childScene.view.frame;
					modifiedPushedFrame.origin.x -= slidingOffset.x;
					modifiedPushedFrame.origin.y -= slidingOffset.y;
					
					[childScene.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pulledController: %@ animatedPulledFrame: %@", pulledScene, NSStringFromCGRect(animatedPulledFrame));
	
	if (pulledScene) {
		[self.mainToolbar setItems:pulledScene.toolbarItems animated:YES];
	}
	else {
		FXDViewController *destinationScene = (FXDViewController*)slidingOutSegue.destinationViewController;
		[self.mainToolbar setItems:destinationScene.toolbarItems animated:YES];
	}
	
	
	[sourceScene willMoveToParentViewController:nil];
	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 [sourceScene.view setFrame:animatedFrame];
		 
		 if (pulledScene) {
			 [pulledScene.view setFrame:animatedPulledFrame];
		 }
	 }
	 completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 FXDLog(@"finished: %d pulledController: %@", finished, pulledScene);
		 
		 [sourceScene.view removeFromSuperview];
		 [sourceScene removeFromParentViewController];
	 }];
}

#pragma mark -
- (void)slideOutAllLaterAddedControllerWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
	//MARK: Assume direction is only vertical
	
	FXDLog(@"1.self.childViewControllers: %@", self.childViewControllers);
	
	if ([self.childViewControllers count] == 0) {
		
		if (didFinishBlock) {
			didFinishBlock(YES);
		}
		
		return;
	}
	
	
	__block NSMutableArray *lateAddedSceneArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childScene in self.childViewControllers) {
		FXDLog(@"childScene: %@ shouldStayFixed: %d", childScene, [childScene shouldStayFixed]);
		
		if ([childScene shouldStayFixed] == NO) {
			[lateAddedSceneArray addObject:childScene];
		}
	}
	
	FXDLog(@"lateAddedControllerArray: %@", lateAddedSceneArray);
	
	if ([lateAddedSceneArray count] == 0) {
		lateAddedSceneArray = nil;
		
		if (didFinishBlock) {
			didFinishBlock(YES);
		}
		
		return;
	}
	
	
	CGFloat totalSlidingOffsetY = 0.0;
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		totalSlidingOffsetY += childScene.view.frame.size.height;
	}
	
	FXDLog(@"totalSlidingOffsetY: %f", totalSlidingOffsetY);
	
	
	__block NSMutableArray *animatedFrameObjArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		CGRect animatedFrame = childScene.view.frame;
		animatedFrame.origin.y += totalSlidingOffsetY;
		
		[animatedFrameObjArray addObject:NSStringFromCGRect(animatedFrame)];
		
		[childScene willMoveToParentViewController:nil];
	}
	
	FXDLog(@"animatedFrameObjArray: %@", animatedFrameObjArray);
	
	
	FXDViewController *rootScene = self.childViewControllers[0];
	[self.mainToolbar setItems:rootScene.toolbarItems animated:YES];
	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseInOut
	 animations:^{
		 
		 for (FXDViewController *childScene in lateAddedSceneArray) {
			 NSInteger childIndex = [lateAddedSceneArray indexOfObject:childScene];
			 CGRect animatedFrame = CGRectFromString(animatedFrameObjArray[childIndex]);
			 
			 [childScene.view setFrame:animatedFrame];
		 }
		 
	 } completion:^(BOOL finished) {	FXDLog_DEFAULT;
		 for (FXDViewController *childScene in lateAddedSceneArray) {
			 [childScene.view removeFromSuperview];
			 [childScene removeFromParentViewController];
		 }
		 
		 lateAddedSceneArray = nil;
		 animatedFrameObjArray = nil;
		 
		 FXDLog(@"2.self.childViewControllers: %@", self.childViewControllers);
		 
		 if (didFinishBlock) {
			 didFinishBlock(YES);
		 }
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
