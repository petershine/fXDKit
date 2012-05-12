//
//  FXDAlertView.m
//
//
//  Created by Anonymous on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAlertView.h"


#pragma mark - Private interface
@interface FXDAlertView (Private)
@end


#pragma mark - Public implementation
@implementation FXDAlertView


#pragma mark Synthesizing
// Properties
@synthesize addedObj = _addedObj;

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {	
	// Instance variables
	
	// Properties
	[_addedObj release];
	
	// IBOutlets
	
	[super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
        [self configureForAllInitializers];
    }
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self configureForAllInitializers];
    }
	
    return self;
}

- (void)configureForAllInitializers {	
    // Primitives
	
    // Instance variables
	
    // Properties
	_addedObj = nil;
	
    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {
	[super layoutSubviews];
	
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
