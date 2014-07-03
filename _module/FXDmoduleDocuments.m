

#import "FXDmoduleDocuments.h"

@implementation FXDinfoEnumerated
- (NSString*)description {
	return [NSString stringWithFormat:@"%@ %@", _Object(_folderURLarray), _Object(_fileURLarray)];
}
@end


@implementation FXDmoduleDocuments

#pragma mark - Memory management
- (void)dealloc {
	[_evictingQueue resetOperationQueueAndDictionary:nil];
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMetadataQuery*)mainMetadataQuery {
	if (_mainMetadataQuery == nil) {
		_mainMetadataQuery = [super mainMetadataQuery];

		[_mainMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
	}

	return _mainMetadataQuery;
}

#pragma mark -
- (NSOperationQueue*)evictingQueue {
	if (_evictingQueue == nil) {	FXDLog_DEFAULT;
		_evictingQueue = [NSOperationQueue newSerialQueue];
	}

	return _evictingQueue;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)enumerateMetadataItemsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	if (folderURL == nil) {
		NSAssert1(folderURL, @"MUST NOT be nil: %@", _Object(folderURL));
		return;
	}


	[self.mainMetadataQuery disableUpdates];

	__block NSMutableArray *itemURLarray = [[NSMutableArray alloc] initWithCapacity:0];

	[[NSOperationQueue new]
	 addOperationWithBlock:^{

		 for (NSUInteger idx = 0; idx < [self.mainMetadataQuery resultCount]; idx++) {
			 NSMetadataItem *metadataItem = [self.mainMetadataQuery resultAtIndex:idx];

			 NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];

			 NSError *error = nil;

			 id parentDirectoryURL = nil;
			 [itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			 FXDLog_ERROR_ignored(260);

			 if (parentDirectoryURL == nil
				 || [[parentDirectoryURL absoluteString] isEqualToString:[folderURL absoluteString]] == NO) {
				 continue;
			 }


			 error = nil;

			 id isHidden = nil;
			 [itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
			 FXDLog_ERROR_ignored(260);

			 //MARK: Why hidden is evaluated? Possible to exclude system files like .DS~
			 if ([isHidden boolValue] == NO) {
				 if (itemURL) {
					 [itemURLarray addObject:itemURL];
				 }
			 }
		 }

		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  [self.mainMetadataQuery enableUpdates];

			  FXDLogObject(itemURLarray);

			  if (callback) {
				  callback(_cmd, YES, (itemURLarray.count > 0 ? [itemURLarray copy]:nil));
			  }
		  }];
	 }];
}

- (void)enumerateDocumentsAtFolderURL:(NSURL*)folderURL withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	if (folderURL == nil) {
		NSAssert1(folderURL, @"MUST NOT be nil: %@", _Object(folderURL));
		return;
	}

	
	__block NSMutableArray *folderURLarray = [[NSMutableArray alloc] initWithCapacity:0];
	__block NSMutableArray *fileURLarray = [[NSMutableArray alloc] initWithCapacity:0];

	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] limitedEnumeratorForRootURL:folderURL];

		 NSURL *nextURL = [enumerator nextObject];

		 while (nextURL) {
			 id isDirectory = nil;

			 NSError *error = nil;
			 [nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
			 FXDLog_ERROR_ignored(260);

			 if ([isDirectory boolValue]) {
				 [folderURLarray addObject:nextURL];
			 }
			 else {
				 [fileURLarray addObject:nextURL];
			 }

			 nextURL = [enumerator nextObject];
		 }


		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  FXDinfoEnumerated *enumeratedInfo = [[FXDinfoEnumerated alloc] init];
			  enumeratedInfo.folderURLarray = [folderURLarray copy];
			  enumeratedInfo.fileURLarray = [fileURLarray copy];

			  FXDLogObject(enumeratedInfo);

			  if (callback) {
				  callback(_cmd, YES, enumeratedInfo);
			  }
		  }];
	 }];
}

#pragma mark -
- (void)startEvictingURLarray:(NSArray*)URLarray {

	if (URLarray.count == 0) {
		return;
	}


	NSArray *copiedURLarray = [URLarray copy];

	[self.evictingQueue
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
		 for (NSURL *itemURL in copiedURLarray) {
			 BOOL didEvict = [self evictUploadedUbiquitousItemURL:itemURL];

			 if (didEvict) {
				 FXDLog(@"%@ %@", _BOOL(didEvict), _Object([itemURL followingPathInDocuments]));
			 }
		 }
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


#pragma mark - Observer

@end
