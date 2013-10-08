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

#pragma mark - Initialization
+ (FXDsuperCloudManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (NSURL*)ubiquitousDocumentsURL {
	
	if (_ubiquitousDocumentsURL == nil) {	FXDLog_DEFAULT;
		if (self.ubiquityContainerURL) {
			_ubiquitousDocumentsURL = [self.ubiquityContainerURL URLByAppendingPathComponent:pathcomponentDocuments];
		}
		
		FXDLog(@"_ubiquitousDocumentsURL: %@", _ubiquitousDocumentsURL);
	}

	return _ubiquitousDocumentsURL;
}

- (NSURL*)ubiquitousCachesURL {
	
	if (_ubiquitousCachesURL == nil) {	FXDLog_DEFAULT;
		if (self.ubiquityContainerURL) {
			_ubiquitousCachesURL = [self.ubiquityContainerURL URLByAppendingPathComponent:pathcomponentCaches];
		}
		
		FXDLog(@"_ubiquitousCachesURL: %@", _ubiquitousCachesURL);
	}

	return _ubiquitousCachesURL;
}

- (NSMetadataQuery*)cloudDocumentsQuery {
	
	if (_cloudDocumentsQuery == nil) {	FXDLog_DEFAULT;
		_cloudDocumentsQuery = [[NSMetadataQuery alloc] init];

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
		[_cloudDocumentsQuery setPredicate:predicate];

		/*
		 NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
		 //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSCreationDateKey ascending:NO];
		 [_cloudDocumentsQuery setSortDescriptors:@[sortDescriptor]];
		 */

		[_cloudDocumentsQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
		//[_cloudDocumentsQuery setNotificationBatchingInterval:delayHalfSecond];
		
		
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidStartGathering:)
		 name:NSMetadataQueryDidStartGatheringNotification
		 object:_cloudDocumentsQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryGatheringProgress:)
		 name:NSMetadataQueryGatheringProgressNotification
		 object:_cloudDocumentsQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidFinishGathering:)
		 name:NSMetadataQueryDidFinishGatheringNotification
		 object:_cloudDocumentsQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedNSMetadataQueryDidUpdate:)
		 name:NSMetadataQueryDidUpdateNotification
		 object:_cloudDocumentsQuery];

		BOOL didStart = [_cloudDocumentsQuery startQuery];
		FXDLog(@"didStart: %d", didStart);
		
		if (didStart) {}
	}

	return _cloudDocumentsQuery;
}

- (NSOperationQueue*)evictingQueue {
	
	if (_evictingQueue == nil) {	FXDLog_DEFAULT;
		_evictingQueue = [[NSOperationQueue alloc] init];
		[_evictingQueue setMaxConcurrentOperationCount:limitConcurrentOperationCount];
	}

	return _evictingQueue;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startUpdatingUbiquityContainerURLwithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;

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
		FXDLog(@"ubiquityIdentityToken: %@", self.ubiquityIdentityToken);
		
		id updatedIdentityTokenData = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:userdefaultObjSavedUbiquityIdentityToken]];
		FXDLog(@"updatedIdentityTokenData: %@", updatedIdentityTokenData);
		
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
	
	[userDefaults synchronize];
	
	
	FXDLog(@"shouldRequestUbiquityContatinerURL: %d", shouldRequestUbiquityContatinerURL);

	if (shouldRequestUbiquityContatinerURL == NO) {
		[self failedToUpdateUbiquityContainerURLwithDidFinishBlock:didFinishBlock];

		return;
	}


	NSURL *savedContainerURL = nil;
	
	NSString *containerURLstring = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultStringSavedUbiquityContainerURL];
	
	if (containerURLstring) {
		savedContainerURL = [NSURL URLWithString:containerURLstring];
	}
	
	FXDLog(@"savedContainerURL: %@", savedContainerURL);
	
	if (savedContainerURL) {
		_ubiquitousDocumentsURL = nil;
		_ubiquitousCachesURL = nil;
		
		self.ubiquityContainerURL = savedContainerURL;
	}
	
	FXDLog(@"self.ubiquityContainerURL: %@", self.ubiquityContainerURL);
	
	
	__block NSURL *activeUbiquityContainerURL = nil;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 
		 activeUbiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
		 FXDLog(@"activeUbiquityContainerURL: %@", activeUbiquityContainerURL);
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  
			  if (activeUbiquityContainerURL) {
				  if (self.ubiquityContainerURL) {
					  if ([[activeUbiquityContainerURL absoluteString] isEqualToString:[self.ubiquityContainerURL absoluteString]] == NO) {
						  
						  //TODO: find what to do when containerURL is different
					  }
				  }
				  
				  
				  _ubiquitousDocumentsURL = nil;
				  _ubiquitousCachesURL = nil;
				  
				  self.ubiquityContainerURL = activeUbiquityContainerURL;
				  
				  
				  NSString *containerURLString = [self.ubiquityContainerURL absoluteString];
				  
				  if (containerURLString) {
					  [userDefaults setObject:containerURLString forKey:userdefaultStringSavedUbiquityContainerURL];
				  }
				  [userDefaults synchronize];
				  
				  [self activatedUbiquityContainerURLwithDidFinishBlock:didFinishBlock];
			  }
			  else {
				  [userDefaults synchronize];
				  
				  [self failedToUpdateUbiquityContainerURLwithDidFinishBlock:didFinishBlock];
			  }
		  }];
	 }];
}

- (void)activatedUbiquityContainerURLwithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
#if ForDEVELOPER
	NSFileManager *fileManager = [NSFileManager defaultManager];
	FXDLog(@"\nubiquityContainerURL:\n%@", [fileManager infoDictionaryForFolderURL:self.ubiquityContainerURL]);
	FXDLog(@"\nappDirectory_Caches:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
	FXDLog(@"\nappDirectory_Document:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Document]);
#endif
	
	[self startObservingCloudDocumentsQueryNotifications];

	
#if USE_UbiquitousDocuments
	[self enumerateUbiquitousMetadataItemsAtFolderURL:nil withDidEnumerateBlock:nil];
	[self enumerateUbiquitousDocumentsAtFolderURL:nil withDidEnumerateBlock:nil];
#endif

#if USE_LocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
	
	if (didFinishBlock) {
		didFinishBlock(YES);
	}
}

- (void)failedToUpdateUbiquityContainerURLwithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
	[FXDAlertView
	 showAlertWithTitle:NSLocalizedString(alert_PleaseEnableiCloud, nil)
	 message:nil
	 clickedButtonAtIndexBlock:nil
	 cancelButtonTitle:nil];

#if USE_LocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif
	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL object:nil];
	
	if (didFinishBlock) {
		didFinishBlock(NO);
	}
}

#pragma mark -
- (void)startObservingCloudDocumentsQueryNotifications {	FXDLog_DEFAULT;
	
	if (self.cloudDocumentsQuery.isStarted) {
		//TODO:
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
		
		if ([localItemPath length] > 0) {
			destinationURL = [destinationURL URLByAppendingPathComponent:localItemPath];
		}


		NSError *error = nil;
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:itemURL destinationURL:destinationURL error:&error];
		
		FXDLog(@"didSetUbiquitous: %d %@ %@", didSetUbiquitous, itemURL, destinationURL);
		
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
	
	[self.evictingQueue
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
		 for (NSURL *itemURL in self.collectedURLarray) {
			 BOOL didEvict = [self evictUploadedUbiquitousItemURL:itemURL];
			 
			 if (didEvict) {
				 FXDLog(@"AUTO CLEANING didEvict: YES %@", [itemURL followingPathInDocuments]);
				 
				 [self.collectedURLarray removeObject:itemURL];
			 }
		 }
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
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
	
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
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

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"didFinishFirstGathering: %d", self.didFinishFirstGathering);
	
	if (self.didFinishFirstGathering == NO) {
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudDocumentsQueryDidGatherObjects object:notification.object userInfo:notification.userInfo];
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"1.didFinishFirstGathering: %d", self.didFinishFirstGathering);
	self.didFinishFirstGathering = YES;
	FXDLog(@"2.didFinishFirstGathering: %d", self.didFinishFirstGathering);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudDocumentsQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT;
	
	NSMetadataQuery *metadataQuery = notification.object;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 
		 BOOL isTransferring = [metadataQuery isQueryResultsTransferringWithLogString:nil];
		 FXDLog(@"isTransferring: %d", isTransferring);
		 
		 //TODO: distinguish uploading and downloading and finished updating
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  if (isTransferring) {
				  FXDLog(@"SHOULD OBSERVE: %@", notificationCloudDocumentsQueryIsTransferring);
				  
				  [[NSNotificationCenter defaultCenter]
				   postNotificationName:notificationCloudDocumentsQueryIsTransferring
				   object:notification.object
				   userInfo:notification.userInfo];
			  }
			  else {
				  FXDLog(@"SHOULD OBSERVE: %@", notificationCloudDocumentsQueryDidUpdate);
				  
				  [[NSNotificationCenter defaultCenter]
				   postNotificationName:notificationCloudDocumentsQueryDidUpdate
				   object:notification.object
				   userInfo:notification.userInfo];
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
