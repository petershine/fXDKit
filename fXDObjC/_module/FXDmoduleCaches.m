

#import "FXDmoduleCaches.h"


@implementation FXDmoduleCaches

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMetadataQuery*)mainMetadataQuery {
	if (_mainMetadataQuery == nil) {
		_mainMetadataQuery = super.mainMetadataQuery;

		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
		_mainMetadataQuery.sortDescriptors = @[sortDescriptor];

		_mainMetadataQuery.searchScopes = @[NSMetadataQueryUbiquitousDataScope];
	}

	return _mainMetadataQuery;
}

#pragma mark - Method overriding

#pragma mark - Public
- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL {

	NSError *error = nil;

	id isDirectory = nil;
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
	FXDLog_ERROR_ignored(260);

	if ([isDirectory boolValue]) {
		return [self cachedFolderURLforFolderURL:itemURL];
	}


	NSURL *cachedFolderURL = [self cachedFolderURLforFolderURL:itemURL.URLByDeletingLastPathComponent];

	if (cachedFolderURL == nil) {
		return nil;
	}


	NSString *filePathComponent = itemURL.lastPathComponent;
	filePathComponent = [NSString stringWithFormat:@"%@%@", prefixCached, filePathComponent];

	NSURL *cachedURL = [cachedFolderURL URLByAppendingPathComponent:filePathComponent];

	return cachedURL;
}

- (NSURL*)itemURLforCachedURL:(NSURL*)cachedURL {

	NSError *error = nil;

	id isDirectory = nil;
	[cachedURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
	FXDLog_ERROR_ignored(260);
	
	if ([isDirectory boolValue]) {
		return [self folderURLforCachedFolderURL:cachedURL];
	}


	NSURL *folderURL = [self folderURLforCachedFolderURL:cachedURL.URLByDeletingLastPathComponent];

	if (folderURL == nil) {
		return nil;
	}


	NSString *filePathComponent = cachedURL.lastPathComponent;
	filePathComponent = [filePathComponent stringByReplacingOccurrencesOfString:prefixCached withString:@""];

	NSURL *itemURL = [folderURL URLByAppendingPathComponent:filePathComponent];

	return itemURL;
}

- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL {	FXDLog_OVERRIDE;
	return nil;
}

- (NSURL*)folderURLforCachedFolderURL:(NSURL*)cachedFolderURL {	FXDLog_OVERRIDE;	
	return nil;
}

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSData *imageData = UIImagePNGRepresentation(thumbImage);
	
	NSString *thumbItemPath = [appSearhPath_Caches stringByAppendingPathComponent:cachedURL.lastPathComponent];
	
	BOOL didCreate = [fileManager createFileAtPath:thumbItemPath contents:imageData attributes:nil];

	if (didCreate) {
		//EMPTY:
	}
	
	NSURL *thumbItemURL = [NSURL fileURLWithPath:thumbItemPath];
	

	NSError *error = nil;
	[fileManager createDirectoryAtURL:cachedURL.URLByDeletingLastPathComponent
		  withIntermediateDirectories:YES
						   attributes:nil
								error:&error];
	FXDLog_ERROR_ignored(516);

	error = nil;
	BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:thumbItemURL destinationURL:cachedURL error:&error];

	if (didSetUbiquitous == NO) {
		FXDLogBOOL(didSetUbiquitous);
	}

	if (error.code != 2 && error.code != 516) {
		FXDLog_ERROR;
	}
}

- (void)enumerateMetadataQueryResultsWithCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT

	NSOperationQueue *enumeratingQueue = [NSOperationQueue newSerialQueueWithName:NSStringFromSelector(_cmd)];

	[enumeratingQueue
	 addOperationWithBlock:^{

		 NSFileManager *fileManager = [NSFileManager defaultManager];

		 for (NSMetadataItem *metadataItem in self.mainMetadataQuery.results) {

			 NSURL *cachedURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];

			 NSURL *itemURL = [self itemURLforCachedURL:cachedURL];

			 NSError *error = nil;
			 BOOL isReachable = [itemURL checkResourceIsReachableAndReturnError:&error];
			 FXDLog_ERROR_ignored(260);

			 BOOL didStartDownloading = NO;
			 BOOL didRemove = NO;

			 if (isReachable == NO) {
				 NSError *error = nil;
				 didRemove = [fileManager removeItemAtURL:cachedURL error:&error];

				 if (didRemove == NO) {
					 FXDLogBOOL(didRemove);
				 }

				 if (error && error.code != 4 && error.code != 260) {
					 FXDLog_ERROR;
				 }


				 FXDLog(@"%@ %@ %@ %@ %@", _BOOL(didStartDownloading), _BOOL(isReachable), _Object([itemURL followingPathInDocuments]), _BOOL(didRemove), _Object([cachedURL followingPathAfterPathComponent:pathcomponentCaches]));
				 continue;
			 }


			 BOOL isDownloaded = NO;
			 BOOL isDownloading = NO;

			 id value = [metadataItem valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
			 isDownloaded = (value == NSMetadataUbiquitousItemDownloadingStatusDownloaded);
			 isDownloading = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];

			 if (isDownloaded == NO && isDownloading == NO) {
				 NSError *error = nil;
				 didStartDownloading = [fileManager startDownloadingUbiquitousItemAtURL:cachedURL error:&error];

				 if (didStartDownloading == NO) {
					 FXDLogBOOL(didStartDownloading);
				 }

				 FXDLog_ERROR;
			 }
		 }

		 [[NSOperationQueue currentQueue]
		  addOperationWithBlock:^{
			  if (callback) {
				  callback(_cmd, YES, nil);
			  }
		  }];
	 }];
}


@end
