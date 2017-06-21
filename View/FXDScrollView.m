

#import "FXDScrollView.h"


@implementation UIScrollView (Essential)
- (void)configureZoomValueForImageView:(UIImageView*)imageView forSize:(CGSize)size shouldAnimate:(BOOL)shouldAnimate {	FXDLog_DEFAULT;

	if (CGSizeEqualToSize(size, CGSizeZero)) {
		size = self.bounds.size;
	}

	FXDLogSize(size);
	FXDLogSize(imageView.image.size);

	
	// calculate min/max zoomscale
	CGFloat xScale = size.width  / imageView.image.size.width;
	CGFloat yScale = size.height / imageView.image.size.height;
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
- (void)configureContentInsetForSubview:(UIView*)subview forSize:(CGSize)size {
	if (CGSizeEqualToSize(size, CGSizeZero)) {
		size = self.bounds.size;
	}


	CGFloat horizontalInset = (size.width -subview.frame.size.width)/2.0;
	CGFloat verticalInset = (size.height -subview.frame.size.height)/2.0;
	
	if (horizontalInset < 0.0) {
		horizontalInset = 0.0;
	}
	
	if (verticalInset < 0.0) {
		verticalInset = 0.0;
	}
	
	UIEdgeInsets modifiedInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
	
	self.contentInset = modifiedInset;
}

- (void)configureContentInsetForClippingFrame:(CGRect)clippingFrame {	FXDLog_DEFAULT;
	FXDLogRect(self.frame);
	FXDLogRect(clippingFrame);
	
	UIEdgeInsets modifiedInset = self.contentInset;
	FXDLog(@"1.%@", _Struct(modifiedInset));
	
	modifiedInset.left = clippingFrame.origin.x -self.frame.origin.x;
	modifiedInset.top = clippingFrame.origin.y -self.frame.origin.y;
	modifiedInset.bottom = self.frame.size.height -(modifiedInset.top +clippingFrame.size.height);
	modifiedInset.right = self.frame.size.width -(modifiedInset.left +clippingFrame.size.width);
	
	FXDLog(@"2.%@", _Struct(modifiedInset));
	
	self.contentInset = modifiedInset;
}

#pragma mark -
- (void)configureContentSizeForSubview:(UIView*)subView {
	CGSize modifiedSize = subView.frame.size;
	modifiedSize.width += (self.frame.size.width);
	modifiedSize.height += (self.frame.size.height);
	self.contentSize = modifiedSize;
}

#pragma mark -
- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset {
	
	CGPoint oldPosition = subView.frame.origin;
	
	CGRect modifiedFrame = subView.frame;
	modifiedFrame.origin.x = (self.contentSize.width - modifiedFrame.size.width)/2.0;
	modifiedFrame.origin.y = (self.contentSize.height - modifiedFrame.size.height)/2.0;
	subView.frame = modifiedFrame;
	
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

- (BOOL)isScrolledByUser {
	return (self.isTracking || self.isDragging);
}

#pragma mark -
- (CGFloat)horizontalProgress {
	//MARK: Need to find the correct calculation, considering contentInset
	CGFloat totalWidth = self.contentSize.width +self.contentInset.left +self.contentInset.right;

	if (totalWidth > self.bounds.size.width) {
		totalWidth -= self.bounds.size.width;
	}

	CGFloat progress = (self.contentOffset.x +self.contentInset.left)/totalWidth;
	FXDLogVariable(progress);

	return progress;
}

#pragma mark -
- (CGPoint)snappedOffsetFromContentOffset:(CGPoint)contentOffset withMinimumOffset:(CGPoint)minimumOffset shouldUpdate:(BOOL)shouldUpdate {

	//MARK: Be careful with left inset adding and subtracting

	CGPoint snappedOffset = contentOffset;
	snappedOffset.x += self.contentInset.left;


	NSInteger snappedIndex = (snappedOffset.x/minimumOffset.x);

	snappedOffset.x = snappedIndex*minimumOffset.x;


	if (fabs(contentOffset.x+self.contentInset.left-snappedOffset.x) > (minimumOffset.x/2.0)) {
		snappedOffset.x = (snappedIndex+1)*minimumOffset.x;
	}


	snappedOffset.x -= self.contentInset.left;

	if (shouldUpdate) {
		[self setContentOffset:snappedOffset animated:YES];
	}

	return snappedOffset;
}

@end
