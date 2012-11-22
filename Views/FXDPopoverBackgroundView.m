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
- (void)dealloc {	FXDLog_DEFAULT;
	[[self class] sharedInstance].titleText = nil;
	[[self class] sharedInstance].viewTitle = nil;
	
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
+ (CGFloat)arrowHeight {	FXDLog_OVERRIDE;
	return 22;
}

+ (CGFloat)arrowBase {	FXDLog_OVERRIDE;
	return 22;
}

+ (UIEdgeInsets)contentViewInsets {	FXDLog_OVERRIDE;
	return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)layoutSubviews {	FXDLog_DEFAULT;

	CGFloat popoverArrowHeight = [[self class] arrowHeight];
	CGFloat popoverArrowBase = [[self class] arrowBase];

	UIEdgeInsets popoverContentViewInsets = [[self class] contentViewInsets];


	if (self.viewBackground == nil) {
		
		self.viewBackground = [[UIView alloc] initWithFrame:
							   CGRectMake(0, popoverArrowHeight, self.frame.size.width, self.frame.size.height-popoverArrowHeight)];
#if DEBUG
		self.viewBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
#else
		self.viewBackground.backgroundColor = [UIColor clearColor];
#endif

		self.viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		self.viewBackground.layer.masksToBounds = YES;
		self.viewBackground.layer.cornerRadius = self.layer.cornerRadius;

		[self addSubview:self.viewBackground];
	}


	if (self.imageviewArrow == nil) {
		FXDLog(@"self.arrowOffset: %f", self.arrowOffset);
		FXDLog(@"self.arrowDirection: %d", self.arrowDirection);

		self.imageviewArrow = [[UIImageView alloc] initWithFrame:
							   CGRectMake(0, 0, popoverArrowBase, popoverArrowBase+self.viewBackground.layer.cornerRadius)];

#if DEBUG
		self.imageviewArrow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
#else
		self.viewBackground.backgroundColor = [UIColor clearColor];
#endif

		//TODO: Modify based arrowDirection
		CGFloat modifiedCenterX = (self.frame.size.width/2.0) +self.arrowOffset;
		self.imageviewArrow.center = CGPointMake(modifiedCenterX, self.imageviewArrow.center.y);

		[self addSubview:self.imageviewArrow];
	}


	self.titleText = [[self class] sharedInstance].titleText;
	self.viewTitle = [[self class] sharedInstance].viewTitle;


	if (self.viewTitle == nil && self.titleText) {
		self.viewTitle = [[UILabel alloc] initWithFrame:
						  CGRectMake(0, 0, self.frame.size.width, popoverContentViewInsets.top)];

		self.viewTitle.backgroundColor = [UIColor clearColor];

		[(UILabel*)self.viewTitle setTextAlignment:NSTextAlignmentCenter];
		[(UILabel*)self.viewTitle setFont:[UIFont boldSystemFontOfSize:20]];
		[(UILabel*)self.viewTitle setTextColor:[UIColor whiteColor]];
		[(UILabel*)self.viewTitle setShadowColor:[UIColor darkGrayColor]];

		[(UILabel*)self.viewTitle setText:self.titleText];
	}

	if (self.viewTitle) {
		CGRect modifiedFrame = self.viewTitle.frame;
		modifiedFrame.origin.x = ((self.frame.size.width -modifiedFrame.size.width)/2.0);
		modifiedFrame.origin.y = ((popoverContentViewInsets.top -modifiedFrame.size.height)/2.0);
		modifiedFrame.origin.y += popoverArrowHeight;
		[self.viewTitle setFrame:modifiedFrame];

		[self addSubview:self.viewTitle];
		[self bringSubviewToFront:self.viewTitle];
	}
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIPopoverBackgroundView (Added)
@end