//
//  FXDsuperCachesManager.m
//
//
//  Created by petershine on 8/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCachesManager.h"


#pragma mark - Public implementation
@implementation FXDsuperCachesManager


#pragma mark - Memory management

#pragma mark - Initialization
+ (FXDsuperCachesManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (NSMetadataQuery*)ubiquitousCachesMetadataQuery {
	
	if (_ubiquitousCachesMetadataQuery == nil) {	FXDLog_DEFAULT;
		_ubiquitousCachesMetadataQuery = [NSMetadataQuery new];

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
		[_ubiquitousCachesMetadataQuery setPredicate:predicate];

		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
		//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSCreationDateKey ascending:NO];
		[_ubiquitousCachesMetadataQuery setSortDescriptors:@[sortDescriptor]];

		[_ubiquitousCachesMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDataScope]];
		//[_ubiquitousCachesMetadataQuery setNotificationBatchingInterval:delayHalfSecond];

		
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedCachesMetadataQueryGatheringProgress:)
		 name:NSMetadataQueryGatheringProgressNotification
		 object:_ubiquitousCachesMetadataQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedCachesMetadataQueryDidFinishGathering:)
		 name:NSMetadataQueryDidFinishGatheringNotification
		 object:_ubiquitousCachesMetadataQuery];
		
		[notificationCenter
		 addObserver:self
		 selector:@selector(observedCachesMetadataQueryDidUpdate:)
		 name:NSMetadataQueryDidUpdateNotification
		 object:_ubiquitousCachesMetadataQuery];
		
#if ForDEVELOPER
		BOOL didStart = [_ubiquitousCachesMetadataQuery startQuery];
		FXDLogBOOL(didStart);
#else
		[_ubiquitousCachesMetadataQuery startQuery];
#endif
	}

	return _ubiquitousCachesMetadataQuery;
}


#pragma mark - Method overriding

#pragma mark - Public
- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL {
	NSURL *cachedURL = nil;

	
	id isDirectory = nil;

	NSError *error = nil;
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR_ignored(260);

	
	if ([isDirectory boolValue]) {
		cachedURL = [self cachedFolderURLforFolderURL:itemURL];
	}
	else {
		NSURL *cachedFolderURL = [self cachedFolderURLforFolderURL:[itemURL URLByDeletingLastPathComponent]];
		
		if (cachedFolderURL) {
			NSString *filePathComponent = [itemURL lastPathComponent];
			filePathComponent = [NSString stringWithFormat:@"%@%@", prefixCached, filePathComponent];
			
			cachedURL = [cachedFolderURL URLByAppendingPathComponent:filePathComponent];
		}
	}
	
	return cachedURL;
}

- (NSURL*)itemURLforCachedURL:(NSURL*)cachedURL {
	NSURL *itemURL = nil;
	
	
	id isDirectory = nil;

	NSError *error = nil;
	[cachedURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];
	FXDLog_ERROR_ignored(260);
	
	
	if ([isDirectory boolValue]) {
		itemURL = [self folderURLforCachedFolderURL:cachedURL];
	}
	else {
		NSURL *folderURL = [self folderURLforCachedFolderURL:[cachedURL URLByDeletingLastPathComponent]];
		
		if (folderURL) {
			NSString *filePathComponent = [cachedURL lastPathComponent];
			filePathComponent = [filePathComponent stringByReplacingOccurrencesOfString:prefixCached withString:@""];
			
			itemURL = [folderURL URLByAppendingPathComponent:filePathComponent];
		}
	}
	
	return itemURL;
}

- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL {	FXDLog_OVERRIDE;
	NSURL *cachedFolderURL = nil;
	
	return cachedFolderURL;
}

- (NSURL*)folderURLforCachedFolderURL:(NSURL*)cachedFolderURL {	FXDLog_OVERRIDE;
	NSURL *folderURL = nil;
	
	return folderURL;
}

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSData *imageData = UIImagePNGRepresentation(thumbImage);
	
	NSString *thumbItemPath = [appSearhPath_Caches stringByAppendingPathComponent:[cachedURL lastPathComponent]];
	
	BOOL didCreate = [fileManager createFileAtPath:thumbItemPath contents:imageData attributes:nil];

	if (didCreate) {
		//TODO:
	}
	
	NSURL *thumbItemURL = [NSURL fileURLWithPath:thumbItemPath];
	


	NSError *error = nil;
	[fileManager createDirectoryAtURL:[cachedURL URLByDeletingLastPathComponent]
		  withIntermediateDirectories:YES
						   attributes:nil
								error:&error];FXDLog_ERROR_ignored(516);

	error = nil;
	BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:thumbItemURL destinationURL:cachedURL error:&error];

	if (didSetUbiquitous == NO) {
		FXDLogBOOL(didSetUbiquitous);
	}

	if ([error code] != 2 && [error code] != 516) {
		FXDLog_ERROR;
	}
}

- (void)enumerateCachesMetadataQueryResults {
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
		 NSString *alertTitle = nil;
		 
		 NSFileManager *fileManager = [NSFileManager defaultManager];

		 for (NSMetadataItem *metadataItem in self.ubiquitousCachesMetadataQuery.results) {

			 NSError *error = nil;
			 
			 NSURL *cachedURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
			 
			 NSURL *itemURL = [self itemURLforCachedURL:cachedURL];
			 
			 BOOL isReachable = [itemURL checkResourceIsReachableAndReturnError:&error];FXDLog_ERROR_ignored(260);
			 
#if ForDEVELOPER
			 BOOL didStartDownloading = NO;
			 BOOL didRemove = NO;
#endif
			 
			 if (isReachable == NO) {
#if ForDEVELOPER
				 didRemove = [fileManager removeItemAtURL:cachedURL error:&error];
#else
				 [fileManager removeItemAtURL:cachedURL error:&error];
#endif
				 
				 if (error && [error code] != 4 && [error code] != 260) {
					 FXDLog_ERROR;
				 }
				 
#if ForDEVELOPER
				 FXDLog(@"%@ %@ %@ %@ %@", _BOOL(didStartDownloading), _BOOL(isReachable), _Object([itemURL followingPathInDocuments]), _BOOL(didRemove), _Object([cachedURL followingPathAfterPathComponent:pathcomponentCaches]));
#endif
				 continue;
			 }
			 
			 
			 BOOL isDownloaded = NO;
			 BOOL isDownloading = NO;
			 
			 id value = [metadataItem valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
			 isDownloaded = (value == NSMetadataUbiquitousItemDownloadingStatusDownloaded);
			 isDownloading = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];

			 if (isDownloaded == NO && isDownloading == NO) {
#if ForDEVELOPER
				 didStartDownloading = [fileManager startDownloadingUbiquitousItemAtURL:cachedURL error:&error];
#else
				 [fileManager startDownloadingUbiquitousItemAtURL:cachedURL error:&error];
#endif
				 
				 if ([error code] == 512) {
					 if (alertTitle == nil) {
						 NSError *underlyingError = ([([error userInfo])[@"NSUnderlyingError"] userInfo])[@"NSUnderlyingError"];
						 
						 if (underlyingError) {
							 NSDictionary *userInfo = [underlyingError userInfo];
							 
							 alertTitle = userInfo[@"NSDescription"];
						 }
					 }
				 }
				 else {
					 FXDLog_ERROR;
				 }
			 }
		 }
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  NSMutableDictionary *userInfo = nil;
			  
			  if (alertTitle) {
				  userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
				  userInfo[@"alertTitle"] = alertTitle;
			  }
			  
			  [[NSNotificationCenter defaultCenter]
			   postNotificationName:notificationCachesControlDidEnumerateCachesMetadataQueryResults
			   object:nil
			   userInfo:userInfo];
		  }];
	 }];
}


//MARK: - Observer implementation
- (void)observedCachesMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_DEFAULT;
}

- (void)observedCachesMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self enumerateCachesMetadataQueryResults];
}

- (void)observedCachesMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 BOOL isTransferring = [self.ubiquitousCachesMetadataQuery isQueryResultsTransferringWithLogString:nil];
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  if (isTransferring == NO) {
				  [self enumerateCachesMetadataQueryResults];
			  }
		  }];
	 }];
}

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation FXDsuperCachesManager (Added)
@end
