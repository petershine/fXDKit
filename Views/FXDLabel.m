//
//  ENALabel.m
//
//
//  Created by petershine on 10/30/11.
//  Copyright (c) 2011 Ensight. All rights reserved.
//

#import "FXDLabel.h"


#pragma mark - Private interface
@interface FXDLabel (Private)
@end


#pragma mark - Public implementation
@implementation FXDLabel


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
	// IBOutlets
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		[self configureForAllInitializers];
	}
	
	return self;
}

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


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Delegate implementation


@end
