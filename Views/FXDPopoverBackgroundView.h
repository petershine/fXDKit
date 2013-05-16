//
//  FXDPopoverBackgroundView.h
//
//
//  Created by petershine on 11/21/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView {
    // Primitives
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;


}

// Properties
@property (assign, nonatomic) BOOL shouldHideArrowView;
@property (strong, nonatomic) NSString *titleText;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imageviewArrow;



#pragma mark - IBActions


#pragma mark - Public
+ (FXDPopoverBackgroundView*)sharedInstance;

+ (CGFloat)minimumInset;


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIPopoverBackgroundView (Added)
@end