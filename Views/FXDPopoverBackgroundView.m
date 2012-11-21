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
- (void)dealloc {	FXDLog_OVERRIDE;
	[[self class] sharedInstance].titleText = nil;
	[[self class] sharedInstance].titleView = nil;
	
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];

    if (self) {//MARK: Cannot use awakeFromNib
#if DEBUG
		self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
#endif
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = popoverCornerRadius;

		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOpacity = 0.4;
		self.layer.shadowRadius = 2;
		self.layer.shadowOffset = CGSizeMake(0, 2);

		// Primitives

		// Instance variables

		// Properties

		// IBOutlets

    }

    return self;
}

+ (FXDPopoverBackgroundView*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
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
+ (CGFloat)arrowHeight {
	return popoverArrowHeight;
}

+ (CGFloat)arrowBase {
	return popoverArrowBase;
}

+ (UIEdgeInsets)contentViewInsets {
	return UIEdgeInsetsMake(popoverContentViewInsetsTop, popoverContentViewInsetsLeft, popoverContentViewInsetsBottom, popoverContentViewInsetsRight);
}

- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];

	if (self.backgroundView == nil) {
		CGRect modifiedFrame = self.frame;
		modifiedFrame.origin.x = 0.0;
		modifiedFrame.origin.y = popoverArrowHeight;
		modifiedFrame.size.height -= popoverArrowHeight;

		self.backgroundView = [[UIView alloc] initWithFrame:modifiedFrame];
		self.backgroundView.backgroundColor = [UIColor blackColor];

		self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		self.backgroundView.layer.masksToBounds = YES;
		self.backgroundView.layer.cornerRadius = popoverCornerRadius;

		[self addSubview:self.backgroundView];
		[self sendSubviewToBack:self.backgroundView];
	}
	

	[self configureTitleTextAndTitleViewFromSharedInstance];

	if (self.titleView == nil && self.titleText) {
		self.titleView = [[UILabel alloc] initWithFrame:
						  CGRectMake(0, 0, self.frame.size.width, popoverContentViewInsetsTop)];

		self.titleView.backgroundColor = [UIColor clearColor];

		[(UILabel*)self.titleView setTextAlignment:NSTextAlignmentCenter];
		[(UILabel*)self.titleView setFont:[UIFont boldSystemFontOfSize:20]];
		[(UILabel*)self.titleView setTextColor:[UIColor whiteColor]];
		[(UILabel*)self.titleView setShadowColor:[UIColor darkGrayColor]];

		[(UILabel*)self.titleView setText:self.titleText];
	}
	
	if (self.titleView) {
		CGRect modifiedFrame = self.titleView.frame;
		modifiedFrame.origin.x = ((self.frame.size.width -modifiedFrame.size.width)/2.0);
		modifiedFrame.origin.y = ((popoverContentViewInsetsTop -modifiedFrame.size.height)/2.0);
		modifiedFrame.origin.y += popoverArrowHeight;
		[self.titleView setFrame:modifiedFrame];

		[self addSubview:self.titleView];
		[self bringSubviewToFront:self.titleView];
	}
}


#pragma mark - IBActions


#pragma mark - Public
- (void)configureTitleTextAndTitleViewFromSharedInstance {	FXDLog_OVERRIDE;

	self.titleText = [[self class] sharedInstance].titleText;
	self.titleView = [[self class] sharedInstance].titleView;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIPopoverBackgroundView (Added)
@end