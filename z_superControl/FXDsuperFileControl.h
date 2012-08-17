//
//  FXDsuperFileControl.h
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationFileControlDidUpdateUbiquityContainerURL	@"notificationFileControlDidUpdateUbiquityContainerURL"

#define notificationFileControlMetadataQueryDidFinishGathering	@"notificationFileControlMetadataQueryDidFinishGathering"
#define notificationFileControlMetadataQueryDidUpdate	@"notificationFileControlMetadataQueryDidUpdate"
#define notificationFileControlMetadataQueryIsTransferring	@"notificationFileControlMetadataQueryIsTransferring"

#define notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL	@"notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL"
#define notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL	@"notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL"


#define objkeyUbiquitousFolders			@"objkeyUbiquitousFolders"
#define objkeyUbiquitousFiles			@"objkeyUbiquitousFiles"
#define objkeyUbiquitousMetadataItems	@"objkeyUbiquitousMetadataItems"


#ifndef shouldUseUbiquitousDocuments
	#define shouldUseUbiquitousDocuments	1
#endif

#ifndef shouldUseLocalDirectoryWatcher
	#define shouldUseLocalDirectoryWatcher	1
#endif


#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif


#import "FXDKit.h"

#import "DirectoryWatcher.h"


@interface FXDsuperFileControl : NSObject <NSMetadataQueryDelegate, DirectoryWatcherDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	BOOL _didFinishFirstGathering;
	
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquitousDocumentsURL;
	NSURL *_ubiquitousCachesURL;
	
	NSMetadataQuery *_ubiquitousDocumentsMetadataQuery;
	DirectoryWatcher *_localDirectoryWatcher;
	
	NSMutableSet *_queuedURLset;
	NSOperationQueue *_operationQueue;
}

// Properties
@property (assign, nonatomic) BOOL didFinishFirstGathering;

@property (strong, nonatomic) id ubiquityIdentityToken;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;
@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;
@property (strong, nonatomic) NSURL *ubiquitousCachesURL;

@property (strong, nonatomic) NSMetadataQuery *ubiquitousDocumentsMetadataQuery;
@property (strong, nonatomic) DirectoryWatcher *localDirectoryWatcher;

@property (strong, nonatomic) NSMutableSet *queuedURLset;
@property (strong, nonatomic) NSOperationQueue *operationQueue;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperFileControl*)sharedInstance;

- (void)startUpdatingUbiquityContainerURL;
- (void)failedToUpdateUbiquityContainerURL;

- (void)startObservingUbiquityMetadataQueryNotifications;
- (void)startWatchingLocalDirectoryChange;

- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atCurrentFolderURL:(NSURL*)currentFolderURL withSeparatorPathComponent:(NSString*)separatorPathComponent;
- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destionationURL withResultError:(NSError*)error;

- (void)evictAllUbiquitousDocuments;
- (void)evictUbiquitousItemURLarray:(NSArray*)itemURLarray;


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
@interface FXDsuperFileControl (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL;
- (void)enumerateLocalDirectory;

@end


@interface FXDsuperFileControl (Managing)
#pragma mark - Public
- (void)addNewFolderInsideCurrentFolderURL:(NSURL*)currentFolderURL withNewFolderName:(NSString*)newFolderName;

@end
