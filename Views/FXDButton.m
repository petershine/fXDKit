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

#pragma mark -
- (void)configureForAllInitializers {
	// Primitives
	
	// Instance variables
	
	// Properties	
	_addedObj = nil;
	
	// IBOutlets
}

#pragma mark -
- (void)awakeFromNib {
	[super awakeFromNib];
}


#pragma mark - Accessor overriding


#pragma mark - Drawing
- (void)layoutSubviews {
	[super layoutSubviews];

}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
