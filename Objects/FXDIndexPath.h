//
//  FXDIndexPath.h
//
//
//  Created by petershine on 12/28/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#define NSIndexPathMake(section, row)	[NSIndexPath indexPathForRow:row inSection:section]
#define NSIndexPathString(section, row)	[NSIndexPathMake(section, row) stringValue]


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