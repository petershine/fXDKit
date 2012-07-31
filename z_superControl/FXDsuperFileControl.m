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
		_currentPathLevel = 1;
		
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
	IMPLEMENTATION_sharedInstance;
}

#pragma mark -
- (void)startUpdatingUbiquityContainerURL {	FXDLog_DEFAULT;
	
	BOOL shouldRequestUbiquityContatinerURL = NO;
	
	if ([FXDsuperGlobalControl isSystemVersionLatest]) {		
#if ENVIRONTMENT_newestSDK
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
			fileControl.ubiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			FXDLog(@"ubiquityContainerURL: %@", fileControl.ubiquityContainerURL);

			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
#if shouldUseUbiquitousDocuments
				[fileControl startObservingUbiquityMetadataQueryNotifications];
				
				//FXDLog(@"ubiquitousDocumentsURL:\n%@", [[NSFileManager defaultManager] directoryTreeForRootURL:fileControl.ubiquitousDocumentsURL]);
#endif
				
#if shouldUseLocalDirectoryWatcher
				[fileControl startWatchingLocalDirectoryChange];
				
				FXDLog(@"documentsDirectory:\n%@", [[NSFileManager defaultManager] directoryTreeForRootURL:appDirectory_Document]);
				//FXDLog(@"cachedDirectory:\n%@", [[NSFileManager defaultManager] directoryTreeForRootURL:appDirectory_Caches]);
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
	self.localDirectoryWatcher = [DirectoryWatcher watchFolderWithPath:appSearhPath_Document delegate:self];
	
}

#pragma mark -
- (void)setUbiquitousForLocalFiles:(NSArray*)localFiles withCurrentFolderURL:(NSURL*)currentFolderURL withFileManager:(NSFileManager*)fileManager {	//FXDLog_DEFAULT;
	
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	if (fileManager == nil) {
		fileManager = [NSFileManager defaultManager];
	}
	
	for (NSURL *localfileURL in localFiles) {
		NSString *localfilePath = [[[localfileURL absoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject];
		localfilePath = [localfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURL *destinationURL = [currentFolderURL URLByAppendingPathComponent:localfilePath];	//Use iCloud /Documents
				
		NSError *error = nil;
				
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:localfileURL destinationURL:destinationURL error:&error];
		
		FXDLog_ERROR;
		
		if (error || didSetUbiquitous == NO) {
			FXDLog(@"didSetUbiquitous: %@", didSetUbiquitous ? @"YES":@"NO");
			//FXDLog(@"resourceValues:\n%@", [destinationURL fullResourceValuesWithError:nil]);
			
			[self handleFailedLocalFileURL:localfileURL withDestinationURL:destinationURL withResultError:error];
		}
	}
}

- (void)handleFailedLocalFileURL:(NSURL*)localfileURL withDestinationURL:(NSURL*)destinationURL withResultError:(NSError*)error {	//FXDLog_DEFAULT;
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
	 
	 domain: NSCocoaErrorDomain
	 code: 260
	 localizedDescription: The operation couldn’t be completed. (Cocoa error 260.)
	 userInfo: {
	 NSFilePath = "/private/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Documents/IMG_1144.JPG";
	 NSURL = "file://localhost/private/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Documents/IMG_1144.JPG";
	 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=2 \"The operation couldn\U2019t be completed. No such file or directory\" UserInfo=0xf89ddd0 {}";
	 }
	 
	 domain: NSPOSIXErrorDomain
	 code: 2
	 localizedDescription: The operation couldn’t be completed. No such file or directory
	 userInfo: {
	 NSDescription = "Unable to rename '/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG' to '/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/file://localhost/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG'.";
	 }
	 */
	
	NSString *title = nil;
	
	if ([[error domain] isEqualToString:NSPOSIXErrorDomain]) {
		switch ([error code]) {
			case 63:	//The operation couldn’t be completed. File name too long
				break;
				
			default:
				break;
		}
	}
	else if ([[error domain] isEqualToString:NSCocoaErrorDomain]) {
		switch ([error code]) {				
			case 516:	//"Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
				break;
				
			default:
				title = [NSString stringWithFormat:@"%@\n%@", [error localizedDescription], localfileURL];
				break;
		}
	}
	
	if (title) {	FXDLog_DEFAULT;
		//TODO: should alert?
		FXDLog(@"title: %@", title);
	}
}

#pragma mark -
- (void)addNewFolderInsideCurrentFolderURL:(NSURL*)currentFolderURL withNewFolderName:(NSString*)newFolderName {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	if (newFolderName == nil || [newFolderName isEqualToString:@""]) {
		newFolderName = [[NSDate date] description];
	}
	
	
	NSString *pathComponent = [NSString stringWithFormat:@"%@", newFolderName];
	NSURL *newFolderURL = [currentFolderURL URLByAppendingPathComponent:pathComponent];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	[fileManager createDirectoryAtURL:newFolderURL
		  withIntermediateDirectories:YES
						   attributes:nil
								error:&error];
	
	FXDLog_ERROR;
	
	[self enumerateUbiquitousDocumentsAtCurrentFolderURL:currentFolderURL];
}

#pragma mark -
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *metadataItems = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	//FXDLog(@"self.ubiquityMetadataQuery results] count: %d", [[self.ubiquityMetadataQuery results] count]);
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		for (NSMetadataItem *metadataItem in [self.ubiquityMetadataQuery results]) {
			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
			
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			
			[itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				[metadataItems addObject:metadataItem];
			}
		}
		
		[userInfo setObject:metadataItems forKey:objkeyUbiquitousMetadataItems];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];

}

- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *folders = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] fullEnumeratorForRootURL:currentFolderURL];
		
		NSURL *nextObject = [enumerator nextObject];
		
		while (nextObject) {			
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			
			[nextObject getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				id fileResourceType = nil;
				
				[nextObject getResourceValue:&fileResourceType forKey:NSURLFileResourceTypeKey error:&error];
				
				if ([fileResourceType isEqualToString:NSURLFileResourceTypeDirectory]) {
					[folders addObject:nextObject];
				}
			}
			
			FXDLog_ERROR;
			
			nextObject = [enumerator nextObject];
		}
		
		
		[userInfo setObject:folders forKey:objkeyUbiquitousFolders];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
#if ENVIRONTMENT_newestSDK
	__block FXDsuperFileControl *fileControl = self;
#else
	__weak FXDsuperFileControl *fileControl = self;
#endif
	
	__block NSFileManager *fileManager = [NSFileManager defaultManager];
	
	
	NSURL *rootURL = [NSURL URLWithString:appSearhPath_Document];
	
	NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:rootURL];
	
	NSURL *nextObject = [enumerator nextObject];
	
	while (nextObject) {
		
		__block NSURL *localFileURL = nextObject;
		
		if ([fileControl.queuedURLSet containsObject:localFileURL] == NO) {
			[fileControl.queuedURLSet addObject:localFileURL];
			
			[fileControl.operationQueue addOperationWithBlock:^{
				id isUbiquitousItem = nil;
				id isHidden = nil;
				
				NSError *error = nil;
				
				[localFileURL getResourceValue:&isUbiquitousItem forKey:NSURLIsUbiquitousItemKey error:&error];
				[localFileURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
				
				FXDLog_ERROR;
				
				if ((isUbiquitousItem == nil || [isUbiquitousItem boolValue] == NO) && [isHidden boolValue] == NO) {
					NSArray *localFiles = @[localFileURL];
					
					[fileControl setUbiquitousForLocalFiles:localFiles withCurrentFolderURL:self.ubiquitousDocumentsURL withFileManager:fileManager];
				}
				
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					if ([fileControl.queuedURLSet containsObject:localFileURL]) {
						[fileControl.queuedURLSet removeObject:localFileURL];
					}
				}];
			}];
		}
		
		nextObject = [enumerator nextObject];
	}
}

#pragma mark -
- (void)removeSelectedURLs:(NSArray*)selectedURLs fromCurrentFolderURL:(NSURL*)currentFolderURL {	FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	for (NSURL *itemURL in selectedURLs) {
		
		BOOL didRemove = [fileManager removeItemAtURL:itemURL error:&error];
		
		FXDLog(@"didRemove: %@ itemURL: %@", didRemove ? @"YES":@"NO", itemURL);
	}
	
	FXDLog_ERROR;
	
	[self enumerateUbiquitousDocumentsAtCurrentFolderURL:currentFolderURL];
	[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:currentFolderURL];
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {
	NSMetadataQuery *metadataQuery = notification.object;
	
	BOOL didLogTransferring = [metadataQuery logQueryResultsWithTransferringPercentage];
	
	//TODO: distinguish uploading and downloading and finished updating
	
	if (didLogTransferring) {		
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryIsTransferring object:notification.object userInfo:notification.userInfo];
	}
	else {	//FXDLog_OVERRIDE;
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidUpdate object:notification.object userInfo:notification.userInfo];
	}
}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher*)folderWatcher {	//FXDLog_DEFAULT;
	[self enumerateLocalDirectory];
}


@end
