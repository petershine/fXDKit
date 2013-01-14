//
//  FXDsuperCoverController.h
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


@interface FXDsuperCoverController : FXDNavigationController <UINavigationBarDelegate> {
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
- (IBAction)navigateBackUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;

- (COVER_DIRECTION_TYPE)coverDirectionType;
- (BOOL)shouldSkipPushingNavigationItems;

@end
