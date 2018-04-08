
#import "FXDimportEssential.h"
#import "FXDOperationQueue.h"
#import "FXDFileManager.h"


@interface FXDinfoEnumerated : NSObject
@property (strong, nonatomic) NSArray *folderURLarray;
@property (strong, nonatomic) NSArray *fileURLarray;
@end


#import "FXDmoduleQuery.h"
@interface FXDmoduleDocuments : FXDmoduleQuery
@property (strong, nonatomic) NSOperationQueue *evictingQueue;


- (void)startEvictingURLarray:(NSArray*)URLarray;
- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL;

- (void)enumerateMetadataItemsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;
- (void)enumerateDocumentsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;

@end
