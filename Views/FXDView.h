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


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIView (Added)
+ (id)loadedViewUsingDefaultNIB;
+ (id)loadedViewUsingNIBname:(NSString*)nibName;
+ (id)loadedViewUsingNIBname:(NSString*)nibName forModifiedSize:(CGSize)modifiedSize;
+ (id)loadedViewUsingNIBname:(NSString*)nibName forModifiedFrame:(CGRect)modifiedFrame;

- (void)configureForAllInitializers;

- (void)reframeSelfToBeAtTheCenterOfSuperview:(UIView*)superview;

@end
