//
//  FXDsuperFileControl.m
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperFileControl.h"


#pragma mark - Private interface
@interface FXDsuperFileControl (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperFileControl

#pragma mark Static objects

#pragma mark Synthesizing
// Properties
@synthesize ubiquityIdentityToken = _ubiquityIdentityToken;

@synthesize ubiquityContainerURL = _ubiquityContainerURL;
@synthesize ubiquitousDocumentsURL = _ubiquitousDocumentsURL;

@synthesize ubiquityMetadataQuery = _ubiquityMetadataQuery;

@synthesize localDirectoryWatcher = _localDirectoryWatcher;

@synthesize queuedURLSet = _queuedURLSet;
@synthesize operationQueue = _operationQueue;


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties		
		_ubiquityIdentityToken = nil;
		
		_ubiquityContainerURL = nil;
		_ubiquitousDocumentsURL = nil;
		
		_ubiquityMetadataQuery = nil;
		
		_localDirectoryWatcher = nil;
		
		_queuedURLSet = nil;
		_operationQueue = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSURL*)ubiquitousDocumentsURL {
	if (_ubiquitousDocumentsURL == nil) {
		if (self.ubiquityContainerURL) {
			_ubiquitousDocumentsURL = [self.ubiquityContainerURL URLByAppendingPathComponent:pathcomponentDocuments];			
		}
	}
	
	return _ubiquitousDocumentsURL;
}

#pragma mark -
- (NSMetadataQuery*)ubiquityMetadataQuery {
	if (_ubiquityMetadataQuery == nil) {
		_ubiquityMetadataQuery = [[NSMetadataQuery alloc] init];
	}
	
	return _ubiquityMetadataQuery;
}

#pragma mark -
- (NSMutableSet*)queuedURLSet {
	if (_queuedURLSet == nil) {
		_queuedURLSet =[[NSMutableSet alloc] initWithCapacity:0];
	}
	
	return _queuedURLSet;
}

- (NSOperationQueue*)operationQueue {
	if (_operationQueue == nil) {
		_operationQueue = [[NSOperationQueue alloc] init];
	}
	
	return _operationQueue;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperFileControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
	
    return _sharedInstance;
}

#pragma mark -
- (void)startCloudSynchronization {	FXDLog_DEFAULT;
	
	BOOL shouldRequestUbiquityContatinerURL = NO;
	
	if ([FXDsuperGlobalControl isSystemVersionLatest]) {		
#if isNewestSDK
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(observedNSUbiquityIdentityDidChange:)
													 name:NSUbiquityIdentityDidChangeNotification
												   object:nil];
		
		self.ubiquityIdentityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
		FXDLog(@"ubiquityToken: %@", self.ubiquityIdentityToken);
		
		if (self.ubiquityIdentityToken) {
			shouldRequestUbiquityContatinerURL = YES;
		}
#endif
	}
	else {
		shouldRequestUbiquityContatinerURL = YES;
	}
	
	FXDLog(@"shouldRequestUbiquityContatinerURL: %@", shouldRequestUbiquityContatinerURL ? @"YES":@"NO");
	
	if (shouldRequestUbiquityContatinerURL) {
		__block FXDsuperFileControl *fileControl = self;
				
		[[NSOperationQueue new] addOperationWithBlock:^{
			NSURL *ubiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			
			fileControl.ubiquityContainerURL = ubiquityContainerURL;
			FXDLog(@"ubiquityContainerURL: %@", fileControl.ubiquityContainerURL);

			
#if DEBUG
			NSArray *directoryTree = [[NSFileManager defaultManager] directoryTreeForRootURL:fileControl.ubiquitousDocumentsURL];
			FXDLog(@"directoryTree count: %d", [directoryTree count]);
#endif
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
#if shouldUseUbiquitousDocuments
				[fileControl startObservingUbiquityMetadataQueryNotifications];
#endif
				
#if shouldUseLocalDirectoryWatcher
				[fileControl startWatchingLocalDirectoryChange];
#endif
				
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
			}];
		}];
	}
	else {
		//TODO: alert user about using iCloud;
		
#if shouldUseLocalDirectoryWatcher
		[self startWatchingLocalDirectoryChange];
#endif
		
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:nil];
	}
}

#pragma mark -
- (void)startObservingUbiquityMetadataQueryNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidStartGathering:)
						  name:NSMetadataQueryDidStartGatheringNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryGatheringProgress:)
						  name:NSMetadataQueryGatheringProgressNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidFinishGathering:)
						  name:NSMetadataQueryDidFinishGatheringNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidUpdate:)
						  name:NSMetadataQueryDidUpdateNotification
						object:nil];
	
	[self.ubiquityMetadataQuery applyDefaultConfiguration];
	
	[self.ubiquityMetadataQuery enableUpdates];
	
	BOOL didStart = [self.ubiquityMetadataQuery startQuery];
	
	if (didStart == NO) {
		//TODO: handle error
	}
}

- (void)startWatchingLocalDirectoryChange {	FXDLog_DEFAULT;	
	self.localDirectoryWatcher = [DirectoryWatcher watchFolderWithPath:applicationDocumentsSearchPath delegate:self];
}

#pragma mark -
- (void)delayedUpdateUbiquitousDocuments {	FXDLog_DEFAULT;
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] fullEnumeratorForRootURL:self.ubiquitousDocumentsURL];
	
	NSURL *nextObject = [enumerator nextObject];
	
	NSUInteger currentLevel = 1;	//TODO: change level appropriately
	
	NSMutableArray *files = [[NSMutableArray alloc] initWithCapacity:0];
	
	while (nextObject) {
		//FXDLog(@"enumerator.level: %u", enumerator.level);
		
		if (enumerator.level == currentLevel) {
			[files addObject:nextObject];
		}
		
		nextObject = [enumerator nextObject];
	}
	
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	if (files && [files count] > 0) {
		[userInfo setObject:files forKey:@"ubiquitousFiles"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquitousDocuments object:self userInfo:userInfo];
}

- (void)delayedUpdateLocalDirectory {	//FXDLog_DEFAULT;
	
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] fullEnumeratorForRootURL:applicationDocumentsDirectory];
	
	NSURL *nextObject = [enumerator nextObject];
	
	while (nextObject) {
		__block NSURL *localFileURL = [[NSURL alloc] initWithString:[nextObject absoluteString]];
		
		id isUbiquitousItem = nil;
		
		[localFileURL getResourceValue:&isUbiquitousItem forKey:NSURLIsUbiquitousItemKey error:nil];
		
		if (isUbiquitousItem && [isUbiquitousItem boolValue] == NO) {
			if ([self.queuedURLSet containsObject:localFileURL] == NO) {
				[self.queuedURLSet addObject:localFileURL];
				
				__block FXDsuperFileControl *fileControl = self;
												
				[self.operationQueue addOperationWithBlock:^{
					NSArray *localFiles = [NSArray arrayWithObject:localFileURL];
					
					[fileControl setUbiquitousForLocalFiles:localFiles];
					
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						if ([fileControl.queuedURLSet containsObject:localFileURL]) {
							[fileControl.queuedURLSet removeObject:localFileURL];
						}
												
						if ([fileControl.queuedURLSet count] == 0) {
							[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateLocalDirectory object:nil];
						}
					}];
				}];
			}
		}

		nextObject = [enumerator nextObject];
	}
}

#pragma mark -
- (void)setUbiquitousForLocalFiles:(NSArray*)localFiles {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	for (NSURL *localfileURL in localFiles) {

		NSString *localfilePath = [[[localfileURL absoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject];
		
		NSURL *destinationURL = [self.ubiquitousDocumentsURL URLByAppendingPathComponent:localfilePath];	//Use iCloud /Documents
				
		NSError *error = nil;
		
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:localfileURL destinationURL:destinationURL error:&error];
		
		FXDLog(@"didSetUbiquitous: %@ %@", didSetUbiquitous ? @"YES":@"NO", localfilePath);
		
		if (error) {
			FXDLog_ERROR;
			
			//TODO: deal with following cases
			/*
			 domain: NSCocoaErrorDomain
			 code: 516
			 localizedDescription: The operation couldn’t be completed. (Cocoa error 516.)
			 userInfo: {
			 NSFilePath = "/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/EasyFileSharing_1.1_0710.pdf";
			 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
			 }
			 
			 domain: NSPOSIXErrorDomain
			 code: 63
			 localizedDescription: The operation couldn’t be completed. File name too long
			 userInfo: {
			 NSDescription = "Unable to lstat destination path '/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%90%E1%85%B3%20%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%85%E1%85%B5%E1%86%B8%20%E1%84%8F%E1%85%AE%E1%84%91%E1%85%A9%E1%86%AB%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%E1%84%83%E1%85%A2%E1%84%8C%E1%85%A1%E1%86%BC.xls'.";
			 }
			 */
			
			NSString *title = nil;
			
			switch ([error code]) {
				case 516:
					//"Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
					break;
					
				default:
					title = [NSString stringWithFormat:@"%@\n%@", [error localizedDescription], localfilePath];
					break;
			}
			
			if (title) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
																	message:nil
																   delegate:nil
														  cancelButtonTitle:text_OK
														  otherButtonTitles:nil];
				[alertView show];
			}
		}
	}
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_OVERRIDE;
	NSMetadataQuery *metadataQuery = notification.object;
	FXDLog(@"resultCount: %u", [metadataQuery resultCount]);
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	[self observedNSMetadataQueryDidUpdate:notification];	//MARK: treat it same as updated
	
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_OVERRIDE;
	NSMetadataQuery *metadataQuery = notification.object;
	FXDLog(@"resultCount: %u", [metadataQuery resultCount]);
	
	[metadataQuery logQueryResultsWithTransferringPercentage];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateUbiquitousDocuments) object:nil];
	[self performSelector:@selector(delayedUpdateUbiquitousDocuments) withObject:nil afterDelay:0];
}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher*)folderWatcher {	//FXDLog_DEFAULT;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateLocalDirectory) object:nil];
	[self performSelector:@selector(delayedUpdateLocalDirectory) withObject:nil afterDelay:0];
}


@end
