//
//  FXDsuperFileControl.h
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define notificationFileControlDidUpdateUbiquityContainerURL	@"notificationFileControlDidUpdateUbiquityContainerURL"

#define notificationFileControlDidEnumerateUbiquitousDocuments	@"notificationFileControlDidEnumerateUbiquitousDocuments"


#ifndef shouldUseUbiquitousDocuments
	#define shouldUseUbiquitousDocuments	1
#endif

#ifndef shouldUseLocalDirectoryWatcher
	#define shouldUseLocalDirectoryWatcher	1
#endif

#ifndef limitPathLevel
	#define limitPathLevel	5
#endif


#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents"
#endif


#import "FXDKit.h"

#import "DirectoryWatcher.h"


@interface FXDsuperFileControl : FXDObject <NSMetadataQueryDelegate, DirectoryWatcherDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	NSInteger _currentPathLevel;
	
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquitousDocumentsURL;
	
	NSMetadataQuery *_ubiquityMetadataQuery;
	DirectoryWatcher *_localDirectoryWatcher;
	
	NSMutableSet *_queuedURLSet;
	NSOperationQueue *_operationQueue;
}

// Properties
@property (assign, nonatomic) NSInteger currentPathLevel;

@property (strong, nonatomic) id ubiquityIdentityToken;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;
@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;

@property (strong, nonatomic) NSMetadataQuery *ubiquityMetadataQuery;
@property (strong, nonatomic) DirectoryWatcher *localDirectoryWatcher;

@property (strong, nonatomic) NSMutableSet *queuedURLSet;
@property (strong, nonatomic) NSOperationQueue *operationQueue;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperFileControl*)sharedInstance;

- (void)startUpdatingUbiquityContainerURL;

- (void)startObservingUbiquityMetadataQueryNotifications;
- (void)startWatchingLocalDirectoryChange;

- (void)enumerateUbiquitousDocuments;
- (void)enumerateLocalDirectory;

- (void)setUbiquitousForLocalFiles:(NSArray*)localFiles;


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
