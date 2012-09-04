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
	
	// Properties : For accessor overriding
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
+ (id)viewFromNibName:(NSString*)nibName forModifiedFrame:(CGRect)modifiedFrame;
+ (id)viewFromNib:(UINib*)nib;

- (void)applyDefaultBorderLine;
- (void)applyDefaultBorderLineWithCornerRadius:(CGFloat)radius;
- (void)reframeToBeAtTheCenterOfSuperview;

- (void)fadeIn;
- (void)fadeOut;

- (void)fadeInFromHidden;
- (void)fadeOutThenHidden;

- (void)addAsFadeInSubview:(UIView*)subview;
- (void)removeAsFadeOutSubview:(UIView*)subview afterRemoved:(void(^)(void))afterRemoved;


@end
