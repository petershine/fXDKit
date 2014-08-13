
#import "FXDKit.h"


typedef UIView* (^FXDblockHitTest)(UIView *testedView, CGPoint point, UIEvent *event);


@interface FXDView : UIView {
	FXDblockHitTest _hitTestBlock;
}

@property (copy, nonatomic) FXDblockHitTest hitTestBlock;

@end


@interface UIView (Essential)
+ (instancetype)viewFromNibName:(NSString*)nibName;
+ (instancetype)viewFromNib:(UINib*)nib;

+ (instancetype)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil;
+ (instancetype)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil;

- (void)applyDefaultBorderLine;
- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius;
- (void)reframeToBeAtTheCenterOfSuperview;

- (void)fadeIn;
- (void)fadeOut;

- (void)fadeInFromHidden;
- (void)fadeOutThenHidden;

- (void)addAsFadeInSubview:(UIView*)subview afterAddedBlock:(void(^)(void))afterAddedBlock;
- (void)removeAsFadeOutSubview:(UIView*)subview afterRemovedBlock:(void(^)(void))afterRemovedBlock;

- (UIImage*)renderedImageForScreenScale;
- (UIImage*)renderedImageForScale:(CGFloat)scale afterScreenUpdates:(BOOL)afterScreenUpdates;

- (id)superViewOfClassName:(NSString*)className;

- (void)blinkShadowOpacity;


- (void)updateWithXYratio:(CGPoint)xyRatio forSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (void)updateForClippedDimension:(CGFloat)clippedDimension forSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation;
- (void)updateForSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation;

- (void)updateLayerWithAffineTransform:(CGAffineTransform)affineTransform forBounds:(CGRect)screenBounds;

- (NSValue*)biggerRectValueUsing:(CGRect)rect toView:(UIView *)view;

@end


@interface UIView (MotionEffect)
- (void)enableParallaxEffectWithRelativeValue:(CGFloat)relativeValue;
@end


@interface FXDsubviewGlowing : FXDView
@property (strong, nonatomic) UIColor *glowingColor;
- (instancetype)initWithFrame:(CGRect)frame withGlowingColor:(UIColor*)glowingColor;
@end

@interface UIView (Glowing)
- (void)addGlowingSubview:(FXDsubviewGlowing*)glowingSubview;
@end
