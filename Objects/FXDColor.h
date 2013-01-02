//
//  FXDColor.h
//
//
//  Created by petershine on 2/23/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDColor : UIColor {
    // Primitives
	
	// Instance variables
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue;
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha;
+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha;	// Use 0xFF0000 type

@end
