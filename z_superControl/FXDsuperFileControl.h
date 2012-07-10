//
//  FXDsuperFileControl.h
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define applicationDocumentsDirectory	[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]


#define notificationFileControlDidUpdateUbiquityContainerURL	@"notificationFileControlDidUpdateUbiquityContainerURL"

#define notificationFileControlDidUpdateUbiquityDocuments	@"notificationFileControlDidUpdateUbiquityDocuments"
#define notificationFileControlDidUpdateLocalDirectory		@"notificationFileControlDidUpdateLocalDirectory"


#ifndef limitPathLevel
	#define limitPathLevel	5
#endif


#import "FXDKit.h"

#import "DirectoryWatcher.h"


@interface FXDsuperFileControl : FXDObject <NSMetadataQueryDelegate, DirectoryWatcherDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference	
	id _ubiquityIdentityToken;
	
	NSURL *_ubiquityContainerURL;
	NSURL *_ubiquityDocumentsURL;
	
	NSMetadataQuery *_ubiquityMetadataQuery;
	
	DirectoryWatcher *_directoryWatcher;
}

// Properties
@property (strong, nonatomic) id ubiquityIdentityToken;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;
@property (strong, nonatomic) NSURL *ubiquityDocumentsURL;

@property (strong, nonatomic) NSMetadataQuery *ubiquityMetadataQuery;

@property (strong, nonatomic) DirectoryWatcher *directoryWatcher;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperFileControl*)sharedInstance;

- (void)startCloudSynchronization;

- (void)startObservingUbiquityMetadataQueryNotifications;
- (void)startObservingLocalDocumentDirectoryChange;

- (void)delayedUpdateUbiquityDocuments;
- (void)delayedUpdateLocalDirectory;

- (void)setUbiquitousForLocalFiles:(NSArray*)files;


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
