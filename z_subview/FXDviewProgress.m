//
//  FXDviewProgress.m
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDviewProgress.h"


#pragma mark - Private interface
@interface FXDviewProgress (Private)
@end


#pragma mark - Public implementation
@implementation FXDviewProgress


#pragma mark Synthesizing
// Properties

// IBOutlets
@synthesize activitywheelProgress;
@synthesize labelAboveActivityWheel, labelBelowActivityWheel;


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	[activitywheelProgress release];
	
	[labelAboveActivityWheel release];
	[labelBelowActivityWheel release];
	
	// IBOutlets
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
        // Primitives
		
		// Instance variables
		
		// Properties
		
		// IBOutlets
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
    }
	
    return self;
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
