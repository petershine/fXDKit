//
//  FXDFileManager.h
//
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDFileManager : NSFileManager
@end


@interface NSFileManager (Added)
- (void)clearTempDirectory;

- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL;
- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL;

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL;

- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atFolderURL:(NSURL*)folderURL;
- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destionationURL withResultError:(NSError*)error;


@end
