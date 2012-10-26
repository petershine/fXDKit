//
//  FXDView.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"


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

- (void)addAsFadeInSubview:(UIView*)subview;
- (void)removeAsFadeOutSubview:(UIView*)subview afterRemoved:(void(^)(void))afterRemoved;

- (UIImage*)renderedImageFromView:(UIView*)view;

- (id)parentViewOfClassName:(NSString*)className;


@end
