//
//  FXDsuperFileControl.m
//
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
	
	if (_ubiquitousDocumentsURL == nil) {	FXDLog_DEFAULT;
		FXDLog(@"_ubiquitousDocumentsURL: %@", _ubiquitousDocumentsURL);
	}
	
	return _ubiquitousDocumentsURL;
}

- (NSURL*)ubiquitousCachesURL {
	if (_ubiquitousCachesURL == nil) {
		if (self.ubiquityContainerURL) {
			_ubiquitousCachesURL = [self.ubiquityContainerURL URLByAppendingPathComponent:pathcomponentCaches];
		}
	}
	
	if (_ubiquitousCachesURL == nil) {	FXDLog_DEFAULT;
		FXDLog(@"_ubiquitousCachesURL: %@", _ubiquitousCachesURL);
	}
	
	return _ubiquitousCachesURL;
}

#pragma mark -
- (NSMetadataQuery*)ubiquitousDocumentsMetadataQuery {
	if (_ubiquitousDocumentsMetadataQuery == nil) {	FXDLog_DEFAULT;
		_ubiquitousDocumentsMetadataQuery = [[NSMetadataQuery alloc] init];
		
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSMetadataQueryDidStartGathering:)
							  name:NSMetadataQueryDidStartGatheringNotification
							object:_ubiquitousDocumentsMetadataQuery];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSMetadataQueryGatheringProgress:)
							  name:NSMetadataQueryGatheringProgressNotification
							object:_ubiquitousDocumentsMetadataQuery];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSMetadataQueryDidFinishGathering:)
							  name:NSMetadataQueryDidFinishGatheringNotification
							object:_ubiquitousDocumentsMetadataQuery];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSMetadataQueryDidUpdate:)
							  name:NSMetadataQueryDidUpdateNotification
							object:_ubiquitousDocumentsMetadataQuery];
		
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
		[_ubiquitousDocumentsMetadataQuery setPredicate:predicate];

		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSCreationDateKey ascending:NO];
		[_ubiquitousDocumentsMetadataQuery setSortDescriptors:@[sortDescriptor]];
		
		[_ubiquitousDocumentsMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
		[_ubiquitousDocumentsMetadataQuery setNotificationBatchingInterval:delayHalfSecond];
		
		BOOL didStart = [_ubiquitousDocumentsMetadataQuery startQuery];
		FXDLog(@"didStart: %d", didStart);
	}
	
	return _ubiquitousDocumentsMetadataQuery;
}

#pragma mark -
- (NSOperationQueue*)operationQueue {
	if (_operationQueue == nil) {
		_operationQueue = [[NSOperationQueue alloc] init];
	}
	
	return _operationQueue;
}

- (NSMutableDictionary*)queuedOperationDictionary {
	if (_queuedOperationDictionary == nil) {
		_queuedOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _queuedOperationDictionary;
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
#else
		shouldRequestUbiquityContatinerURL = YES;
#endif
	}
	else {
		shouldRequestUbiquityContatinerURL = YES;
	}
	
	FXDLog(@"shouldRequestUbiquityContatinerURL: %d", shouldRequestUbiquityContatinerURL);
	
	if (shouldRequestUbiquityContatinerURL) {
		[[FXDWindow applicationWindow] showProgressView];
		
		[self evaluateSavedUbiquityContainerURL];		

		[[NSOperationQueue new] addOperationWithBlock:^{
			NSURL *activeUbiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			FXDLog(@"activeUbiquityContainerURL: %@", activeUbiquityContainerURL);

			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[FXDWindow hideProgressViewAfterDelay:delayBeforeShowOrHideProgressView];

				if (activeUbiquityContainerURL) {					
					if (self.ubiquityContainerURL) {
						if ([[activeUbiquityContainerURL absoluteString] isEqualToString:[self.ubiquityContainerURL absoluteString]] == NO) {
							//TODO: what to do?
						}
					}

					_ubiquityContainerURL = nil;
					_ubiquitousDocumentsURL = nil;
					_ubiquitousCachesURL = nil;

					self.ubiquityContainerURL = activeUbiquityContainerURL;

					[[NSUserDefaults standardUserDefaults] setObject:[self.ubiquityContainerURL absoluteString] forKey:userdefaultStringSavedUbiquityContainerURL];
					[[NSUserDefaults standardUserDefaults] synchronize];

					[self activatedUbiquityContainerURL];
				}
				else {
					[self failedToUpdateUbiquityContainerURL];
				}
			}];
		}];
	}
	else {
		[self failedToUpdateUbiquityContainerURL];
	}
}

- (void)evaluateSavedUbiquityContainerURL {	FXDLog_DEFAULT;
	NSURL *savedUbiquityContainerURL = nil;

	NSString *containerURLstring = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultStringSavedUbiquityContainerURL];

	if (containerURLstring) {
		savedUbiquityContainerURL = [NSURL URLWithString:containerURLstring];
	}

	FXDLog(@"savedUbiquityContainerURL: %@", savedUbiquityContainerURL);

	if (savedUbiquityContainerURL) {
		_ubiquityContainerURL = nil;
		_ubiquitousDocumentsURL = nil;
		_ubiquitousCachesURL = nil;
		
		self.ubiquityContainerURL = savedUbiquityContainerURL;

		[self activatedUbiquityContainerURL];
		[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
	}

	FXDLog(@"ubiquityContainerURL: %@", self.ubiquityContainerURL);
}

- (void)activatedUbiquityContainerURL {	FXDLog_DEFAULT;
#if TEST_infoDictionaryForFolderURL
	NSFileManager *fileManager = [NSFileManager defaultManager];

	FXDLog(@"\nubiquityContainerURL:\n%@", [fileManager infoDictionaryForFolderURL:self.ubiquityContainerURL]);
	FXDLog(@"\nappDirectory_Caches:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
	FXDLog(@"\nappDirectory_Document:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Document]);
#endif

#if shouldUseUbiquitousDocuments
	[self startObservingUbiquityMetadataQueryNotifications];

	//[self enumerateUbiquitousDocumentsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
	[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
#endif

#if shouldUseLocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif

	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
}

- (void)failedToUpdateUbiquityContainerURL {	FXDLog_DEFAULT;
	FXDAlertView *alertView = [[FXDAlertView alloc] initWithTitle:NSLocalizedString(alert_PleaseEnableiCloud, nil)
														  message:nil
														 delegate:nil
												cancelButtonTitle:NSLocalizedString(text_OK, nil)
												otherButtonTitles:nil];
	[alertView show];
	
#if shouldUseLocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:nil];
}

#pragma mark -
- (void)startObservingUbiquityMetadataQueryNotifications {	FXDLog_DEFAULT;
	
	if (self.ubiquitousDocumentsMetadataQuery.isStarted) {
		[self.ubiquitousDocumentsMetadataQuery enableUpdates];
	}
}

- (void)startWatchingLocalDirectoryChange {	FXDLog_DEFAULT;
	self.localDirectoryWatcher = [DirectoryWatcher watchFolderWithPath:appSearhPath_Document delegate:self];
	
}

#pragma mark -
- (void)setUbiquitousForLocalItemURLarray:(NSArray*)localItemURLarray atCurrentFolderURL:(NSURL*)currentFolderURL withSeparatorPathComponent:(NSString*)separatorPathComponent {	//FXDLog_DEFAULT;
		
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	for (NSURL *itemURL in localItemURLarray) {
		NSString *localItemPath = [itemURL lastPathComponent];
		/*
		NSString *localItemPath = [itemURL unicodeAbsoluteString];
		localItemPath = [[localItemPath componentsSeparatedByString:separatorPathComponent] lastObject];
		 */
		
		NSURL *destinationURL = currentFolderURL;
		
		if (localItemPath.length > 0) {
			destinationURL = [destinationURL URLByAppendingPathComponent:localItemPath];
		}

				
		NSError *error = nil;
				
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:itemURL destinationURL:destinationURL error:&error];FXDLog_ERRORexcept(516);
		
		if (error || didSetUbiquitous == NO) {			
			[self handleFailedLocalItemURL:itemURL withDestinationURL:destinationURL withResultError:error];
		}
	}
}

- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destinationURL withResultError:(NSError*)resultError {	//FXDLog_DEFAULT;
	
	//TODO: deal with following cases
	/*
	 domain: NSCocoaErrorDomain
	 code: 516
	 localizedDescription: The operation couldn’t be completed. (Cocoa error 516.)
	 userInfo: {
	 NSFilePath = "/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/EasyFileSharing_1.1_0710.pdf";
	 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
	 }
	 
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
	 
	 2012-08-16 10:35:19.251 EasyFileSharing[21409:15b03] [EFScontrolCaches addNewThumbImage:toCachedURL:]
	 localizedDescription: The operation couldn’t be completed. (LibrarianErrorDomain error 2 - Cannot enable syncing on a synced item.)
	 domain: LibrarianErrorDomain code: 2
	 userInfo:
	 {
	 NSDescription = "Cannot enable syncing on a synced item.";
	 }

	 */
	
	NSString *alertTitle = nil;
	
	if ([[resultError domain] isEqualToString:NSPOSIXErrorDomain]) {
		switch ([resultError code]) {
			case 63:	//The operation couldn’t be completed. File name too long
				break;
				
			default:
				break;
		}
	}
	else if ([[resultError domain] isEqualToString:NSCocoaErrorDomain]) {
		switch ([resultError code]) {				
			case 516:	{
				//"Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
				NSError *error = nil;
				[[NSFileManager defaultManager] removeItemAtURL:localItemURL error:&error];FXDLog_ERROR;
			}	break;
				
			default:
				alertTitle = [NSString stringWithFormat:@"%@\n%@", [resultError localizedDescription], localItemURL];
				break;
		}
	}
	
	if (alertTitle) {	FXDLog_DEFAULT;
		//TODO: should alert?
		FXDLog(@"title: %@", alertTitle);
	}
}

#pragma mark -
- (void)updateCollectedURLarrayWithMetadataItem:(NSMetadataItem*)metadataItem {
	BOOL isUploading  = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadingKey] boolValue];
	
	if (isUploading == NO) {
		return;
	}
	
	//FXDLog_DEFAULT;
	
	NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
	
	if (self.collectedURLarray == nil) {
		self.collectedURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		
		[self.collectedURLarray addObject:itemURL];
		
		return;
	}
	
	if ([self.collectedURLarray containsObject:itemURL] == NO) {
		[self.collectedURLarray addObject:itemURL];
	}
}

- (void)startEvictingCollectedURLarray {
	if ([self.collectedURLarray count] == 0) {
		self.collectedURLarray = nil;
		
		return;
	}
	
	[[NSOperationQueue new] addOperationWithBlock:^{	FXDLog_DEFAULT;
		for (NSURL *itemURL in self.collectedURLarray) {
			BOOL didEvict = [self evictUploadedUbiquitousItemURL:itemURL];
			
			if (didEvict) {
				CHECKPOINT(([NSString stringWithFormat:@"AUTO CLEANING didEvict: YES %@", [itemURL followingPathInDocuments]]));
				
				[self.collectedURLarray removeObject:itemURL];
			}
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if ([self.collectedURLarray count] == 0) {
				self.collectedURLarray = nil;
			}
		}];
	}];
}

- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL {
	BOOL didEvict = NO;
	
	NSError *error = nil;
	
	id isDirectory = nil;
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);
	
	if ([isDirectory boolValue]) {
		return didEvict;
	}
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:itemURL];
	
	if (isUbiquitousItem == NO) {
		return didEvict;
	}
	
	/*
	id isUploaded = nil;
	id isDownloaded = nil;
	
	[itemURL getResourceValue:&isUploaded forKey:NSURLUbiquitousItemIsUploadedKey error:&error];FXDLog_ERROR;
	[itemURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:&error];FXDLog_ERROR;
	 */
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		FXDWindow *applicationWindow = [FXDWindow applicationWindow];
		applicationWindow.progressView.labelMessage_1.text = [itemURL lastPathComponent];
	}];
	
	//if ([isUploaded boolValue] && [isDownloaded boolValue]) {
		/*
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			FXDWindow *applicationWindow = [FXDWindow applicationWindow];
			applicationWindow.progressView.labelMessage_1.text = [itemURL lastPathComponent];
		}];
		 */
		
		didEvict = [fileManager evictUbiquitousItemAtURL:itemURL error:&error];FXDLog_ERROR;
	//}
	
	//FXDLog(@"isUploaded: %d isDownloaded: %d didEvict: %d %@", [isUploaded boolValue], [isDownloaded boolValue], didEvict, [itemURL followingPathAfterPathComponent:pathcomponentDocuments]);
	//FXDLog(@"didEvict: %d %@", didEvict, [itemURL followingPathAfterPathComponent:pathcomponentDocuments]);
	
	return didEvict;
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_DEFAULT;

}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	//FXDLog_DEFAULT;
	
	if (self.didFinishFirstGathering == NO) {	//FXDLog_DEFAULT;
		//FXDLog(@"didFinishFirstGathering: %d", self.didFinishFirstGathering);

		//MARK: fix initial gathering performance issue
		
		//[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidUpdate object:notification.object userInfo:notification.userInfo];

#if ForDEVELOPER
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSMetadataQuery *metadataQuery = notification.object;

			NSArray *results = metadataQuery.results;
			NSURL *lastItemURL = [(NSMetadataItem*)[results lastObject] valueForAttribute:NSMetadataItemURLKey];

			FXDLog(@"metadataItem gathered : %d %@", metadataQuery.resultCount-1, [lastItemURL followingPathInDocuments]);
		});
#endif
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	self.didFinishFirstGathering = YES;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {
	NSMetadataQuery *metadataQuery = notification.object;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		BOOL isTransferring = [metadataQuery isQueryResultsTransferringWithLogString:nil];
		
		//TODO: distinguish uploading and downloading and finished updating
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if (isTransferring) {
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryIsTransferring object:notification.object userInfo:notification.userInfo];
			}
			else {	//FXDLog_OVERRIDE;
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidUpdate object:notification.object userInfo:notification.userInfo];
			}
		}];
	}];
}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher*)folderWatcher {	//FXDLog_DEFAULT;
	[self enumerateLocalDirectory];
}


@end
