//
//  FXDPopoverBackgroundView.h
//
//
//  Created by petershine on 11/21/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#ifndef popoverCornerRadius
	#define popoverCornerRadius 8.0
#endif

#ifndef popoverArrowOffset
	#define popoverArrowOffset ￼0
#endif

#ifndef popoverArrowDirection
	#define popoverArrowDirection UIPopoverArrowDirectionUp
#endif


#ifndef popoverArrowHeight
	#define popoverArrowHeight ￼0
#endif

#ifndef popoverArrowBase
	#define popoverArrowBase ￼0
#endif


#ifndef popoverContentViewInsetsTop
	#define popoverContentViewInsetsTop		10.0
#endif

#ifndef popoverContentViewInsetsLeft
	#define popoverContentViewInsetsLeft	10.0
#endif

#ifndef popoverContentViewInsetsBottom
	#define popoverContentViewInsetsBottom	10.0
#endif

#ifndef popoverContentViewInsetsRight
	#define popoverContentViewInsetsRight	10.0
#endif


#import "FXDKit.h"


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView {
    // Primitives
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;

	// Instance variables
}

// Properties
@property (strong, nonatomic) NSString *titleText;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *titleView;


#pragma mark - IBActions


#pragma mark - Public
+ (FXDPopoverBackgroundView*)sharedInstance;

- (void)configureTitleTextAndTitleViewFromSharedInstance;


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIPopoverBackgroundView (Added)
@end