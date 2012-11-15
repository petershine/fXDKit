//
//  FXDimageviewTemp.m
//
//
//  Created by petershine on 10/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDimageviewTemp.h"


#pragma mark - Public implementation
@implementation FXDimageviewTemp


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties

	// IBOutlets
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets

#if USE_tempImageview
#else
	self.image = nil;
#endif
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
