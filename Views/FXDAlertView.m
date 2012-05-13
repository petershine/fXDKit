//
//  FXDAlertView.m
//
//
//  Created by petershine on 2/13/12.
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


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
