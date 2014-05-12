//
//  FXDView.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDView : UIView
@property (nonatomic) CGRect initialViewFrame;

// IBOutlets

#pragma mark - IBActions

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIView (Added)
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

- (void)updateFrameForBounds:(CGRect)bounds forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation forDuration:(NSTimeInterval)duration;
- (void)updateFrameForBounds:(CGRect)bounds withXYratio:(CGPoint)xyRatio forDuration:(NSTimeInterval)duration;

- (void)updateLayerForDeviceOrientationWithAffineTransform:(CGAffineTransform)affineTransform andWithScreenBounds:(CGRect)screenBounds;

@end
