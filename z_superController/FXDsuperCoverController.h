//
//  FXDsuperCoverController.h
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#pragma mark - Category
@interface FXDViewController (Covering)
- (IBAction)uncoverUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;

- (COVER_DIRECTION_TYPE)coverDirectionType;

@end


@interface FXDsegueCovering : FXDStoryboardSegue
@end

@interface FXDsegueUncovering : FXDStoryboardSegue
@end


#import "FXDNavigationController.h"

@interface FXDsuperCoverController : FXDNavigationController <UINavigationControllerDelegate> {
    // Primitives

	// Instance variables

}

// Properties
@property (strong, nonatomic) NSMutableArray *previousToolbarItemsArray;

// IBOutlets


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UINavigationControllerDelegate


@end
