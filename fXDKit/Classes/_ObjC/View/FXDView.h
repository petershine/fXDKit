
#import "FXDimportEssential.h"

#define UIViewAutoresizingKeepCenter	(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin)

typedef UIView* _Nullable (^FXDcallbackHitTest)(UIView * _Nullable hitView, CGPoint point, UIEvent * _Nullable event);


@interface FXDsubviewGlowing : UIView
@property (strong, nonatomic, nullable) UIColor *glowingColor;
- (instancetype _Nullable )initWithFrame:(CGRect)frame withGlowingColor:(nullable UIColor*)glowingColor;
@end


@interface UIView (Essential)
+ (instancetype _Nullable )viewFromNibName:(NSString*_Nullable)nibName;
+ (instancetype _Nullable )viewFromNib:(UINib*_Nullable)nib;

+ (instancetype _Nullable )viewFromNibName:(NSString*_Nullable)nibName withOwner:(id _Nullable )ownerOrNil;
+ (instancetype _Nullable )viewFromNib:(UINib*_Nullable)nib withOwner:(id _Nullable )ownerOrNil;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage * _Nullable renderedImageForScreenScale;
- (UIImage*_Nullable)renderedImageForScale:(CGFloat)scale afterScreenUpdates:(BOOL)afterScreenUpdates;

- (id _Nullable )superViewOfClassName:(NSString*_Nullable)className;


- (void)updateWithXYratio:(CGPoint)xyRatio forSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (void)updateForClippedDimension:(CGFloat)clippedDimension forSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation;
- (void)updateForSize:(CGSize)size forDuration:(NSTimeInterval)duration withRotation:(CGFloat)withRotation;


- (NSValue*_Nullable)biggerRectValueUsing:(CGRect)rect toView:(UIView *_Nullable)view;


- (void)fadeInAlertLabelWithText:(NSString*_Nullable)alertText fadeOutAfterDelay:(NSTimeInterval)delay;

@end


@interface UIView (MotionEffect)
- (void)enableParallaxEffectWithRelativeValue:(CGFloat)relativeValue;
@end


@interface UIView (Glowing)
- (void)addGlowingSubview:(FXDsubviewGlowing*_Nullable)glowingSubview;
@end

