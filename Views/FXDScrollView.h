//
//  FXDScrollView.h
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDScrollView : UIScrollView

// Properties

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIScrollView (Added)
- (void)configureZoomValueForImageView:(UIImageView*)imageView shouldAnimate:(BOOL)shouldAnimate;

- (void)configureContentInsetForSubview:(UIView*)subview;
- (void)configureContentInsetForClippingFrame:(CGRect)overlayRect;

- (void)configureContentSizeForSubview:(UIView*)subview;

- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset;

- (void)scrollToCenterToShowSubView:(UIView*)subView shouldAnimate:(BOOL)shouldAnimate;

- (BOOL)isScrollingCurrently;

@end
