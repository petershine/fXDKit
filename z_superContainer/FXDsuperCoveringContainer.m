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
	
	self.minimumChildCount = self.childViewControllers.count;
	FXDLogVariable(self.minimumChildCount);
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding

#pragma mark - Method overriding
- (BOOL)canAnimateWithTransitionSegue:(FXDsuperTransitionSegue*)transitionSegue {
	
	BOOL canAnimate = NO;
	
	FXDViewController *destinationScene = (FXDViewController*)transitionSegue.destinationViewController;
	FXDViewController *sourceScene = (FXDViewController*)transitionSegue.sourceViewController;
	
	FXDLogObject(destinationScene);
	FXDLogObject(sourceScene);
	
	if ([sourceScene isKindOfClass:[FXDViewController class]]
		&& [destinationScene isKindOfClass:[FXDViewController class]]) {
		canAnimate = YES;
	}
	
	
	FXDLog(@"%@ %@", _BOOL(self.isCovering), _BOOL(self.isUncovering));
	
	if (self.isCovering || self.isUncovering) {
		canAnimate = NO;
	}
	
	FXDLogBOOL(canAnimate);
	
	return canAnimate;
}


#pragma mark - Segues
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_DEFAULT;

	FXDLogObject(toViewController);
	FXDLogObject(fromViewController);
	FXDLogObject(identifier);

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

	
	FXDViewController *presentedScene = (FXDViewController*)coveringSegue.destinationViewController;
	[self addChildViewController:presentedScene];
	
	if (self.mainNavigationbar) {
		[self configureUpperMenuViewForCurrentScene:presentedScene];
	}
	
	if (self.mainToolbar) {
		[self configureBottomMenuViewForCurrentScene:presentedScene];
	}

	
	COVERING_OFFSET coveringOffset = [self coveringOffsetForDirectionType:[presentedScene coverDirectionType]];
	COVERING_DIRECTION coveringDirection = [self coveringDirectionForDirectionType:[presentedScene coverDirectionType]];
	
	
	CGRect animatedFrame = presentedScene.view.frame;
	animatedFrame.origin.y = 0.0;
	FXDLog(@"1.%@", _Rect(animatedFrame));

	CGRect modifiedFrame = presentedScene.view.frame;
	modifiedFrame.origin.x -= coveringOffset.x;
	modifiedFrame.origin.y -= coveringOffset.y;
	modifiedFrame.origin.y += (heightDynamicStatusBar *coveringDirection.y);
	presentedScene.view.frame = modifiedFrame;

	
	FXDViewController *pushedScene = nil;
	CGRect animatedPushedFrame = CGRectZero;
		
	if ([presentedScene shouldCoverAbove] == NO
		&& self.childViewControllers.count > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger destinationIndex = [self.childViewControllers indexOfObject:presentedScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"%@ %@", _Object(childScene), _Variable([childScene shouldStayFixed]));
			
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
					
					childScene.view.frame = modifiedPushedFrame;
				}
			}
		}
	}
	
	FXDLog(@"%@ %@", _Object(pushedScene), _Rect(animatedPushedFrame));

	presentedScene.view.autoresizingMask = UIViewAutoresizingNone;
	presentedScene.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	
	[self.view insertSubview:presentedScene.view belowSubview:self.mainNavigationbar];
	[presentedScene didMoveToParentViewController:self];


	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 presentedScene.view.frame = animatedFrame;
		 
		 if (pushedScene) {
			 pushedScene.view.frame = animatedPushedFrame;
		 }
	 }
	 completion:^(BOOL didFinish) {	FXDLog_DEFAULT;
		 FXDLog_BLOCK(self, @selector(coverWithSegue:));
		 FXDLogObject(self.childViewControllers);
		 
		 self.isCovering = NO;

		 [presentedScene didFinishAnimation];
	 }];
}

- (void)uncoverWithSegue:(FXDsegueUncover*)uncoveringSegue {	FXDLog_DEFAULT;
	
	if ([self canAnimateWithTransitionSegue:uncoveringSegue] == NO) {
		return;
	}


	self.isUncovering = YES;


	FXDViewController *dismissedScene = (FXDViewController*)uncoveringSegue.sourceViewController;
	
	COVERING_OFFSET uncoveringOffset = [self coveringOffsetForDirectionType:[dismissedScene coverDirectionType]];
	COVERING_DIRECTION uncoveringDirection = [self coveringDirectionForDirectionType:[dismissedScene coverDirectionType]];
	

	CGRect animatedFrame = dismissedScene.view.frame;
	animatedFrame.origin.x -= (animatedFrame.size.width *uncoveringDirection.x);

	CGFloat animatedAlpha = (self.shouldFadeOutUncovering) ? 0.0:dismissedScene.view.alpha;
	
	
	CGFloat uncoveringOffsetY = [[dismissedScene offsetYforUncovering] floatValue];
	FXDLog(@"1.%@", _Variable(uncoveringOffsetY));
	
	if (uncoveringOffsetY > 0.0) {
		animatedFrame.origin.y -= (uncoveringOffsetY *uncoveringDirection.y);
	}
	else {
		animatedFrame.origin.y -= (animatedFrame.size.height *uncoveringDirection.y);
	}
	FXDLog(@"2.CALCULATED uncoveringOffsetY: %f - %f = %f", dismissedScene.view.frame.origin.y, animatedFrame.origin.y, (dismissedScene.view.frame.origin.y -animatedFrame.origin.y));
	
	
	FXDViewController *pulledScene = nil;
	CGRect animatedPulledFrame = CGRectZero;
	
	if ([dismissedScene shouldCoverAbove] == NO
		&& self.childViewControllers.count > self.minimumChildCount) {
		//MARK: Including newly added child, the count should be bigger than one
		
		NSInteger sourceIndex = [self.childViewControllers indexOfObject:dismissedScene];
		
		for (FXDViewController *childScene in self.childViewControllers) {
			FXDLog(@"%@ %@", _Object(childScene), _Variable([childScene shouldStayFixed]));
			
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
					
					childScene.view.frame = modifiedPushedFrame;
				}
			}
		}
	}
	
	FXDLog(@"%@ %@", _Object(pulledScene), _Rect(animatedPulledFrame));
	
	if (self.mainNavigationbar) {
		if (pulledScene) {
			[self configureUpperMenuViewForCurrentScene:pulledScene];
		}
		else {
			FXDViewController *destinationScene = (FXDViewController*)uncoveringSegue.destinationViewController;
			[self configureUpperMenuViewForCurrentScene:destinationScene];
		}
	}
	
	if (self.mainToolbar) {
		if (pulledScene) {
			[self configureBottomMenuViewForCurrentScene:pulledScene];
		}
		else {
			FXDViewController *destinationScene = (FXDViewController*)uncoveringSegue.destinationViewController;
			[self configureBottomMenuViewForCurrentScene:destinationScene];
		}
	}
	
	
	[dismissedScene willMoveToParentViewController:nil];

	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 dismissedScene.view.frame = animatedFrame;
		 dismissedScene.view.alpha = animatedAlpha;
		 
		 if (pulledScene) {
			 pulledScene.view.frame = animatedPulledFrame;
		 }
	 }
	 completion:^(BOOL didFinish) {	FXDLog_DEFAULT;
		 FXDLog(@"%@ %@", _BOOL(didFinish), _Object(pulledScene));
		 
		 [dismissedScene.view removeFromSuperview];
		 [dismissedScene removeFromParentViewController];
		 
		 self.isUncovering = NO;

		 [dismissedScene didFinishAnimation];
	 }];
}

- (void)uncoverAllSceneWithFinishCallback:(FXDcallbackFinish)finishCallback {
	//MARK: Assume direction is only vertical
	if (self.childViewControllers.count == 0) {

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}

		return;
	}


	__block NSMutableArray *lateAddedSceneArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childScene in self.childViewControllers) {
		FXDLog(@"%@ %@", _BOOL(childScene), _Variable([childScene shouldStayFixed]));
		
		if ([childScene shouldStayFixed] == NO) {
			[lateAddedSceneArray addObject:childScene];
		}
	}
	
	
	if (lateAddedSceneArray.count == 0) {
		lateAddedSceneArray = nil;

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}

		return;
	}


	self.isUncovering = YES;

	FXDLog_DEFAULT;
	FXDLog(@"1.%@", _Object(self.childViewControllers));
	FXDLogObject(lateAddedSceneArray);

	CGFloat totalUncoveringOffsetY = 0.0;
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		totalUncoveringOffsetY += childScene.view.frame.size.height;
	}
	
	FXDLogVariable(totalUncoveringOffsetY);
	
	
	__block NSMutableArray *animatedFrameObjArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	for (FXDViewController *childScene in lateAddedSceneArray) {
		CGRect animatedFrame = childScene.view.frame;
		animatedFrame.origin.y += totalUncoveringOffsetY;
		
		[animatedFrameObjArray addObject:NSStringFromCGRect(animatedFrame)];
		
		[childScene willMoveToParentViewController:nil];
	}
	
	FXDLogObject(animatedFrameObjArray);
	
	
	FXDViewController *rootScene = [self.childViewControllers firstObject];
	
	if (self.mainNavigationbar) {
		[self configureUpperMenuViewForCurrentScene:rootScene];
	}
	if (self.mainToolbar) {
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
			 
			 childScene.view.frame = animatedFrame;
		 }
		 
	 } completion:^(BOOL didFinish) {	FXDLog_DEFAULT;
		 for (FXDViewController *childScene in lateAddedSceneArray) {
			 [childScene.view removeFromSuperview];
			 [childScene removeFromParentViewController];
		 }
		 
		 lateAddedSceneArray = nil;
		 animatedFrameObjArray = nil;
		 
		 FXDLog(@"2.%@", _Object(self.childViewControllers));
		 
		 self.isUncovering = NO;
		 
		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)configureUpperMenuViewForCurrentScene:(FXDViewController*)currentScene {
}

- (void)configureBottomMenuViewForCurrentScene:(FXDViewController*)currentScene {
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

#pragma mark -
- (void)didFinishAnimation {	FXDLog_OVERRIDE;

}
@end
