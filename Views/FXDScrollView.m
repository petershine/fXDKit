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
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	
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
- (void)configureZoomValueForImageView:(UIImageView*)imageView shouldAnimate:(BOOL)shouldAnimate {	FXDLog_DEFAULT;
	FXDLog(@"self.bounds.size: %@", NSStringFromCGSize(self.bounds.size));
	FXDLog(@"imageView.image.size: %@", NSStringFromCGSize(imageView.image.size));
	
	// calculate min/max zoomscale
	CGFloat xScale = self.bounds.size.width  / imageView.image.size.width;
	CGFloat yScale = self.bounds.size.height / imageView.image.size.height;
	FXDLog(@"xScale: %f, yScale: %f", xScale, yScale);
	
	
	CGFloat minScale = MIN(xScale, yScale);
	CGFloat maxScale = 2.0;	//MARK: if you want to limit to screen size: MAX(xScale, yScale);
	
	if (minScale > 1.0) {
		minScale = 1.0;
	}
	
	FXDLog(@"minScale: %f, maxScale: %f", minScale, maxScale);
	
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	
	
	FXDLog(@"1.imageView.frame: %@", NSStringFromCGRect(imageView.frame));
	[self setZoomScale:self.minimumZoomScale animated:shouldAnimate];
	FXDLog(@"2.imageView.frame: %@", NSStringFromCGRect(imageView.frame));
}

#pragma mark -
- (void)configureContentInsetForSubview:(UIView*)subview {	//FXDLog_DEFAULT;
	CGFloat horizontalInset = (self.frame.size.width -subview.frame.size.width)/2.0;
	CGFloat verticalInset = (self.frame.size.height -subview.frame.size.height)/2.0;
	
	if (horizontalInset < 0.0) {
		horizontalInset = 0.0;
	}
	
	if (verticalInset < 0.0) {
		verticalInset = 0.0;
	}
	
	UIEdgeInsets modifiedInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
	
	[self setContentInset:modifiedInset];
}

- (void)configureContentInsetForClippingFrame:(CGRect)clippingFrame {	FXDLog_DEFAULT;
	FXDLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
	FXDLog(@"clippingFrame: %@", NSStringFromCGRect(clippingFrame));
	
	UIEdgeInsets modifiedInsets = self.contentInset;
	FXDLog(@"1.modifiedInsets: %@", NSStringFromUIEdgeInsets(modifiedInsets));
	
	modifiedInsets.left = clippingFrame.origin.x -self.frame.origin.x;
	modifiedInsets.top = clippingFrame.origin.y -self.frame.origin.y;
	modifiedInsets.bottom = self.frame.size.height -(modifiedInsets.top +clippingFrame.size.height);
	modifiedInsets.right = self.frame.size.width -(modifiedInsets.left +clippingFrame.size.width);
	
	FXDLog(@"2.modifiedInsets: %@", NSStringFromUIEdgeInsets(modifiedInsets));
	
	[self setContentInset:modifiedInsets];
}

#pragma mark -
- (void)configureContentSizeForSubview:(UIView*)subView {	//FXDLog_DEFAULT;	
	CGSize modifiedSize = subView.frame.size;
	modifiedSize.width += (self.frame.size.width);
	modifiedSize.height += (self.frame.size.height);
	[self setContentSize:modifiedSize];
}

#pragma mark -
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

#pragma mark -
- (void)scrollToCenterToShowSubView:(UIView*)subView shouldAnimate:(BOOL)shouldAnimate {	//FXDLog_DEFAULT;
	
	CGRect visibleRect = subView.frame;
	
	visibleRect.origin.x = visibleRect.origin.x -((self.frame.size.width -visibleRect.size.width)/2.0);
	visibleRect.origin.y = visibleRect.origin.y -((self.frame.size.height -visibleRect.size.height)/2.0);
	visibleRect.size.width = self.frame.size.width;
	visibleRect.size.height = self.frame.size.height;
		
	[self scrollRectToVisible:visibleRect animated:shouldAnimate];
}

#pragma mark -
- (BOOL)isScrollingCurrently {
	return (self.isDragging && self.isDecelerating && !self.isTracking);
}

@end
