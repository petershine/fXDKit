//
//  FXDFileManager.h
///
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"


@interface FXDFileManager : NSFileManager {
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
@interface NSFileManager (Added)
- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL;
- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL;

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL;

@end
