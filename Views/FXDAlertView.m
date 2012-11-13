//
//  FXDAlertView.m
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAlertView.h"


#pragma mark - Public implementation
@implementation FXDAlertView


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


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIAlertView (Added)
@end
