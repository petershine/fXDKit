//
//  FXDmoduleQuery.h
//
//
//  Created by petershine on 7/1/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#define notificationCloudDocumentsQueryDidGatherObjects		@"notificationCloudDocumentsQueryDidGatherObjects"
#define notificationCloudDocumentsQueryDidFinishGathering	@"notificationCloudDocumentsQueryDidFinishGathering"
#define notificationCloudDocumentsQueryDidUpdate		@"notificationCloudDocumentsQueryDidUpdate"
#define notificationCloudDocumentsQueryIsTransferring	@"notificationCloudDocumentsQueryIsTransferring"

#define objkeyUbiquitousFolders			@"objkeyUbiquitousFolders"
#define objkeyUbiquitousFiles			@"objkeyUbiquitousFiles"
#define objkeyUbiquitousMetadataItems	@"objkeyUbiquitousMetadataItems"


@interface FXDmoduleQuery : FXDsuperModule <NSMetadataQueryDelegate> {
	BOOL _didFinishFirstGathering;

	NSMetadataQuery *_cloudDocumentsQuery;
	NSMutableArray *_collectedURLarray;

	FXDOperationQueue *_evictingQueue;
}

@property (nonatomic) BOOL didFinishFirstGathering;

@property (strong, nonatomic) NSMetadataQuery *cloudDocumentsQuery;
@property (strong, nonatomic) NSMutableArray *collectedURLarray;

@property (strong, nonatomic) FXDOperationQueue *evictingQueue;


- (void)startObservingCloudDocumentsQueryNotifications;

- (void)updateCollectedURLarrayWithMetadataItem:(NSMetadataItem*)metadataItem;
- (void)startEvictingCollectedURLarray;
- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL;

- (void)enumerateMetadataItemsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;
- (void)enumerateDocumentsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback;


//MARK: - Observer implementation
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification;

@end
