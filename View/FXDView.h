
#import "FXDKit.h"


@interface FXDView : UIView
@end


@interface UIView (Essential)
+ (instancetype)viewFromNibName:(NSString*)nibName;
+ (instancetype)viewFromNib:(UINib*)nib;

+ (instancetype)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil;
+ (instancetype)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil;


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


- (NSValue*)biggerRectValueUsing:(CGRect)rect toView:(UIView *)view;


- (void)fadeInAlertLabelWithText:(NSString*)alertText fadeOutAfterDelay:(NSTimeInterval)delay;

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
