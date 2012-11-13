//
//  FXDButton.m
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDButton.h"


#pragma mark - Public implementation
@implementation FXDButton


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
		//MARK: awakeFromNib is called automatically
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
		// Primitives

		// Instance variables

		// Properties

		// IBOutlets
		[self awakeFromNib];
    }

    return self;
}

- (void)awakeFromNib {
	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	[super awakeFromNib];
	
}


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
