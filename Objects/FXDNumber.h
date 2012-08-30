//
//  FXDNumber.h
//
//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"


@interface FXDNumber : NSNumber {
    // Primitives

	// Instance variables

	// Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSNumber (Added)
- (NSString*)byteUnitFormatted;

@end
