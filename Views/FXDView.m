//
//  FXDView.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDView.h"


#pragma mark - Public implementation
@implementation FXDView


#pragma mark - Memory management

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
	}
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	self.initialViewFrame = self.frame;
}


#pragma mark - Property overriding

#pragma mark - Method overriding
#if TEST_loggingViewDrawing
- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];

	FXDLog(@"%@ %@", _Rect(self.frame), _Rect(self.bounds));
}
#endif

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation UIView (Added)
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
		CGRect modifiedFrame = self.frame;
		modifiedFrame.origin.x = (self.superview.frame.size.width -modifiedFrame.size.width)/2.0;
		modifiedFrame.origin.y = (self.superview.frame.size.height -modifiedFrame.size.height)/2.0;
		self.frame = modifiedFrame;
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

	if (SYSTEM_VERSION_lowerThan(iosVersion7)) {
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	else {
		BOOL didDraw = [self
						drawViewHierarchyInRect:self.bounds
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
- (void)configureForBounds:(CGRect)bounds forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation shouldAnimate:(BOOL)shouldAnimate forDuration:(NSTimeInterval)duration {	FXDLog_OVERRIDE;

}

#pragma mark -
- (void)updateLayerForDeviceOrientationWithAffineTransform:(CGAffineTransform)affineTransform andWithScreenBounds:(CGRect)screenBounds {	FXDLog_DEFAULT;
	FXDLog(@"1.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.bounds), _Rect(self.layer.frame), _Rect(self.layer.bounds));

	self.layer.affineTransform = affineTransform;
	self.layer.frame = screenBounds;

	for (CALayer *sublayer in self.layer.sublayers) {
		FXDLog(@"1.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
		sublayer.frame = sublayer.superlayer.bounds;

		FXDLog(@"2.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
	}

	[self setNeedsLayout];

	FXDLog(@"2.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.bounds), _Rect(self.layer.frame), _Rect(self.layer.bounds));
}

@end