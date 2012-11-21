//
//  FXDPopoverBackgroundView.m
//
//
//  Created by petershine on 11/21/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDPopoverBackgroundView.h"


#pragma mark - Public implementation
@implementation FXDPopoverBackgroundView


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];

    if (self) {//MARK: Cannot use awakeFromNib
#if DEBUG
		self.backgroundColor = [UIColor darkGrayColor];
#endif
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 8;

		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOpacity = 0.4;
		self.layer.shadowRadius = 2;
		self.layer.shadowOffset = CGSizeMake(0, 2);

		// Primitives
		_arrowDirection = UIPopoverArrowDirectionUp;

		// Instance variables

		// Properties

		// IBOutlets

    }

    return self;
}


#pragma mark - Property overriding
- (CGFloat)arrowOffset {
	return _arrowOffset;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
	_arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
	return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
	_arrowDirection = arrowDirection;
}


#pragma mark - Method overriding
+ (CGFloat)arrowHeight {	FXDLog_OVERRIDE;
	return 0;
}

+ (CGFloat)arrowBase {	FXDLog_OVERRIDE;
	return 0;
}

+ (UIEdgeInsets)contentViewInsets {	FXDLog_OVERRIDE;
	return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];

	FXDLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
	FXDLog(@"1.self.backgroundView: %@", self.backgroundView);
}

#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIPopoverBackgroundView (Added)
@end