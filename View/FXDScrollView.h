
#import "FXDKit.h"


@interface UIScrollView (Essential)
- (void)configureZoomValueForImageView:(UIImageView*)imageView forSize:(CGSize)size shouldAnimate:(BOOL)shouldAnimate;

- (void)configureContentInsetForSubview:(UIView*)subview forSize:(CGSize)size;
- (void)configureContentInsetForClippingFrame:(CGRect)overlayRect;

- (void)configureContentSizeForSubview:(UIView*)subview;

- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset;

- (void)scrollToCenterToShowSubView:(UIView*)subView shouldAnimate:(BOOL)shouldAnimate;

- (BOOL)isScrollingCurrently;
- (BOOL)isScrolledByUser;

- (CGFloat)horizontalProgress;

- (CGPoint)snappedOffsetFromContentOffset:(CGPoint)contentOffset withMinimumOffset:(CGPoint)minimumOffset shouldUpdate:(BOOL)shouldUpdate;

@end
