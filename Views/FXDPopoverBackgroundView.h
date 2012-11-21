//
//  FXDPopoverBackgroundView.h
//
//
//  Created by petershine on 11/21/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView {
    // Primitives
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;

	// Instance variables

}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *backgroundView;


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIPopoverBackgroundView (Added)
@end