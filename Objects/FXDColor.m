//
//  FXDColor.m
//
//
//  Created by petershine on 2/23/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDColor.h"


#pragma mark - Public implementation
@implementation FXDColor


#pragma mark - Memory management


#pragma mark - Initialization


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue {
	return [self colorUsingIntegersForRed:red forGreen:green forBlue:blue forAlpha:1];
}

+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha {
	return [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:alpha];
}

+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha {
	return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

@end
