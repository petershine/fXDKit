//
//  FXDsuperSlideController.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

@interface FXDsegueSlidingIn : FXDsegueTransition
@end

@interface FXDsegueSlidingOut : FXDsegueTransition
@end


@interface FXDsuperSlideController : FXDNavigationController <UINavigationBarDelegate>

// Properties

// IBOutlets


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)canAnimateWithTransitionSegue:(FXDsegueTransition*)transitionSegue;

- (void)slideInWithSegue:(FXDsegueSlidingIn*)slidingInSegue;
- (void)slideOutWithSegue:(FXDsegueSlidingOut*)slidingOutSegue;

- (SLIDING_OFFSET)slidingOffsetForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType;
- (SLIDING_DIRECTION)slidingDirectionForSlideDirectionType:(SLIDE_DIRECTION_TYPE)slideDirectionType;

- (void)didFinishSlidingOutForControllerClassName:(NSString*)controllerClassName;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UINavigationBarDelegate


@end


#pragma mark - Category
@interface FXDViewController (Sliding)

#pragma mark - IBActions
- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)slideDirectionType;

#pragma mark -
- (BOOL)shouldPushNavigationItems;
- (BOOL)shouldCoverWhenSlidingIn;
- (BOOL)shouldStayCovered;

- (NSNumber*)distanceNumberForSlidingOut;

@end
