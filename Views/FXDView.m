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
	id view = [self viewFromNibName:nibName withOwner:nil];
	
	return view;
}

+ (instancetype)viewFromNib:(UINib*)nib {
	
	id view = [self viewFromNib:nib withOwner:nil];
	
	return view;
}

+ (instancetype)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}

	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];

	id view = [self viewFromNib:nib withOwner:ownerOrNil];

	return view;
}

+ (instancetype)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil {
	if (nib == nil) {
		NSString *nibName = NSStringFromClass([self class]);

		nib = [UINib nibWithNibName:nibName bundle:nil];
	}

	id view = nil;

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
		
		[self setFrame:modifiedFrame];
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
	 completion:^(BOOL finished) {
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
	 completion:^(BOOL finished) {
		 
		 if (afterAddedBlock) {
			 afterAddedBlock();
		 }
	 }];
}

- (void)removeAsFadeOutSubview:(UIView*)subview afterRemovedBlock:(void(^)(void))afterRemovedBlock {	//FXDLog_DEFAULT;

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 subview.alpha = 0.0;
	 }
	 completion:^(BOOL finished) {
		 [subview removeFromSuperview];
		 
		 if (afterRemovedBlock) {
			 afterRemovedBlock();
		 }
	 }];
}

#pragma mark -
- (UIImage*)renderedImageForScreenScale {
	return [self renderedImageForScale:[UIScreen mainScreen].scale];
}

- (UIImage*)renderedImageForScale:(CGFloat)scale {

	UIImage *image = nil;

	UIGraphicsBeginImageContextWithOptions(self.bounds.size,
										   NO,	//MARK: to allow transparency
										   scale);
	{
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();

    return image;
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
#if USE_MultimediaFrameworks
- (void)updateLayerForDeviceOrientation {
	CGAffineTransform affineTransform = [[UIDevice currentDevice] affineTransformForOrientation];
	CGRect screenFrame = [[UIDevice currentDevice] screenFrameForOrientation];

	[self updateLayerForDeviceOrientationWithAffineTransform:affineTransform andWithScreenFrame:screenFrame];
}
#endif

- (void)updateLayerForDeviceOrientationWithAffineTransform:(CGAffineTransform)affineTransform andWithScreenFrame:(CGRect)screenFrame {
#if TEST_loggingRotatingOrientation
	FXDLog_DEFAULT;
	FXDLog(@"1.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.layer.frame), _Rect(self.bounds), _Rect(self.layer.bounds));
#endif

	[self.layer setAffineTransform:affineTransform];
	[self.layer setFrame:screenFrame];

	for (CALayer *sublayer in self.layer.sublayers) {
#if TEST_loggingRotatingOrientation
		FXDLog(@"1.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
#endif
		[sublayer setFrame:sublayer.superlayer.bounds];

#if TEST_loggingRotatingOrientation
		FXDLog(@"2.%@ %@", _Rect(sublayer.frame), _Rect(sublayer.bounds));
#endif
	}

	[self setNeedsLayout];

#if TEST_loggingRotatingOrientation
	FXDLog(@"2.%@ %@ %@ %@", _Rect(self.frame), _Rect(self.layer.frame), _Rect(self.bounds), _Rect(self.layer.bounds));
#endif
}

@end