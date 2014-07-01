//
//  FXDNumber.h
//
//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDNumber : NSNumber
@end


@interface NSNumber (Essential)
- (NSString*)byteUnitFormatted;
- (NSString*)timerUnitFormatted;

@end
