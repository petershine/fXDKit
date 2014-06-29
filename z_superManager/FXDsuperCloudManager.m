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
		
		FXDLogObject(_ubiquitousDocumentsURL);
	}

	return _ubiquitousDocumentsURL;
}

- (NSURL*)ubiquitousCachesURL {
	
	if (_ubiquitousCachesURL == nil) {	FXDLog_DEFAULT;
		if (self.ubiquityContainerURL) {
			_ubiquitousCachesURL = [self.ubiquityContainerURL URLByAppendingPathComponent:pathcomponentCaches];
		}
		
		FXDLogObject(_ubiquitousCachesURL);
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
		FXDLogBOOL(didStart);
		
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
- (void)startUpdatingUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedNSUbiquityIdentityDidChange:)
	 name:NSUbiquityIdentityDidChangeNotification
	 object:nil];


	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	self.ubiquityIdentityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
	FXDLogObject(self.ubiquityIdentityToken);

	id updatedIdentityTokenData = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:userdefaultObjSavedUbiquityIdentityToken]];
	FXDLogObject(updatedIdentityTokenData);

	FXDLogBOOL([self.ubiquityIdentityToken isEqual:updatedIdentityTokenData]);


	//TODO: learn about how to handle ubiquityIdentityToken changed

	BOOL shouldRequestUbiquityContatinerURL = NO;

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

	[userDefaults synchronize];


	FXDLogBOOL(shouldRequestUbiquityContatinerURL);

	if (shouldRequestUbiquityContatinerURL == NO) {
		[self failedToUpdateUbiquityContainerURLwithFinishCallback:finishCallback];
		return;
	}


	NSURL *savedContainerURL = nil;
	
	NSString *containerURLstring = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultStringSavedUbiquityContainerURL];
	
	if (containerURLstring) {
		savedContainerURL = [NSURL URLWithString:containerURLstring];
	}
	
	FXDLogObject(savedContainerURL);
	
	if (savedContainerURL) {
		_ubiquitousDocumentsURL = nil;
		_ubiquitousCachesURL = nil;
		
		self.ubiquityContainerURL = savedContainerURL;
	}
	
	FXDLogObject(self.ubiquityContainerURL);
	
	
	__block NSURL *activeUbiquityContainerURL = nil;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 
		 activeUbiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
		 FXDLogObject(activeUbiquityContainerURL);
		 
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
				  
				  [self activatedUbiquityContainerURLwithFinishCallback:finishCallback];
			  }
			  else {
				  [userDefaults synchronize];
				  
				  [self failedToUpdateUbiquityContainerURLwithFinishCallback:finishCallback];
			  }
		  }];
	 }];
}

- (void)activatedUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
#if ForDEVELOPER
	NSFileManager *fileManager = [NSFileManager defaultManager];
	FXDLogObject([fileManager infoDictionaryForFolderURL:self.ubiquityContainerURL]);
	FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
	FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Document]);
#endif
	
	[self startObservingCloudDocumentsQueryNotifications];

	
#if USE_UbiquitousDocuments
	[self enumerateUbiquitousMetadataItemsAtFolderURL:nil withDidEnumerateBlock:nil];
	[self enumerateUbiquitousDocumentsAtFolderURL:nil withDidEnumerateBlock:nil];
#endif


	[[NSNotificationCenter defaultCenter]
	 postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL
	 object:self.ubiquityContainerURL];
	
	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
}

- (void)failedToUpdateUbiquityContainerURLwithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	[FXDAlertView
	 showAlertWithTitle:NSLocalizedString(@"Please enable iCloud", nil)
	 message:nil
	 cancelButtonTitle:nil
	 withAlertCallback:nil];


	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidUpdateUbiquityContainerURL object:nil];
	
	if (finishCallback) {
		finishCallback(_cmd, NO, nil);
	}
}

#pragma mark -
- (void)startObservingCloudDocumentsQueryNotifications {	FXDLog_DEFAULT;
	
	if (self.cloudDocumentsQuery.isStarted) {
		//TODO:
	}
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
		
		FXDLog(@"%@ %@ %@", _BOOL(didSetUbiquitous), _Object(itemURL), _Object(destinationURL));
		
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
		FXDLogObject(alertTitle);
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
				 FXDLog(@"AUTO CLEANING %@ %@", _BOOL(didEvict), _Object([itemURL followingPathInDocuments]));
				 
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
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
	FXDLog_ERROR_ignored(260);
	
	if ([isDirectory boolValue]) {
		return didEvict;
	}
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:itemURL];
	
	if (isUbiquitousItem == NO) {
		return didEvict;
	}

#warning //TODO: Implement progress reporting
	/*
	id isUploaded = nil;
	id isDownloaded = nil;
	
	[itemURL getResourceValue:&isUploaded forKey:NSURLUbiquitousItemIsUploadedKey error:&error];FXDLog_ERROR;
	[itemURL getResourceValue:&isDownloaded forKey:NSURLUbiquitousItemIsDownloadedKey error:&error];FXDLog_ERROR;
	 */

	/*
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 FXDWindow *applicationWindow = (FXDWindow*)[UIApplication mainWindow];
		 applicationWindow.progressView.labelMessage_1.text = [itemURL lastPathComponent];
	 }];
	 */
	
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
	FXDLogObject(notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_DEFAULT;

}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogBOOL(self.didFinishFirstGathering);
	
	if (self.didFinishFirstGathering == NO) {
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudDocumentsQueryDidGatherObjects object:notification.object userInfo:notification.userInfo];
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"1.%@", _BOOL(self.didFinishFirstGathering));
	self.didFinishFirstGathering = YES;
	FXDLog(@"2.%@", _BOOL(self.didFinishFirstGathering));
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudDocumentsQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT;
	
	NSMetadataQuery *metadataQuery = notification.object;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 
		 BOOL isTransferring = [metadataQuery isQueryResultsTransferringWithLogString:nil];
		 FXDLogBOOL(isTransferring);
		 
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


@end
