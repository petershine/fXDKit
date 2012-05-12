//
//  FXDView.m
//
//
//  Created by Anonymous on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDView.h"


#pragma mark - Private interface
@interface FXDView (Private)
@end


#pragma mark - Public implementation
@implementation FXDView


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
    FXDLog_DEFAULT;[super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {	FXDLog_DEFAULT;
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self configureForAllInitializers];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];
	
    if (self) {
		[self configureForAllInitializers];
	}
	
    return self;
}

#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {	FXDLog_DEFAULT;
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIView (Added)
+ (id)loadedViewUsingDefaultNIB {
	id loadedView = nil;
	
	NSString *nibName = NSStringFromClass([self class]);
	
	loadedView = [self loadedViewUsingNIBname:nibName];
	
	return loadedView;
}

+ (id)loadedViewUsingNIBname:(NSString*)nibName {
	if (nibName == nil) {
		nibName = NSStringFromClass([self class]);
	}
	
	id loadedView = nil;
	
	NSArray *loadedViewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	
	if (loadedViewArray) {	
		for (id subview in loadedViewArray) {	//Assumes there is only one root object
			
			if ([NSStringFromClass([subview class]) isEqualToString:nibName]) {
				loadedView = subview;
			}
			else {
				FXDLog(@"subview class: %@", [subview class]);
			}
		}
	}
	
	return loadedView;
}

+ (id)loadedViewUsingNIBname:(NSString*)nibName forModifiedSize:(CGSize)modifiedSize {
	id loadedView = [self loadedViewUsingNIBname:nibName];
	
	CGRect modifiedFrame = [(UIView*)loadedView frame];
	modifiedFrame.size = modifiedSize;
	[(UIView*)loadedView setFrame:modifiedFrame];
	
	return loadedView;
}

+ (id)loadedViewUsingNIBname:(NSString*)nibName forModifiedFrame:(CGRect)modifiedFrame {
	id loadedView = [self loadedViewUsingNIBname:nibName];
	
	[(UIView*)loadedView setFrame:modifiedFrame];
	
	return loadedView;
}

#pragma mark -
- (void)configureForAllInitializers {	//FXDLog_DEFAULT;
	// Primitives
	
	// Instance variables
	
	// Properties
	
	// IBOutlets
}

- (void)reframeSelfToBeAtTheCenterOfSuperview:(UIView*)superview {	FXDLog_DEFAULT;
	if (superview == nil) {
		superview = self.superview;
	}
	
	CGRect modifiedFrame = self.frame;
	modifiedFrame.origin.x = (superview.frame.size.width -modifiedFrame.size.width)/2.0;
	modifiedFrame.origin.y = (superview.frame.size.height -modifiedFrame.size.height)/2.0;
	
	[self setFrame:modifiedFrame];
}


@end