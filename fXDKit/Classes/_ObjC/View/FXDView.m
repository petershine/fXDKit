

#import "FXDView.h"


@implementation FXDpassthroughView
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *hitView = [super hitTest:point withEvent:event];

	if (_hitTestCallback) {
		hitView = _hitTestCallback(hitView, point, event);
	}

	return hitView;
}
@end


@implementation FXDsubviewGlowing
- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}

	return self;
}

- (instancetype _Nullable )initWithFrame:(CGRect)frame withGlowingColor:(nullable UIColor*)glowingColor {
	self = [self initWithFrame:frame];

	if (self) {
		self.glowingColor = glowingColor;
	}

	return self;
}

#pragma mark -
- (void)drawRect:(CGRect)rect {
	//[super drawRect:rect];

	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();

	//// Color Declarations
	//UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
	UIColor* fillColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
	UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];

	if (self.glowingColor) {
		fillColor = self.glowingColor;
		strokeColor = self.glowingColor;
	}


	//// Shadow Declarations
	UIColor* shadow = fillColor;
	CGSize shadowOffset = CGSizeMake(0.1, -0.1);
	CGFloat shadowBlurRadius = 10;

	//// Rectangle Drawing
	UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rect];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[[UIColor clearColor] setFill];
	[rectanglePath fill];

	////// Rectangle Inner Shadow
	CGRect rectangleBorderRect = CGRectInset(rectanglePath.bounds, -shadowBlurRadius, -shadowBlurRadius);
	rectangleBorderRect = CGRectOffset(rectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
	rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, rectanglePath.bounds), -1, -1);

	UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
	[rectangleNegativePath appendPath: rectanglePath];
	rectangleNegativePath.usesEvenOddFillRule = YES;

	CGContextSaveGState(context);
	{
		CGFloat xOffset = shadowOffset.width + round(rectangleBorderRect.size.width);
		CGFloat yOffset = shadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									shadowBlurRadius,
									shadow.CGColor);

		[rectanglePath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
		[rectangleNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[rectangleNegativePath fill];
	}
	CGContextRestoreGState(context);

	CGContextRestoreGState(context);

	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	rectanglePath.lineWidth = 1;
	[rectanglePath stroke];
	CGContextRestoreGState(context);
}
@end


@implementation UIView (Essential)
+ (instancetype _Nullable )viewFromNibName:(NSString*_Nullable)nibName {
	UIView *view = [self viewFromNibName:nibName withOwner:nil];
	
	return view;
}

+ (instancetype _Nullable )viewFromNib:(UINib*_Nullable)nib {
	UIView *view = [self viewFromNib:nib withOwner:nil];
	
	return view;
}

+ (instancetype _Nullable )viewFromNibName:(NSString*_Nullable)nibName withOwner:(id _Nullable )ownerOrNil {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}

	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];

	UIView *view = [self viewFromNib:nib withOwner:ownerOrNil];

	return view;
}

+ (instancetype _Nullable )viewFromNib:(UINib*_Nullable)nib withOwner:(id _Nullable )ownerOrNil {
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

#pragma mark -
- (void)fadeInFromHidden {
	if (self.hidden == NO && self.alpha == 1.0) {
		return;
	}
	
	
	self.alpha = 0.0;
	
	if (self.hidden) {
		self.hidden = NO;
	}
	
	[UIView
	 animateWithDuration:durationAnimation
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


	CGFloat previousAlpha = self.alpha;
	
	[UIView
	 animateWithDuration:durationAnimation
	 delay:0
	 options:UIViewAnimationOptionCurveEaseOut
	 animations:^{
		 self.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {
		 self.hidden = YES;
		 self.alpha = previousAlpha ;
	 }];
}

#pragma mark -
- (void)addAsFadeInSubview:(UIView*_Nullable)subview afterAddedBlock:(void(^_Nullable)(void))afterAddedBlock {
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

- (void)removeAsFadeOutSubview:(UIView*_Nullable)subview afterRemovedBlock:(void(^_Nullable)(void))afterRemovedBlock {

	[UIView
	 animateWithDuration:durationAnimation
	 animations:^{
		 subview.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {
		 [subview removeFromSuperview];
		 subview.alpha = 1.0;
		 
		 if (afterRemovedBlock) {
			 afterRemovedBlock();
		 }
	 }];
}

#pragma mark -
- (UIImage*)renderedImageForScreenScale {
	return [self renderedImageForScale:[UIScreen mainScreen].scale afterScreenUpdates:YES];
}

- (UIImage*_Nullable)renderedImageForScale:(CGFloat)scale afterScreenUpdates:(BOOL)afterScreenUpdates {	//FXDLog_DEFAULT;

	UIImage *renderedImage = nil;

	UIGraphicsBeginImageContextWithOptions(self.bounds.size,
										   NO,	//MARK: to allow transparency
										   scale);

	//FXDLogObject(self.window);

	//FXDLogBOOL([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]);
	//FXDLogBOOL([self.layer respondsToSelector:@selector(renderInContext:)]);

	if (self.window
		&& [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		
		BOOL didDraw = [self drawViewHierarchyInRect:self.bounds
								  afterScreenUpdates:afterScreenUpdates];

		if (didDraw == NO) {	FXDLog_DEFAULT;
			FXDLogBOOL(didDraw);
		}
	}
	else if ([self.layer respondsToSelector:@selector(renderInContext:)]) {
		[self.layer performSelector:@selector(renderInContext:) withObject:(__bridge id)UIGraphicsGetCurrentContext()];
	}

	renderedImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

    return renderedImage;
}

#pragma mark -
- (id _Nullable )superViewOfClassName:(NSString*_Nullable)className {
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
- (void)updateWithXYratio:(CGPoint)xyRatio forSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration {

	CGRect animatedFrame = CGRectApplyAffineTransform(self.bounds, transform);

	if (self.constraints.count > 0) {	//FXDLog_DEFAULT;
		//FXDLogObject([self constraints]);

		//TEST: Make sure this works OK with other apps
		//return;
		NSAssert1(CGAffineTransformIsIdentity(transform), @"%@", _Transform(transform));

		transform = CGAffineTransformIdentity;
		animatedFrame = self.frame;
	}


	animatedFrame.origin.x = (size.width-animatedFrame.size.width)*xyRatio.x;
	animatedFrame.origin.y = (size.height-animatedFrame.size.height)*xyRatio.y;

	[UIView
	 animateWithDuration:duration
	 animations:^{
		 self.transform = transform;
		 self.frame = animatedFrame;

	 } completion:nil];
}

#pragma mark -
- (void)updateForClippedDimension:(CGFloat)clippedDimension forSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation {

	CGSize clippedSize = CGSizeZero;

	clippedSize.width = (size.width < size.height) ? size.width:clippedDimension;
	clippedSize.height = (size.width < size.height) ? clippedDimension:size.height;

	[self updateForSize:clippedSize forDuration:duration withRotation:withRotation];
}

- (void)updateForSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation {

	if (self.constraints.count > 0) {	FXDLog_DEFAULT;
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
- (NSValue*_Nullable)biggerRectValueUsing:(CGRect)rect toView:(UIView *_Nullable)view {
	CGRect converted = [self convertRect:rect toView:view];

	converted.origin.x -= marginDefault;
	converted.origin.y -= marginDefault;
	converted.size.width += marginDefault*2.0;
	converted.size.height += marginDefault*2.0;

	return [NSValue valueWithCGRect:converted];
}

#pragma mark -
- (void)fadeInAlertLabelWithText:(NSString*_Nullable)alertText fadeOutAfterDelay:(NSTimeInterval)delay {

	CGRect labelFrame = CGRectMake(0, 0, MIN(self.frame.size.width, self.frame.size.height), heightNavigationBar*2.0);

	UILabel *alertLabel = [[UILabel alloc] initWithFrame:labelFrame];
	alertLabel.numberOfLines = 0;
	alertLabel.text = alertText;

	alertLabel.font = [UIFont boldSystemFontOfSize:20.0];

	//alertLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValue08];
	[alertLabel applyShadowColor:[UIColor blackColor]];
	
	alertLabel.textColor = [UIColor whiteColor];
	alertLabel.textAlignment = NSTextAlignmentCenter;

	alertLabel.autoresizingMask = UIViewAutoresizingKeepCenter;

	alertLabel.userInteractionEnabled = NO;


	//MARK: Assume center of the screen is where label should be
	UIDeviceOrientation deviceOrientation = [UIDevice validDeviceOrientation];

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:deviceOrientation];

	labelFrame.origin.x = (screenBounds.size.width -labelFrame.size.width)/2.0;
	labelFrame.origin.y = (screenBounds.size.height -labelFrame.size.height)/2.0;
	alertLabel.frame = labelFrame;


	alertLabel.alpha = 0.0;

	[self addSubview:alertLabel];


	[UIView
	 animateWithDuration:durationSlowAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseInOut
	 animations:^{
		 alertLabel.alpha = 1.0;
	 }
	 completion:^(BOOL finished) {

		 [UIView
		  animateWithDuration:durationSlowAnimation
		  delay:delay
		  options:UIViewAnimationOptionCurveEaseInOut
		  animations:^{
			  alertLabel.alpha = 0.0;

		  }
		  completion:^(BOOL finished) {
			  [alertLabel removeFromSuperview];
		  }];
	 }];
}

#pragma mark -
- (void)modifyToCircular {
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = self.bounds.size.width/2.0;
}

@end


@implementation UIView (MotionEffect)
- (void)enableParallaxEffectWithRelativeValue:(CGFloat)relativeValue {

	UIInterpolatingMotionEffect *verticalMotionEffect =	[[UIInterpolatingMotionEffect alloc]
														 initWithKeyPath:@"center.y"
														 type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffect.minimumRelativeValue = @(0.0-relativeValue);
	verticalMotionEffect.maximumRelativeValue = @(relativeValue);

	// Set horizontal effect
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc]
														   initWithKeyPath:@"center.x"
														   type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(0.0-relativeValue);
	horizontalMotionEffect.maximumRelativeValue = @(relativeValue);

	// Create group to combine both
	UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
	group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

	// Add both effects to your view
	[self addMotionEffect:group];
}
@end


@implementation UIView (Glowing)
- (void)addGlowingSubview:(FXDsubviewGlowing*)glowingSubview {

	if (glowingSubview == nil) {
		glowingSubview = [[FXDsubviewGlowing alloc]
						  initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
						  withGlowingColor:nil];
	}

	glowingSubview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	glowingSubview.userInteractionEnabled = NO;

	[self addSubview:glowingSubview];
}
@end

