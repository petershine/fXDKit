//
//  FXDPopoverBackgroundView.h
//
//
//  Created by petershine on 11/21/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDPopoverBackgroundView : UIPopoverBackgroundView <FXDprotocolShared> {
	CGFloat _arrowOffset;
	UIPopoverArrowDirection _arrowDirection;
}

@property (nonatomic) BOOL shouldHideArrowView;
@property (strong, nonatomic) NSString *titleText;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property (strong, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imageviewArrow;


#pragma mark - IBActions

#pragma mark - Initialization

#pragma mark - Public
+ (CGFloat)minimumInset;


#pragma mark - Observer

#pragma mark - Delegate

@end
