//
//  FXDError.h
//
//
//  Created by petershine on 10/8/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//


@interface FXDError : NSError
@end


#pragma mark - Category
@interface NSError (Added)
- (NSDictionary*)essentialParameters;
@end