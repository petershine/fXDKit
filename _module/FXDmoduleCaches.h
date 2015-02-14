
#import "FXDimportCore.h"


#define prefixCached	@"_cached_"


#import "FXDmoduleQuery.h"
@interface FXDmoduleCaches : FXDmoduleQuery


- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL;
- (NSURL*)itemURLforCachedURL:(NSURL*)cachedURL;

- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL;
- (NSURL*)folderURLforCachedFolderURL:(NSURL*)cachedFolderURL;

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL;

- (void)enumerateMetadataQueryResultsWithCallback:(FXDcallbackFinish)callback;

@end
