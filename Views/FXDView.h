//
//  FXDView.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDView : UIView {
    // Primitives
	
	// Instance variables
}

// Properties

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIView (Added)
+ (id)viewFromNibName:(NSString*)nibName;
+ (id)viewFromNib:(UINib*)nib;

+ (id)viewFromNibName:(NSString*)nibName withOwner:(id)ownerOrNil;
+ (id)viewFromNib:(UINib*)nib withOwner:(id)ownerOrNil;

- (void)applyDefaultBorderLine;
- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius;
- (void)reframeToBeAtTheCenterOfSuperview;

- (void)fadeIn;
- (void)fadeOut;

- (void)fadeInFromHidden;
- (void)fadeOutThenHidden;

- (void)addAsFadeInSubview:(UIView*)subview afterAddedBlock:(void(^)(void))afterAddedBlock;
- (void)removeAsFadeOutSubview:(UIView*)subview afterRemovedBlock:(void(^)(void))afterRemovedBlock;

- (UIImage*)renderedImageForScale:(CGFloat)scale;

- (id)parentViewOfClassName:(NSString*)className;


@end
