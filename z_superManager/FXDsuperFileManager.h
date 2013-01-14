//
//  FXDsuperFileManager.h
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationFileControlDidUpdateUbiquityContainerURL	@"notificationFileControlDidUpdateUbiquityContainerURL"

#define notificationFileControlMetadataQueryDidGatherObjects	@"notificationFileControlMetadataQueryDidGatherObjects"
#define notificationFileControlMetadataQueryDidFinishGathering	@"notificationFileControlMetadataQueryDidFinishGathering"
#define notificationFileControlMetadataQueryDidUpdate	@"notificationFileControlMetadataQueryDidUpdate"
#define notificationFileControlMetadataQueryIsTransferring	@"notificationFileControlMetadataQueryIsTransferring"

#define notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL	@"notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL"
#define notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL	@"notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL"


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


#import "FXDKit.h"

#import "DirectoryWatcher.h"


@interface FXDsuperFileManager : FXDObject <NSMetadataQueryDelegate, DirectoryWatcherDelegate> {
    // Primitives
	BOOL _didFinishFirstGathering;
	
	// Instance variables
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquitousDocumentsURL;
	NSURL *_ubiquitousCachesURL;
	
	NSMetadataQuery *_ubiquitousDocumentsMetadataQuery;
	DirectoryWatcher *_localDirectoryWatcher;

	NSOperationQueue *_fileManagingOperationQueue;
	
	NSOperationQueue *_mainOperationQueue;
	NSMutableDictionary *_queuedOperationDictionary;
	
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

@property (strong, nonatomic) NSOperationQueue *fileManagingOperationQueue;

@property (strong, nonatomic) NSOperationQueue *mainOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *queuedOperationDictionary;

@property (strong, nonatomic) NSMutableArray *collectedURLarray;


#pragma mark - Public
+ (FXDsuperFileManager*)sharedInstance;

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
#pragma mark - NSMetadataQueryDelegate
#pragma mark - DirectoryWatcherDelegate

@end


#pragma mark - Category
@interface FXDsuperFileManager (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateLocalDirectory;

@end
