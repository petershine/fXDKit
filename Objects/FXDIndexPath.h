//
//  FXDIndexPath.h
//
//
//  Created by petershine on 12/28/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#define NSIndexPathString(section, row)	[[NSIndexPath indexPathForRow:row inSection:section] stringValue]


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