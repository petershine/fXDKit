//
//  FXDsuperCloudManager.m
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCloudManager.h"


#pragma mark - Public implementation
@implementation FXDsuperCloudManager


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
+ (FXDsuperCloudManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
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

- (NSMetadataQuery*)ubiquitousDocumentsMetadataQuery {
	if (_ubiquitousDocumentsMetadataQuery == nil) {	FXDLog_DEFAULT;
		_ubiquitousDocumentsMetadataQuery = [[NSMetadataQuery alloc] init];


		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidStartGathering:)
		 name:NSMetadataQueryDidStartGatheringNotification
		 object:_ubiquitousDocumentsMetadataQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryGatheringProgress:)
		 name:NSMetadataQueryGatheringProgressNotification
		 object:_ubiquitousDocumentsMetadataQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidFinishGathering:)
		 name:NSMetadataQueryDidFinishGatheringNotification
		 object:_ubiquitousDocumentsMetadataQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidUpdate:)
		 name:NSMetadataQueryDidUpdateNotification
		 object:_ubiquitousDocumentsMetadataQuery];


		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
		[_ubiquitousDocumentsMetadataQuery setPredicate:predicate];

		/*
		 NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
		 //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSCreationDateKey ascending:NO];
		 [_ubiquitousDocumentsMetadataQuery setSortDescriptors:@[sortDescriptor]];
		 */

		[_ubiquitousDocumentsMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
		//[_ubiquitousDocumentsMetadataQuery setNotificationBatchingInterval:delayHalfSecond];

#if ForDEVELOPER
		BOOL didStart = [_ubiquitousDocumentsMetadataQuery startQuery];
		FXDLog(@"didStart: %d", didStart);
#else
		[_ubiquitousDocumentsMetadataQuery startQuery];
#endif
	}

	return _ubiquitousDocumentsMetadataQuery;
}

- (NSOperationQueue*)evictingQueue {
	if (_evictingQueue == nil) {
		_evictingQueue = [[NSOperationQueue alloc] init];
		[_evictingQueue setMaxConcurrentOperationCount:1];
	}

	return _evictingQueue;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startUpdatingUbiquityContainerURL {	FXDLog_DEFAULT;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	BOOL shouldRequestUbiquityContatinerURL = NO;
	
	if (SYSTEM_VERSION_lowerThan(iosVersion6)) {
		shouldRequestUbiquityContatinerURL = YES;
	}
	else {
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(observedNSUbiquityIdentityDidChange:)
		 name:NSUbiquityIdentityDidChangeNotification
		 object:nil];
		
		self.ubiquityIdentityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
		FXDLog(@"ubiquityToken: %@", self.ubiquityIdentityToken);
		
		id updatedIdentityTokenData = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:userdefaultObjSavedUbiquityIdentityToken]];
		FXDLog(@"savedTokenData: %@", updatedIdentityTokenData);
		
		FXDLog(@"self.ubiquityIdentityToken isEqual:updatedIdentityTokenData: %d", [self.ubiquityIdentityToken isEqual:updatedIdentityTokenData]);
		
		
		//TODO: learn about how to handle ubiquityIdentityToken changed
		if (self.ubiquityIdentityToken) {
			shouldRequestUbiquityContatinerURL = YES;
			
			if (updatedIdentityTokenData == nil) {
				updatedIdentityTokenData = [NSKeyedArchiver archivedDataWithRootObject:self.ubiquityIdentityToken];
				
				if (updatedIdentityTokenData) {
					[userDefaults setObject:updatedIdentityTokenData forKey:userdefaultObjSavedUbiquityIdentityToken];
				}
			}
		}
		else {
			[userDefaults removeObjectForKey:userdefaultObjSavedUbiquityIdentityToken];
		}
	}
	
	FXDLog(@"shouldRequestUbiquityContatinerURL: %d", shouldRequestUbiquityContatinerURL);

	if (shouldRequestUbiquityContatinerURL == NO) {
		[userDefaults synchronize];

		[self failedToUpdateUbiquityContainerURL];

		return;
	}


	[self evaluateSavedUbiquityContainerURL];

	[[NSOperationQueue new] addOperationWithBlock:^{
		NSURL *activeUbiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
		FXDLog(@"activeUbiquityContainerURL: %@", activeUbiquityContainerURL);

		[[NSOperationQueue mainQueue] addOperationWithBlock:^{

			if (activeUbiquityContainerURL) {
				if (self.ubiquityContainerURL) {
					if ([[activeUbiquityContainerURL absoluteString] isEqualToString:[self.ubiquityContainerURL absoluteString]] == NO) {

						//TODO: find what to do when containerURL is different
					}
				}


				_ubiquitousDocumentsURL = nil;
				_ubiquitousCachesURL = nil;

				_ubiquityContainerURL = activeUbiquityContainerURL;


				NSString *containerURLString = [self.ubiquityContainerURL absoluteString];

				if (containerURLString) {
					[userDefaults setObject:containerURLString forKey:userdefaultStringSavedUbiquityContainerURL];
					[userDefaults synchronize];
				}

				[self activatedUbiquityContainerURL];
			}
			else {
				[userDefaults synchronize];

				[self failedToUpdateUbiquityContainerURL];
			}
		}];
	}];
}

- (void)evaluateSavedUbiquityContainerURL {	FXDLog_DEFAULT;
	NSURL *savedUbiquityContainerURL = nil;

	NSString *containerURLstring = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultStringSavedUbiquityContainerURL];

	if (containerURLstring) {
		savedUbiquityContainerURL = [NSURL URLWithString:containerURLstring];
	}

	FXDLog(@"savedUbiquityContainerURL: %@", savedUbiquityContainerURL);

	if (savedUbiquityContainerURL) {
		_ubiquitousDocumentsURL = nil;
		_ubiquitousCachesURL = nil;
		
		_ubiquityContainerURL = savedUbiquityContainerURL;

		//[self activatedUbiquityContainerURL];

		/*
		[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
		[self enumerateUbiquitousDocumentsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
		 */
	}

	//FXDLog(@"ubiquityContainerURL: %@", self.ubiquityContainerURL);
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

	[self enumerateUbiquitousDocumentsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
	[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:self.ubiquitousDocumentsURL];
#endif


#if shouldUseLocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif

	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
}

- (void)failedToUpdateUbiquityContainerURL {	FXDLog_DEFAULT;
	FXDAlertView *alertView = [[FXDAlertView alloc]
							   initWithTitle:NSLocalizedString(alert_PleaseEnableiCloud, nil)
							   message:nil
							   delegate:nil
							   cancelButtonTitle:NSLocalizedString(text_OK, nil)
							   otherButtonTitles:nil];
	[alertView show];
	
#if shouldUseLocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL object:nil];
}

- (void)startObservingUbiquityMetadataQueryNotifications {	FXDLog_DEFAULT;
	
	if (self.ubiquitousDocumentsMetadataQuery.isStarted) {
		//
	}
}

- (void)startWatchingLocalDirectoryChange {	FXDLog_DEFAULT;
	self.localDirectoryWatcher = [DirectoryWatcher watchFolderWithPath:appSearhPath_Document delegate:self];
	
}

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
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:itemURL destinationURL:destinationURL error:&error];
		
		if (error || didSetUbiquitous == NO) {			
			[self handleFailedLocalItemURL:itemURL withDestinationURL:destinationURL withResultError:error];
		}
	}
}

- (void)handleFailedLocalItemURL:(NSURL*)localItemURL withDestinationURL:(NSURL*)destinationURL withResultError:(NSError*)resultError {	//FXDLog_DEFAULT;
	
	/*
	 domain: NSCocoaErrorDomain
	 code: 516
	 localizedDescription: The operation couldn’t be completed. (Cocoa error 516.)
	 userInfo: {
	 NSFilePath = "/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~fXceed~EasyFileSharing/Documents/EasyFileSharing_1.1_0710.pdf";
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
	 NSDescription = "Unable to rename '/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG' to '/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~fXceed~EasyFileSharing/Documents/file://localhost/var/mobile/Applications/DB25E1BE-9D05-4613-88D1-3C79C9AA2F19/Library/Caches/IMG_1349.JPG'.";
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
		FXDLog(@"alertTitle: %@", alertTitle);
	}
}

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
	
	[self.evictingQueue addOperationWithBlock:^{	FXDLog_DEFAULT;
		for (NSURL *itemURL in self.collectedURLarray) {
			BOOL didEvict = [self evictUploadedUbiquitousItemURL:itemURL];
			
			if (didEvict) {
				FXDLog(@"AUTO CLEANING didEvict: YES %@", [itemURL followingPathInDocuments]);
				
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
	
	id isDirectory = nil;

	NSError *error = nil;
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

		error = nil;
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

		[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerMetadataQueryDidGatherObjects object:notification.object userInfo:notification.userInfo];
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	self.didFinishFirstGathering = YES;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerMetadataQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {
	
	NSMetadataQuery *metadataQuery = notification.object;
	
	[[NSOperationQueue new] addOperationWithBlock:^{

		BOOL isTransferring = [metadataQuery isQueryResultsTransferringWithLogString:nil];
		

		//TODO: distinguish uploading and downloading and finished updating		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if (isTransferring) {
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerMetadataQueryIsTransferring object:notification.object userInfo:notification.userInfo];
			}
			else {	//FXDLog_OVERRIDE;
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerMetadataQueryDidUpdate object:notification.object userInfo:notification.userInfo];
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