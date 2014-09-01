
#import "FXDKit.h"


@interface NSFileManager (Essential)
- (void)clearTempDirectory;
- (void)clearDirectory:(NSString*)directory;

- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL;
- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL;

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL;

- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atFolderURL:(NSURL*)folderURL;
- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destionationURL withResultError:(NSError*)error;

@end
