//
//  FXDNumber.h
//
//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDNumber : NSNumber

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface NSNumber (Added)
- (NSString*)byteUnitFormatted;
- (NSString*)timerUnitFormatted;

@end
