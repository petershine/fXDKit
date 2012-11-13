//
//  FXDCollectionViewCell.m
//
//
//  Created by petershine on 10/1/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#import "FXDCollectionViewCell.h"


#pragma mark - Public implementation
@implementation FXDCollectionViewCell


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties

	// IBOutlets
}


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


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
