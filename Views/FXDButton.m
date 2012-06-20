//
//  FXDButton.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDButton.h"


#pragma mark - Private interface
@interface FXDButton (Private)
@end


#pragma mark - Public implementation
@implementation FXDButton


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
	// Instance variables
	
	// Properties	
	_addedObj = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
