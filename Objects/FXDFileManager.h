//
//  FXDFileManager.h
///
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif


#define appSearhPath_Document	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define appSearhPath_Caches		[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define appDirectory_Document	[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
#define appDirectory_Caches		[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]


#import "FXDKit.h"


@interface FXDFileManager : NSFileManager {
    // Primitives
	
	// Instance variables
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
