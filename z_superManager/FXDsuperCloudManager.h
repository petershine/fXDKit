//
//  FXDsuperCloudManager.h
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationCloudManagerDidUpdateUbiquityContainerURL	@"notificationCloudManagerDidUpdateUbiquityContainerURL"

#define notificationCloudManagerMetadataQueryDidGatherObjects	@"notificationCloudManagerMetadataQueryDidGatherObjects"
#define notificationCloudManagerMetadataQueryDidFinishGathering	@"notificationCloudManagerMetadataQueryDidFinishGathering"
#define notificationCloudManagerMetadataQueryDidUpdate	@"notificationCloudManagerMetadataQueryDidUpdate"
#define notificationCloudManagerMetadataQueryIsTransferring	@"notificationCloudManagerMetadataQueryIsTransferring"

#define notificationCloudManagerDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL	@"notificationCloudManagerDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL"
#define notificationCloudManagerDidEnumerateUbiquitousDocumentsAtCurrentFolderURL	@"notificationCloudManagerDidEnumerateUbiquitousDocumentsAtCurrentFolderURL"


#define userdefaultStringSavedUbiquityContainerURL	@"SavedUbiquityContainerURLstringKey"
#define userdefaultObjSavedUbiquityIdentityToken	@"SavedUbiquityIdentityTokenObjKey"

#define objkeyUbiquitousFolders			@"objkeyUbiquitousFolders"
#define objkeyUbiquitousFiles			@"objkeyUbiquitousFiles"
#define objkeyUbiquitousMetadataItems	@"objkeyUbiquitousMetadataItems"


#ifndef shouldUseUbiquitousDocuments
	#define shouldUseUbiquitousDocuments	0
#endif

#ifndef shouldUseLocalDirectoryWatcher
	#define shouldUseLocalDirectoryWatcher	0
#endif

#ifndef shouldDownloadEvictedFilesInitially
	#define shouldDownloadEvictedFilesInitially	0
#endif


#import "DirectoryWatcher.h"


@interface FXDsuperCloudManager : FXDObject <NSMetadataQueryDelegate, DirectoryWatcherDelegate> {
    // Primitives
	BOOL _didFinishFirstGathering;
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquitousDocumentsURL;
	NSURL *_ubiquitousCachesURL;
	
	NSMetadataQuery *_ubiquitousDocumentsMetadataQuery;
	DirectoryWatcher *_localDirectoryWatcher;

	NSOperationQueue *_evictingQueue;
		
	NSMutableArray *_collectedURLarray;
}

// Properties
@property (assign, nonatomic) BOOL didFinishFirstGathering;

@property (strong, nonatomic) id ubiquityIdentityToken;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;
@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;
@property (strong, nonatomic) NSURL *ubiquitousCachesURL;

@property (strong, nonatomic) NSMetadataQuery *ubiquitousDocumentsMetadataQuery;
@property (strong, nonatomic) DirectoryWatcher *localDirectoryWatcher;

@property (strong, nonatomic) NSOperationQueue *evictingQueue;

@property (strong, nonatomic) NSMutableArray *collectedURLarray;


#pragma mark - Public
+ (FXDsuperCloudManager*)sharedInstance;

- (void)startUpdatingUbiquityContainerURL;
- (void)evaluateSavedUbiquityContainerURL;
- (void)activatedUbiquityContainerURL;
- (void)failedToUpdateUbiquityContainerURL;

- (void)startObservingUbiquityMetadataQueryNotifications;
- (void)startWatchingLocalDirectoryChange;

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
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateLocalDirectory;

@end