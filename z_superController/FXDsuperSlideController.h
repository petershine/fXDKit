//
//  FXDsuperSlideController.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDsegueTransition : FXDStoryboardSegue
@end

@interface FXDsegueCovering : FXDsegueTransition
@end

@interface FXDsegueUncovering : FXDsegueTransition
@end


@interface FXDsuperSlideController : FXDNavigationController <UINavigationBarDelegate> {
    // Primitives

	// Instance variables

}

// Properties

// IBOutlets


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public
- (void)coverWithCoveringSegue:(FXDsegueCovering*)coveringSegue;
- (void)uncoverWithUncoveringSegue:(FXDsegueUncovering*)uncoveringSegue;

- (BOOL)canAnimateWithTransitionSegue:(FXDsegueTransition*)transitionSegue;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UINavigationBarDelegate


@end


#pragma mark - Category
@interface FXDViewController (Covering)

#pragma mark - IBActions
- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;

#pragma mark - Public
- (SLIDE_DIRECTION_TYPE)coverDirectionType;
- (BOOL)shouldSkipPushingNavigationItems;

@end
