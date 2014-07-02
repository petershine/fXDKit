//
//  FXDmoduleDocuments.h
//
//
//  Created by petershine on 7/1/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@interface FXDinfoEnumerated : NSObject
@property (strong, nonatomic) NSArray *folderURLarray;
@property (strong, nonatomic) NSArray *fileURLarray;
@end


#import "FXDmoduleQuery.h"
@interface FXDmoduleDocuments : FXDmoduleQuery
@property (strong, nonatomic) FXDOperationQueue *evictingQueue;


- (void)startEvictingURLarray:(NSArray*)URLarray;
- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL;

- (void)enumerateMetadataItemsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;
- (void)enumerateDocumentsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;


@end
