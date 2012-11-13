//
//  FXDScrollView.m
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDScrollView.h"


#pragma mark - Public implementation
@implementation FXDScrollView


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
		//MARK: awakeFromNib is called automatically
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	[super awakeFromNib];
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIScrollView (Added)
- (void)configureContentInsetForOverlayRect:(CGRect)overlayRect {	FXDLog_DEFAULT;
	FXDLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
	FXDLog(@"overlayRect: %@", NSStringFromCGRect(overlayRect));
	
	UIEdgeInsets modifiedInsets = self.contentInset;
	FXDLog(@"(before)modifiedInsets: %@", NSStringFromUIEdgeInsets(modifiedInsets));
	
	modifiedInsets.left = overlayRect.origin.x -self.frame.origin.x;
	modifiedInsets.top = overlayRect.origin.y -self.frame.origin.y;
	modifiedInsets.bottom = self.frame.size.height -(modifiedInsets.top +overlayRect.size.height);
	modifiedInsets.right = self.frame.size.width -(modifiedInsets.left +overlayRect.size.width);
	
	FXDLog(@"(after)modifiedInsets: %@", NSStringFromUIEdgeInsets(modifiedInsets));
	
	[self setContentInset:modifiedInsets];
}

- (void)configureContentSizeForSubView:(UIView*)subView {	//FXDLog_DEFAULT;	
	CGSize modifiedSize = subView.frame.size;
	modifiedSize.width += (self.frame.size.width);
	modifiedSize.height += (self.frame.size.height);
	[self setContentSize:modifiedSize];
}

- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset {	//FXDLog_DEFAULT;
	
	CGPoint oldPosition = subView.frame.origin;
	
	CGRect modifiedFrame = subView.frame;
	modifiedFrame.origin.x = (self.contentSize.width - modifiedFrame.size.width)/2.0;
	modifiedFrame.origin.y = (self.contentSize.height - modifiedFrame.size.height)/2.0;
	[subView setFrame:modifiedFrame];
	
	if (shouldModifyOffset) {
		CGPoint newPosition = modifiedFrame.origin;
		
		CGPoint modifiedOffset = self.contentOffset;
		modifiedOffset.x = modifiedOffset.x + (newPosition.x - oldPosition.x);
		modifiedOffset.y = modifiedOffset.y + (newPosition.y - oldPosition.y);		
		[self setContentOffset:modifiedOffset animated:NO];
	}
}

- (void)scrollToCenterToShowSubView:(UIView*)subView withAnimation:(BOOL)withAnimation {	//FXDLog_DEFAULT;
	
	CGRect visibleRect = subView.frame;
	
	visibleRect.origin.x = visibleRect.origin.x -((self.frame.size.width -visibleRect.size.width)/2.0);
	visibleRect.origin.y = visibleRect.origin.y -((self.frame.size.height -visibleRect.size.height)/2.0);
	visibleRect.size.width = self.frame.size.width;
	visibleRect.size.height = self.frame.size.height;
		
	[self scrollRectToVisible:visibleRect animated:withAnimation];
}

- (BOOL)isScrollingCurrently {
	return (self.isDragging && self.isDecelerating && !self.isTracking);
}


@end
