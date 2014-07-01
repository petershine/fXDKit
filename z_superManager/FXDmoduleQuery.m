//
//  FXDmoduleQuery.m
//
//
//  Created by petershine on 7/1/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDmoduleQuery.h"


@implementation FXDmoduleQuery

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMetadataQuery*)cloudDocumentsQuery {

	if (_cloudDocumentsQuery == nil) {	FXDLog_DEFAULT;
		_cloudDocumentsQuery = [[NSMetadataQuery alloc] init];

		//MARK: For all files
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];
		[_cloudDocumentsQuery setPredicate:predicate];

		/*
		 NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
		 //NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSCreationDateKey ascending:NO];
		 [_cloudDocumentsQuery setSortDescriptors:@[sortDescriptor]];
		 */

		[_cloudDocumentsQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
		//[_cloudDocumentsQuery setNotificationBatchingInterval:delayHalfSecond];
	}

	return _cloudDocumentsQuery;
}

- (FXDOperationQueue*)evictingQueue {
	if (_evictingQueue == nil) {	FXDLog_DEFAULT;
		_evictingQueue = [[FXDOperationQueue alloc] init];
		[_evictingQueue setMaxConcurrentOperationCount:limitConcurrentOperationCount];
	}

	return _evictingQueue;
}

#pragma mark -
- (void)startObservingCloudDocumentsQueryNotifications {	FXDLog_DEFAULT;

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidStartGathering:)
	 name:NSMetadataQueryDidStartGatheringNotification
	 object:self.cloudDocumentsQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryGatheringProgress:)
	 name:NSMetadataQueryGatheringProgressNotification
	 object:self.cloudDocumentsQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidFinishGathering:)
	 name:NSMetadataQueryDidFinishGatheringNotification
	 object:self.cloudDocumentsQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidUpdate:)
	 name:NSMetadataQueryDidUpdateNotification
	 object:self.cloudDocumentsQuery];

	BOOL didStart = [_cloudDocumentsQuery startQuery];
	FXDLogBOOL(didStart);

	if (didStart) {}

	if (self.cloudDocumentsQuery.isStarted) {
		//TODO:
	}
}

#pragma mark -
- (void)enumerateMetadataItemsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	if (folderURL == nil) {
		NSAssert1(folderURL, @"MUST NOT be nil: %@", _Object(folderURL));
		return;
	}


	[self.cloudDocumentsQuery disableUpdates];

	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 NSMutableDictionary *metadataItemArray = [[NSMutableDictionary alloc] initWithCapacity:0];

		 NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];

		 NSString *alertTitle = nil;

		 for (NSUInteger i = 0; i < [self.cloudDocumentsQuery resultCount]; i++) {
			 NSMetadataItem *metadataItem = [self.cloudDocumentsQuery resultAtIndex:i];

			 NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];


			 id parentDirectoryURL = nil;

			 NSError *error = nil;
			 [itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			 FXDLog_ERROR_ignored(260);

			 if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[folderURL absoluteString]]) {

				 id isHidden = nil;

				 NSError *error = nil;
				 [itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
				 FXDLog_ERROR_ignored(260);

				 if ([isHidden boolValue] == NO) {
					 metadataItemArray[[itemURL absoluteString]] = metadataItem;

					 [self updateCollectedURLarrayWithMetadataItem:metadataItem];
				 }
			 }
		 }

		 userInfo[objkeyUbiquitousMetadataItems] = metadataItemArray;

		 if (alertTitle) {
			 userInfo[@"alertTitle"] = alertTitle;
		 }

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  [self.cloudDocumentsQuery enableUpdates];

			  FXDLog(@"userInfo: %@", userInfo);

			  if (callback) {
				  callback(_cmd, YES, userInfo);
			  }
		  }];
	 }];
}

- (void)enumerateDocumentsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	if (folderURL == nil) {
		NSAssert1(folderURL, @"MUST NOT be nil: %@", _Object(folderURL));
		return;
	}


	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 NSMutableArray *subfolderURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		 NSMutableArray *fileURLarray = [[NSMutableArray alloc] initWithCapacity:0];

		 NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];


		 NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] limitedEnumeratorForRootURL:folderURL];

		 NSURL *nextURL = [enumerator nextObject];

		 while (nextURL) {
			 id isDirectory = nil;

			 NSError *error = nil;
			 [nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
			 FXDLog_ERROR_ignored(260);

			 if ([isDirectory boolValue]) {
				 [subfolderURLarray addObject:nextURL];
			 }
			 else {
				 [fileURLarray addObject:nextURL];
			 }

			 nextURL = [enumerator nextObject];
		 }

		 userInfo[objkeyUbiquitousFolders] = subfolderURLarray;
		 userInfo[objkeyUbiquitousFiles] = fileURLarray;

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{

			  FXDLog(@"userInfo: %@", userInfo);

			  if (callback) {
				  callback(_cmd, YES, userInfo);
			  }
		  }];
	 }];
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

		 [[NSOperationQueue currentQueue]
		  addOperationWithBlock:^{
			  if ([self.collectedURLarray count] == 0) {
				  self.collectedURLarray = nil;
			  }
		  }];
	 }];
}

- (BOOL)evictUploadedUbiquitousItemURL:(NSURL*)itemURL {

	NSError *error = nil;

	id isDirectory = nil;
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR_ignored(260);

	if ([isDirectory boolValue]) {
		return NO;
	}


	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:itemURL];

	if (isUbiquitousItem == NO) {
		return NO;
	}


	error = nil;

	id isUploaded = nil;
	[itemURL getResourceValue:&isUploaded forKey:NSURLUbiquitousItemIsUploadedKey error:&error];FXDLog_ERROR;

	if ([isUploaded boolValue] == NO) {
		return NO;
	}


	error = nil;

	id downloadingStatus = nil;
	[itemURL getResourceValue:&downloadingStatus forKey:NSURLUbiquitousItemDownloadingStatusKey error:&error];FXDLog_ERROR;

	if ([[downloadingStatus stringValue] isEqualToString:NSURLUbiquitousItemDownloadingStatusNotDownloaded]) {
		return NO;
	}


	error = nil;

	BOOL didEvict = [fileManager evictUbiquitousItemAtURL:itemURL error:&error];FXDLog_ERROR;
	FXDLog(@"%@ %@ %@", _BOOL([isUploaded boolValue]), _Object(downloadingStatus), _BOOL(didEvict));

	return didEvict;
}


//MARK: - Observer implementation
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_DEFAULT;

}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogBOOL(self.didFinishFirstGathering);

	if (self.didFinishFirstGathering == NO) {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:notificationCloudDocumentsQueryDidGatherObjects
		 object:notification.object
		 userInfo:notification.userInfo];
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"1.%@", _BOOL(self.didFinishFirstGathering));
	self.didFinishFirstGathering = YES;
	FXDLog(@"2.%@", _BOOL(self.didFinishFirstGathering));

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:notificationCloudDocumentsQueryDidFinishGathering
	 object:notification.object
	 userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT;

	NSMetadataQuery *metadataQuery = notification.object;

	[[NSOperationQueue new]
	 addOperationWithBlock:^{

		 BOOL isTransferring = [metadataQuery isQueryResultsTransferring];
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

@end
