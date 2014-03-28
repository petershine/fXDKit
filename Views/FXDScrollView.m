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
- (instancetype)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
    if (self) {
        [self awakeFromNib];
    }
	
    return self;
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
	FXDLogSize(self.bounds.size);
	FXDLogSize(imageView.image.size);
	
	// calculate min/max zoomscale
	CGFloat xScale = self.bounds.size.width  / imageView.image.size.width;
	CGFloat yScale = self.bounds.size.height / imageView.image.size.height;
	FXDLog(@"%@, %@", _Variable(xScale), _Variable(yScale));
	
	
	CGFloat minScale = MIN(xScale, yScale);
	CGFloat maxScale = 2.0;	//MARK: if you want to limit to screen size: MAX(xScale, yScale);
	
	if (minScale > 1.0) {
		minScale = 1.0;
	}
	
	FXDLog(@"%@, %@", _Variable(minScale), _Variable(maxScale));
	
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	
	
	FXDLogRect(imageView.frame);
	[self setZoomScale:self.minimumZoomScale animated:shouldAnimate];
	FXDLogRect(imageView.frame);
}

#pragma mark -
- (void)configureContentInsetForSubview:(UIView*)subview {
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
	FXDLogRect(self.frame);
	FXDLogRect(clippingFrame);
	
	UIEdgeInsets modifiedInset = self.contentInset;
	FXDLogStruct(modifiedInset);
	
	modifiedInset.left = clippingFrame.origin.x -self.frame.origin.x;
	modifiedInset.top = clippingFrame.origin.y -self.frame.origin.y;
	modifiedInset.bottom = self.frame.size.height -(modifiedInset.top +clippingFrame.size.height);
	modifiedInset.right = self.frame.size.width -(modifiedInset.left +clippingFrame.size.width);
	
	FXDLogStruct(modifiedInset);
	
	[self setContentInset:modifiedInset];
}

#pragma mark -
- (void)configureContentSizeForSubview:(UIView*)subView {
	CGSize modifiedSize = subView.frame.size;
	modifiedSize.width += (self.frame.size.width);
	modifiedSize.height += (self.frame.size.height);
	[self setContentSize:modifiedSize];
}

#pragma mark -
- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset {
	
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
- (void)scrollToCenterToShowSubView:(UIView*)subView shouldAnimate:(BOOL)shouldAnimate {
	
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
