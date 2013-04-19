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
- (void)configureContentInsetForOverlayRect:(CGRect)overlayRect;
- (void)configureContentSizeForSubView:(UIView*)subView;
- (void)reframeSubView:(UIView*)subView shouldModifyOffset:(BOOL)shouldModifyOffset;
- (void)scrollToCenterToShowSubView:(UIView*)subView withAnimation:(BOOL)withAnimation;

- (BOOL)isScrollingCurrently;

@end
