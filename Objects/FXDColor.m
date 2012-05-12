//
//  FXDColor.m
//
//
//  Created by petershine on 2/23/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDColor.h"


#pragma mark - Private interface
@interface FXDColor (Private)
@end


#pragma mark - Public implementation
@implementation FXDColor

#pragma mark Static objects

#pragma mark Synthesizing
// Properties

// Controllers


#pragma mark - Memory management
- (void)dealloc {	
	// Instance variables
	
	// Properties
	
    // Controllers
	
	[super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties

// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue {
	return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:1.0];
}

@end
