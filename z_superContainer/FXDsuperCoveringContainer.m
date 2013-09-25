//
//  FXDsuperCoveringContainer.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoveringContainer.h"


@implementation FXDsegueCover
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperCoveringContainer *coveringContainer = [self mainContainerOfClass:[FXDsuperCoveringContainer class]];

	[coveringContainer coverWithSegue:self];
}
@end

@implementation FXDsegueUncover
- (void)perform {	FXDLog_DEFAULT;
	FXDsuperCoveringContainer *coveringContainer = [self mainContainerOfClass:[FXDsuperCoveringContainer class]];

	[coveringContainer uncoverWithSegue:self];
}
@end


#pragma mark - Public implementation
@implementation FXDsuperCoveringContainer


#pragma mark - Memory management

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.minimumChildCount = [self.childViewControllers count];
	FXDLog(@"self.minimumChildCount: %ld", (long)self.minimumChildCount);
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding
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
	
	
	FXDLog(@"self.isCovering: %d, self.isUncovering: %d", self.isCovering, self.isUncovering);
	
	if (self.isCovering || self.isUncovering) {
		canAnimate = NO;
	}
	
	FXDLog(@"canAnimate: %d", canAnimate);
	
	return canAnimate;
}


#pragma mark - Segues
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_DEFAULT;

	FXDLog(@"toViewController: %@", toViewController);
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"identifier: %@", identifier);

	FXDsegueUncover *uncoveringSegue = [[FXDsegueUncover alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];

	return uncoveringSegue;
}


#pragma mark - IBActions

#pragma mark - Public
- (void)coverWithSegue:(FXDsegueCover*)coveringSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:coveringSegue] == NO) {
		return;
	}


	self.isCovering = YES;

	
	FXDViewController *destinationScene = (FXDViewController*)coveringSegue.destinationViewController;
	[self addChildViewController:destinationScene];
	
	if (self.groupUpperMenu) {
		[self configureUpperMenuViewForCurrentScene:destinationScene];
	}
	
	if (self.groupBottomMenu) {
		[self configureBottomMenuViewForCurrentScene:destinationScene];
	}

	
	COVERING_OFFSET coveringOffset = [self coveringOffsetForDirectionType:[destinationScene coverDirectionType]];
	COVERING_DIRECTION coveringDirection = [self coveringDirectionForDirectionType:[destinationScene coverDirectionType]];
	
	
	CGRect animatedFrame = destinationScene.view.frame;
	animatedFrame.origin.y = 0.0;
	FXDLog(@"1.animatedFrame: %@", NSStringFromCGRect(animatedFrame));

	CGRect modifiedFrame = destinationScene.view.frame;
	modifiedFrame.origin.x -= coveringOffset.x;
	modifiedFrame.origin.y -= coveringOffset.y;
	modifiedFrame.origin.y += (heightDynamicStatusBar *coveringDirection.y);
	[destinationScene.view setFrame:modifiedFrame];

	
	FXDViewController *pushedScene = nil;
	CGRect animatedPushedFrame = CGRectZero;
		
	if ([destinationScene shouldCoverAbove] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger destinationIndex = [self.childViewControllers indexOfObject:destinationScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"childScene: %@ shouldStayFixed: %d", childScene, [childScene shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childScene];
			
			if (childIndex < destinationIndex && [childScene shouldStayFixed] == NO) {
				
				//MARK: If the childScene is last slid one, which is in previous index
				if (childIndex == destinationIndex-1) {
					pushedScene = childScene;
					animatedPushedFrame = pushedScene.view.frame;
					animatedPushedFrame.origin.x += coveringOffset.x;
					animatedPushedFrame.origin.y += coveringOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childScene.view.frame;
					modifiedPushedFrame.origin.x += coveringOffset.x;
					modifiedPushedFrame.origin.y += coveringOffset.y;
					
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
		 
		 self.isCovering = NO;
	 }];
}

- (void)uncoverWithSegue:(FXDsegueUncover*)uncoveringSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:uncoveringSegue] == NO) {
		return;
	}


	self.isUncovering = YES;


	FXDViewController *sourceScene = (FXDViewController*)uncoveringSegue.sourceViewController;
	
	COVERING_OFFSET uncoveringOffset = [self coveringOffsetForDirectionType:[sourceScene coverDirectionType]];
	COVERING_DIRECTION uncoveringDirection = [self coveringDirectionForDirectionType:[sourceScene coverDirectionType]];
	

	CGRect animatedFrame = sourceScene.view.frame;
	animatedFrame.origin.x -= (animatedFrame.size.width *uncoveringDirection.x);
	
	
	CGFloat uncoveringOffsetY = [[sourceScene offsetYforUncovering] floatValue];
	FXDLog(@"1.uncoveringOffsetY: %f", uncoveringOffsetY);
	
	if (uncoveringOffsetY > 0.0) {
		animatedFrame.origin.y -= (uncoveringOffsetY *uncoveringDirection.y);
	}
	else {
		animatedFrame.origin.y -= (animatedFrame.size.height *uncoveringDirection.y);
	}
	FXDLog(@"2.CALCULATED uncoveringOffsetY: %f - %f = %f", sourceScene.view.frame.origin.y, animatedFrame.origin.y, (sourceScene.view.frame.origin.y -animatedFrame.origin.y));
	
	
	FXDViewController *pulledScene = nil;
	CGRect animatedPulledFrame = CGRectZero;
	
	if ([sourceScene shouldCoverAbove] == NO
		&& [self.childViewControllers count] > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger sourceIndex = [self.childViewControllers indexOfObject:sourceScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"childScene: %@ shouldStayFixed: %d", childScene, [childScene shouldStayFixed]);
			
			NSInteger childIndex = [self.childViewControllers indexOfObject:childScene];
			
			if (childIndex < sourceIndex && [childScene shouldStayFixed] == NO) {
				
				//MARK: If the childController is last slid one, which is in previous index
				if (childIndex == sourceIndex-1) {
					pulledScene = childScene;
					animatedPulledFrame = pulledScene.view.frame;
					animatedPulledFrame.origin.x -= uncoveringOffset.x;
					animatedPulledFrame.origin.y -= uncoveringOffset.y;
				}
				else {
					CGRect modifiedPushedFrame = childScene.view.frame;
					modifiedPushedFrame.origin.x -= uncoveringOffset.x;
					modifiedPushedFrame.origin.y -= uncoveringOffset.y;
					
					[childScene.view setFrame:modifiedPushedFrame];
				}
			}
		}
	}
	
	FXDLog(@"pulledController: %@ animatedPulledFrame: %@", pulledScene, NSStringFromCGRect(animatedPulledFrame));
	
	if (self.groupUpperMenu) {
		if (pulledScene) {
			[self configureUpperMenuViewForCurrentScene:pulledScene];
		}
		else {
			FXDViewController *destinationScene = (FXDViewController*)uncoveringSegue.destinationViewController;
			[self configureUpperMenuViewForCurrentScene:destinationScene];
		}
	}
	
	if (self.groupBottomMenu) {
		if (pulledScene) {
			[self configureBottomMenuViewForCurrentScene:pulledScene];
		}
		else {
			FXDViewController *destinationScene = (FXDViewController*)uncoveringSegue.destinationViewController;
			[self configureBottomMenuViewForCurrentScene:destinationScene];
		}
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
		 
		 self.isUncovering = NO;
	 }];
}

- (void)uncoverAllSceneWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {
	//MARK: Assume direction is only vertical
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
	
	
	if ([lateAddedSceneArray count] == 0) {
		lateAddedSceneArray = nil;

		if (didFinishBlock) {
			didFinishBlock(YES);
		}

		return;
	}


	self.isUncovering = YES;

	FXDLog_DEFAULT;
	FXDLog(@"1.self.childViewControllers: %@", self.childViewControllers);
	FXDLog(@"lateAddedControllerArray: %@", lateAddedSceneArray);
	CGFloat totalUncoveringOffsetY = 0.0;
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		totalUncoveringOffsetY += childScene.view.frame.size.height;
	}
	
	FXDLog(@"totalUncoveringOffsetY: %f", totalUncoveringOffsetY);
	
	
	__block NSMutableArray *animatedFrameObjArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		CGRect animatedFrame = childScene.view.frame;
		animatedFrame.origin.y += totalUncoveringOffsetY;
		
		[animatedFrameObjArray addObject:NSStringFromCGRect(animatedFrame)];
		
		[childScene willMoveToParentViewController:nil];
	}
	
	FXDLog(@"animatedFrameObjArray: %@", animatedFrameObjArray);
	
	
	FXDViewController *rootScene = self.childViewControllers[0];
	
	if (self.groupUpperMenu) {
		[self configureUpperMenuViewForCurrentScene:rootScene];
	}
	if (self.groupBottomMenu) {
		[self configureBottomMenuViewForCurrentScene:rootScene];
	}

	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveLinear
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
		 
		 self.isUncovering = NO;
		 
		 if (didFinishBlock) {
			 didFinishBlock(YES);
		 }
	 }];
}

#pragma mark -
- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene {	//FXDLog_OVERRIDE;
}

- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene {	//FXDLog_OVERRIDE;
}

#pragma mark -
- (COVERING_OFFSET)coveringOffsetForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType {
	
	COVERING_OFFSET coveringOffset = {0.0, 0.0};
	
	COVERING_DIRECTION coveringDirection = [self coveringDirectionForDirectionType:coverDirectionType];
	
	coveringOffset.x = (self.view.frame.size.width *(CGFloat)coveringDirection.x);
	coveringOffset.y = (self.view.frame.size.height *(CGFloat)coveringDirection.y);
	
	return coveringOffset;
}

- (COVERING_DIRECTION)coveringDirectionForDirectionType:(COVER_DIRECTION_TYPE)coverDirectionType {
	
	COVERING_DIRECTION coveringDirection = {0, 0};
	
	switch (coverDirectionType) {
		case coverDirectionTop:
			coveringDirection.y = -1;
			break;
						
		case coverDirectionBottom:
			coveringDirection.y = 1;
			break;
			
		default:
			break;
	}
	
	return coveringDirection;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation FXDViewController (Covering)

#pragma mark - Public
- (COVER_DIRECTION_TYPE)coverDirectionType {
	return coverDirectionTop;
}

#pragma mark -
- (BOOL)shouldCoverAbove {
	return NO;
}

- (BOOL)shouldStayFixed {
	return NO;
}

#pragma mark -
- (NSNumber*)offsetYforUncovering {
	return nil;
}

@end
