//
//  FXDView.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDView.h"


@implementation FXDView
@end


#pragma mark - Category
@implementation UIView (Essential)
+ (instancetype)viewFromNibName:(NSString*)nibName {
	UIView *view = [self viewFromNibName:nibName withOwner:nil];
	
	return view;
}

+ (instancetype)viewFromNib:(UINib*)nib {
	UIView *view = [self viewFromNib:nib withOwner:nil];
	
	return view;
}

+ (instancetype)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}

	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];

	UIView *view = [self viewFromNib:nib withOwner:ownerOrNil];

	return view;
}

+ (instancetype)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil {
	if (nib == nil) {
		NSString *nibName = NSStringFromClass([self class]);

		nib = [UINib nibWithNibName:nibName bundle:nil];
	}

	UIView *view = nil;

	NSArray *viewArray = [nib instantiateWithOwner:ownerOrNil options:nil];

	for (id subview in viewArray) {	//Assumes there is only one root object

		if ([[self class] isSubclassOfClass:[subview class]]) {
			view = subview;
			break;
		}
	}

#if ForDEVELOPER
	if (view == nil) {	FXDLog_DEFAULT;
		FXDLog(@"%@ %@", _Object([self class]), _Object(viewArray));
	}
#endif

	return view;
}

- (void)applyDefaultBorderLine {
	[self applyDefaultBorderLineWithCornerRadius:radiusCorner];
}

- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius {
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = radius;
	
	self.layer.borderWidth = 1.0;
	self.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)reframeToBeAtTheCenterOfSuperview {	FXDLog_DEFAULT;
	
	if (self.superview) {
		[self updateWithXYratio:CGPointMake(0.5, 0.5)
						forSize:self.superview.frame.size
				   forTransform:self.transform
					forDuration:0.0];
	}
}

- (void)fadeIn {
	self.alpha = 0.0;
	
	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.alpha = 1.0;
	 }];
}

- (void)fadeOut {
	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 self.alpha = 0.0;
	 }];
}

- (void)fadeInFromHidden {
	if (self.hidden == NO && self.alpha == 1.0) {
		return;
	}
	
	
	self.alpha = 0.0;
	
	if (self.hidden) {
		self.hidden = NO;
	}
	
	[UIView
	 animateWithDuration:durationQuickAnimation
	 delay:0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 self.alpha = 1.0;
	 }
	 completion:nil];
}

- (void)fadeOutThenHidden {

	if (self.hidden) {
		return;
	}
	
	
	[UIView
	 animateWithDuration:durationQuickAnimation
	 delay:0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 self.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {
		 if (self.hidden == NO) {
			 self.hidden = YES;
		 }
		 
		 self.alpha = 1.0;
	 }];
}

- (void)addAsFadeInSubview:(UIView*)subview afterAddedBlock:(void(^)(void))afterAddedBlock {
	subview.alpha = 0.0;

	[self addSubview:subview];
	[self bringSubviewToFront:subview];

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 subview.alpha = 1.0;
	 }
	 completion:^(BOOL didFinish) {
		 
		 if (afterAddedBlock) {
			 afterAddedBlock();
		 }
	 }];
}

- (void)removeAsFadeOutSubview:(UIView*)subview afterRemovedBlock:(void(^)(void))afterRemovedBlock {

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 subview.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {
		 [subview removeFromSuperview];
		 
		 if (afterRemovedBlock) {
			 afterRemovedBlock();
		 }
	 }];
}

#pragma mark -
- (UIImage*)renderedImageForScreenScale {
	return [self renderedImageForScale:[UIScreen mainScreen].scale afterScreenUpdates:YES];
}

- (UIImage*)renderedImageForScale:(CGFloat)scale afterScreenUpdates:(BOOL)afterScreenUpdates {

	UIImage *renderedImage = nil;

	UIGraphicsBeginImageContextWithOptions(self.bounds.size,
										   NO,	//MARK: to allow transparency
										   scale);

	if ([self.layer respondsToSelector:@selector(renderInContext:)]) {
		[self.layer performSelector:@selector(renderInContext:) withObject:(__bridge id)UIGraphicsGetCurrentContext()];
	}
	else {
		BOOL didDraw = [self drawViewHierarchyInRect:self.bounds
								  afterScreenUpdates:afterScreenUpdates];

		if (didDraw == NO) {	FXDLog_DEFAULT;
			FXDLogBOOL(didDraw);
		}
	}

	renderedImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

    return renderedImage;
}

#pragma mark -
- (id)superViewOfClassName:(NSString*)className {
	id superView = nil;

	if (self.superview) {
		if ([self.superview isKindOfClass:NSClassFromString(className)]) {
			superView = self.superview;
		}
		else {
			superView = [self.superview superViewOfClassName:className];
		}
	}

	return superView;

}

#pragma mark -
- (void)blinkShadowOpacity {
	CABasicAnimation *blinkShadow = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
	blinkShadow.fromValue = [NSNumber numberWithFloat:self.layer.shadowOpacity];
	blinkShadow.toValue = [NSNumber numberWithFloat:0.0];
	blinkShadow.duration = durationAnimation;
	blinkShadow.autoreverses = YES;
	[self.layer addAnimation:blinkShadow forKey:@"shadowOpacity"];
}

#pragma mark -
- (void)updateFromPortraitCornerType:(BOX_CORNER_TYPE)portraitCornerType forSize:(CGSize)size forDuration:(NSTimeInterval)duration {

	if (size.width < size.height) {
		[self updateWithBoxCornerType:portraitCornerType
							  forSize:size
						  forDuration:duration];
		return;
	}


	BOX_CORNER_TYPE landscapeCornerType;

	switch (portraitCornerType) {
		case boxCornerTopLeft:
			landscapeCornerType = boxCornerBottomLeft;
			break;

		case boxCornerBottomLeft:
			landscapeCornerType = boxCornerBottomRight;
			break;

		case boxCornerBottomRight:
			landscapeCornerType = boxCornerTopRight;
			break;

		case boxCornerTopRight:
			landscapeCornerType = boxCornerTopLeft;
			break;

		default:
			break;
	}

	[self updateWithBoxCornerType:landscapeCornerType
						  forSize:size
					  forDuration:duration];
}

- (void)updateWithBoxCornerType:(BOX_CORNER_TYPE)boxCornerType forSize:(CGSize)size forDuration:(NSTimeInterval)duration {

	CGPoint xyRatio = CGPointZero;

	switch (boxCornerType) {
		case boxCornerTopLeft:
			break;

		case boxCornerBottomLeft:
			xyRatio.y = 1.0;
			break;

		case boxCornerBottomRight:
			xyRatio.x = 1.0;
			xyRatio.y = 1.0;
			break;

		case boxCornerTopRight:
			xyRatio.x = 1.0;
			break;

		default:
			break;
	}

	[self updateWithXYratio:xyRatio
					forSize:size
			   forTransform:self.transform
				forDuration:duration];
}

#pragma mark -
- (void)updateWithXYratio:(CGPoint)xyRatio forSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration {

	if ([self constraints].count > 0) {	FXDLog_DEFAULT;
		FXDLogObject([self constraints]);
		return;
	}


	CGRect animatedFrame = self.bounds;
	animatedFrame.origin.x = (size.width-self.bounds.size.width)*xyRatio.x;
	animatedFrame.origin.y = (size.height-self.bounds.size.height)*xyRatio.y;

	[UIView
	 animateWithDuration:duration
	 animations:^{
		 self.transform = transform;
		 self.frame = animatedFrame;
	 }];
}

#pragma mark -
- (void)updateForClippedDimension:(CGFloat)clippedDimension forSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation {

	CGSize clippedSize = CGSizeZero;

	clippedSize.width = (size.width < size.height) ? size.width:clippedDimension;
	clippedSize.height = (size.width < size.height) ? clippedDimension:size.height;

	[self updateForSize:clippedSize forDuration:duration withRotation:withRotation];
}

- (void)updateForSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation {

	if ([self constraints].count > 0) {	FXDLog_DEFAULT;
		FXDLogObject([self constraints]);
		return;
	}


	CGAffineTransform animatedTransform = CGAffineTransformIdentity;
	CGRect animatedFrame = self.bounds;

	if (size.width < size.height) {

		animatedFrame.origin.x = (size.width -self.bounds.size.width)/2.0;
		animatedFrame.origin.y = size.height -self.bounds.size.height;
	}
	else {
		animatedTransform = CGAffineTransformMakeRotation(radianAngleForDegree(withRotation));

		animatedFrame.size.width = self.bounds.size.height;
		animatedFrame.size.height = self.bounds.size.width;

		animatedFrame.origin.x = size.width -self.bounds.size.height;
		animatedFrame.origin.y = (size.height -self.bounds.size.width)/2.0;
	}

	[UIView
	 animateWithDuration:duration
	 animations:^{
		 if (withRotation > 0.0) {
			 self.transform = animatedTransform;
		 }

		 self.frame = animatedFrame;
	 }];
}

#pragma mark -
- (void)updateLayerWithAffineTransform:(CGAffineTransform)affineTransform forBounds:(CGRect)bounds {	FXDLog_DEFAULT;
	FXDLog(@"1.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.bounds), _Rect(self.layer.frame), _Rect(self.layer.bounds));

	self.layer.affineTransform = affineTransform;
	self.layer.frame = bounds;

	for (CALayer *sublayer in self.layer.sublayers) {
		FXDLog(@"1.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
		sublayer.frame = self.layer.bounds;

		FXDLog(@"2.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
	}

	[self setNeedsLayout];

	FXDLog(@"2.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.bounds), _Rect(self.layer.frame), _Rect(self.layer.bounds));
}

#pragma mark -
- (NSValue*)biggerRectValueUsing:(CGRect)rect toView:(UIView *)view {
	CGRect converted = [self convertRect:rect toView:view];

	converted.origin.x -= marginDefault;
	converted.origin.y -= marginDefault;
	converted.size.width += marginDefault*2.0;
	converted.size.height += marginDefault*2.0;

	return [NSValue valueWithCGRect:converted];
}

@end