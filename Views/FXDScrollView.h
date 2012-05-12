//
//  FXDScrollView.h
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDScrollView : UIScrollView {
    // Primitives
	
	// Instance variables
    
    // Properties : For subclass to be able to reference
}

// Properties

// IBOutlets


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Drawing


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


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

@end
