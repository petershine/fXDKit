//
//  FXDsuperCachesManager.h
//
//
//  Created by petershine on 8/13/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"


#define notificationCachesControlDidEnumerateCachesMetadataQueryResults	@"notificationCachesControlDidEnumerateCachesMetadataQueryResults"

#define prefixCached	@"_cached_"


@interface FXDsuperCachesManager : FXDObject <NSMetadataQueryDelegate> {
    // Primitives
	
	// Instance variables
}

// Properties
@property (strong, nonatomic) NSMetadataQuery *ubiquitousCachesMetadataQuery;


#pragma mark - Public
+ (FXDsuperCachesManager*)sharedInstance;

- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL;
- (NSURL*)itemURLforCachedURL:(NSURL*)cachedURL;

- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL;
- (NSURL*)folderURLforCachedFolderURL:(NSURL*)cachedFolderURL;

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL;

- (void)enumerateCachesMetadataQueryResults;


//MARK: - Observer implementation
- (void)observedCachesMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedCachesMetadataQueryDidUpdate:(NSNotification*)notification;

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface FXDsuperCachesManager (Added)
@end