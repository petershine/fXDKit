//
//  FXDIndexPath.h
//
//
//  Created by petershine on 12/28/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//


@interface FXDIndexPath : NSIndexPath

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface NSIndexPath (Added)
- (NSString*)stringValue;

@end