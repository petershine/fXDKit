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
	[[self class] sharedInstance].shouldHideArrowView = NO;

	[[self class] sharedInstance].titleText = nil;
	[[self class] sharedInstance].viewTitle = nil;
	
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];

    if (self) {//MARK: Cannot use awakeFromNib
#if ForDEVELOPER
		self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:alphaValueDefault];
#endif

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
	CGFloat arrowHeight = 22.0;

	if ([[self class] sharedInstance].shouldHideArrowView) {
		arrowHeight = 0.0;
	}

	return arrowHeight;
}

+ (CGFloat)arrowBase {	FXDLog_OVERRIDE;
	CGFloat arrowBase = 22.0;

	if ([[self class] sharedInstance].shouldHideArrowView) {
		arrowBase = 0.0;
	}

	return arrowBase;
}

+ (UIEdgeInsets)contentViewInsets {	FXDLog_OVERRIDE;
	CGFloat minimumInset = [self minimumInset];
	
	return UIEdgeInsetsMake(minimumInset, minimumInset, minimumInset, minimumInset);
}

- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];

	CGFloat arrowHeight = [[self class] arrowHeight];
	CGFloat arrowBase = [[self class] arrowBase];

	UIEdgeInsets contentViewInsets = [[self class] contentViewInsets];


	if (self.viewBackground == nil) {
		
		self.viewBackground = [[UIView alloc] initWithFrame:
							   CGRectMake(0,
										  arrowHeight,
										  self.frame.size.width,
										  self.frame.size.height -arrowHeight)];

#if ForDEVELOPER
		self.viewBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValueDefault];
#else
		self.viewBackground.backgroundColor = [UIColor clearColor];
#endif

		self.viewBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		[self addSubview:self.viewBackground];
	}


	if (self.imageviewArrow == nil) {

		self.imageviewArrow = [[UIImageView alloc] initWithFrame:
							   CGRectMake(0,
										  0,
										  arrowBase,
										  arrowHeight)];

#if ForDEVELOPER
		self.imageviewArrow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValueDefault];
#else
		self.imageviewArrow.backgroundColor = [UIColor clearColor];
#endif

#warning "//TODO: Modify based on arrowDirection"		
		CGFloat modifiedCenterX = (self.frame.size.width/2.0) +self.arrowOffset;
		self.imageviewArrow.center = CGPointMake(modifiedCenterX, self.imageviewArrow.center.y);

		[self addSubview:self.imageviewArrow];
	}


	self.titleText = [[self class] sharedInstance].titleText;
	self.viewTitle = [[self class] sharedInstance].viewTitle;


	if (self.viewTitle == nil && self.titleText) {
		self.viewTitle = [[UILabel alloc] initWithFrame:
						  CGRectMake(0,
									 0,
									 self.frame.size.width,
									 contentViewInsets.top)];

		self.viewTitle.backgroundColor = [UIColor clearColor];

		[(UILabel*)self.viewTitle setTextAlignment:NSTextAlignmentCenter];
		[(UILabel*)self.viewTitle setFont:[UIFont boldSystemFontOfSize:20]];
		[(UILabel*)self.viewTitle setTextColor:[UIColor whiteColor]];
		[(UILabel*)self.viewTitle setShadowColor:[UIColor darkGrayColor]];

		[(UILabel*)self.viewTitle setText:self.titleText];
	}

	if (self.viewTitle) {
		CGFloat minimumInset = [[self class] minimumInset];
		
		CGRect modifiedFrame = self.viewTitle.frame;
		modifiedFrame.origin.x = minimumInset;

		modifiedFrame.origin.y = ((contentViewInsets.top -modifiedFrame.size.height)/2.0);
		modifiedFrame.origin.y += arrowHeight;
		modifiedFrame.origin.y -= (minimumInset/2.0);

		modifiedFrame.size.width = self.frame.size.width -(minimumInset*2.0);

		[self.viewTitle setFrame:modifiedFrame];

		[self addSubview:self.viewTitle];
		[self bringSubviewToFront:self.viewTitle];
	}
}


#pragma mark - IBActions


#pragma mark - Public
+ (CGFloat)minimumInset {	FXDLog_OVERRIDE;
	return 0.0;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIPopoverBackgroundView (Added)
@end