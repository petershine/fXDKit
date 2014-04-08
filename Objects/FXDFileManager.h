//
//  FXDFileManager.h
//
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDFileManager : NSFileManager

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@interface NSFileManager (Added)
- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL;
- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL;

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL;

@end
