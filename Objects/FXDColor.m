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


#pragma mark - Memory management


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue {
	return [self colorUsingIntegersForRed:red forGreen:green forBlue:blue forAlpha:1];
}

+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(float)alpha {
	return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:alpha];
}

@end
