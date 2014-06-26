//
//  FXDsuperCloudManager.h
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationCloudManagerDidUpdateUbiquityContainerURL	@"notificationCloudManagerDidUpdateUbiquityContainerURL"

#define notificationCloudDocumentsQueryDidGatherObjects		@"notificationCloudDocumentsQueryDidGatherObjects"
#define notificationCloudDocumentsQueryDidFinishGathering	@"notificationCloudDocumentsQueryDidFinishGathering"
#define notificationCloudDocumentsQueryDidUpdate		@"notificationCloudDocumentsQueryDidUpdate"
#define notificationCloudDocumentsQueryIsTransferring	@"notificationCloudDocumentsQueryIsTransferring"

#define notificationCloudManagerDidEnumerateUbiquitousMetadataItems	@"notificationCloudManagerDidEnumerateUbiquitousMetadataItems"
#define notificationCloudManagerDidEnumerateUbiquitousDocuments	@"notificationCloudManagerDidEnumerateUbiquitousDocuments"


#define userdefaultStringSavedUbiquityContainerURL	@"SavedUbiquityContainerURLstringKey"
#define userdefaultObjSavedUbiquityIdentityToken	@"SavedUbiquityIdentityTokenObjKey"

#define objkeyUbiquitousFolders			@"objkeyUbiquitousFolders"
#define objkeyUbiquitousFiles			@"objkeyUbiquitousFiles"
#define objkeyUbiquitousMetadataItems	@"objkeyUbiquitousMetadataItems"


#ifndef USE_UbiquitousDocuments
	#define USE_UbiquitousDocuments	FALSE
#endif

#ifndef USE_DownloadingEvictedFilesInitially
	#define USE_DownloadingEvictedFilesInitially	FALSE
#endif


#ifndef TEST_loggingTransferringPercentage
	#define TEST_loggingTransferringPercentage	FALSE
#endif


@interface FXDsuperCloudManager : FXDObject <NSMetadataQueryDelegate> {
	BOOL _didFinishFirstGathering;
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquitousDocumentsURL;
	NSURL *_ubiquitousCachesURL;
	
	NSMetadataQuery *_cloudDocumentsQuery;

	NSOperationQueue *_evictingQueue;
		
	NSMutableArray *_collectedURLarray;
}

// Properties
@property (nonatomic) BOOL didFinishFirstGathering;

@property (strong, nonatomic) id ubiquityIdentityToken;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;
@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;
@property (strong, nonatomic) NSURL *ubiquitousCachesURL;

@property (strong, nonatomic) NSMetadataQuery *cloudDocumentsQuery;

@property (strong, nonatomic) NSOperationQueue *evictingQueue;

@property (strong, nonatomic) NSMutableArray *collectedURLarray;


#pragma mark - Public
+ (FXDsuperCloudManager*)sharedInstance;

- (void)startUpdatingUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)activatedUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)failedToUpdateUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)startObservingCloudDocumentsQueryNotifications;

- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atCurrentFolderURL:(NSURL*)currentFolderURL withSeparatorPathComponent:(NSString*)separatorPathComponent;
- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destionationURL withResultError:(NSError*)error;

- (void)updateCollectedURLarrayWithMetadataItem:(NSMetadataItem*)metadataItem;
- (void)startEvictingCollectedURLarray;
- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL;


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification;

- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface FXDsuperCloudManager (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtFolderURL:(NSURL*)folderURL withDidEnumerateBlock:(void(^)(BOOL finished, NSDictionary *userInfo))didEnumerateBlock;
- (void)enumerateUbiquitousDocumentsAtFolderURL:(NSURL*)folderURL withDidEnumerateBlock:(void(^)(BOOL finished, NSDictionary *userInfo))didEnumerateBlock;
- (void)enumerateLocalDirectory;

@end
