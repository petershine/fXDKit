//
//  FXDsuperCachesManager.h
//
//
//  Created by petershine on 8/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationCachesControlDidEnumerateCachesMetadataQueryResults	@"notificationCachesControlDidEnumerateCachesMetadataQueryResults"

#define prefixCached	@"_cached_"


#import "FXDsuperModule.h"
@interface FXDsuperCachesManager : FXDsuperModule <NSMetadataQueryDelegate>

@property (strong, nonatomic) NSMetadataQuery *ubiquitousCachesMetadataQuery;


#pragma mark - Public
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
