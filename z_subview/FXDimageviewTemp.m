//
//  FXDimageviewTemp.m
//
//
//  Created by petershine on 10/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDimageviewTemp.h"


#pragma mark - Private interface
@interface FXDimageviewTemp (Private)
@end


#pragma mark - Public implementation
@implementation FXDimageviewTemp


#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties

	// IBOutlets
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];

#if USE_tempImageview
#else
	self.image = nil;
#endif

    // Primitives

    // Instance variables

    // Properties

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
