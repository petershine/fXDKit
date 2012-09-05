//
//  FXDsuperCachesControl.m

//
//  Created by petershine on 8/13/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperCachesControl.h"


#pragma mark - Private interface
@interface FXDsuperCachesControl (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperCachesControl

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
- (NSMetadataQuery*)ubiquitousCachesMetadataQuery {
	if (_ubiquitousCachesMetadataQuery == nil) {	FXDLog_DEFAULT;
		_ubiquitousCachesMetadataQuery = [[NSMetadataQuery alloc] init];
		
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedCachesMetadataQueryGatheringProgress:)
							  name:NSMetadataQueryGatheringProgressNotification
							object:_ubiquitousCachesMetadataQuery];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedCachesMetadataQueryDidFinishGathering:)
							  name:NSMetadataQueryDidFinishGatheringNotification
							object:_ubiquitousCachesMetadataQuery];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedCachesMetadataQueryDidUpdate:)
							  name:NSMetadataQueryDidUpdateNotification
							object:_ubiquitousCachesMetadataQuery];
		
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
		[_ubiquitousCachesMetadataQuery setPredicate:predicate];
		
		[_ubiquitousCachesMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDataScope]];
		
		[_ubiquitousCachesMetadataQuery setNotificationBatchingInterval:0.5];
		
		BOOL didStart = [_ubiquitousCachesMetadataQuery startQuery];
		FXDLog(@"didStart: %d", didStart);
	}
	
	return _ubiquitousCachesMetadataQuery;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCachesControl*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}

#pragma mark -
- (NSURL*)cachedURLforItemURL:(NSURL*)itemURL {
	NSURL *cachedURL = nil;
	
	NSError *error = nil;
	
	id isDirectory = nil;
	[itemURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);

	
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
	
	NSError *error = nil;
	
	id isDirectory = nil;
	[cachedURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);
	
	
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

#pragma mark -
- (NSURL*)cachedFolderURLforFolderURL:(NSURL*)folderURL {
	NSURL *cachedFolderURL = nil;
	
	EFScontrolFile *fileControl = [EFScontrolFile sharedInstance];
	
	if (fileControl.ubiquitousCachesURL == nil) {
		return cachedFolderURL;
	}
	
	
	cachedFolderURL = fileControl.ubiquitousCachesURL;
	
	NSString *relativePath = [[[folderURL unicodeAbsoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject];
	
	if (relativePath.length > 0) {
		cachedFolderURL = [cachedFolderURL URLByAppendingPathComponent:relativePath];
	}
	
	return cachedFolderURL;
}

- (NSURL*)folderURLforCachedFolderURL:(NSURL*)cachedFolderURL {
	NSURL *folderURL = nil;
	
	EFScontrolFile *fileControl = [EFScontrolFile sharedInstance];
	
	if (fileControl.ubiquitousDocumentsURL == nil) {
		return folderURL;
	}
	
	
	folderURL = fileControl.ubiquitousDocumentsURL;
				 
	NSString *relativePath = [[[cachedFolderURL unicodeAbsoluteString] componentsSeparatedByString:pathcomponentCaches] lastObject];
	
	if (relativePath.length > 0) {
		folderURL = [folderURL URLByAppendingPathComponent:relativePath];
	}
	
	return folderURL;
}

#pragma mark -
- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL {	//FXDLog_DEFAULT;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSData *imageData = UIImagePNGRepresentation(thumbImage);
	
	NSString *thumbItemPath = [appSearhPath_Caches stringByAppendingPathComponent:[cachedURL lastPathComponent]];
	
	BOOL didCreate = [fileManager createFileAtPath:thumbItemPath contents:imageData attributes:nil];
	
	NSURL *thumbItemURL = [NSURL fileURLWithPath:thumbItemPath];
	
	
	NSError *error = nil;
	
	[fileManager createDirectoryAtURL:[cachedURL URLByDeletingLastPathComponent]
									withIntermediateDirectories:YES
													 attributes:nil
														  error:&error];FXDLog_ERRORexcept(516);

	
	BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:thumbItemURL destinationURL:cachedURL error:&error];FXDLog_ERRORexcept(2);
		
	//FXDLog(@"didCreate: %d didSetUbiquitous: %d %@", didCreate, didSetUbiquitous, [cachedURL followingPathAfterPathComponent:pathcomponentCaches]);
}

#pragma mark -
- (void)enumerateCachesMetadataQueryResults {
	
	[[NSOperationQueue new] addOperationWithBlock:^{	FXDLog_DEFAULT;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		for (NSMetadataItem *metadataItem in self.ubiquitousCachesMetadataQuery.results) {
			NSError *error = nil;
			
			NSURL *cachedURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
		
			NSURL *itemURL = [self itemURLforCachedURL:cachedURL];
			
			BOOL isReachable = [itemURL checkResourceIsReachableAndReturnError:&error];FXDLog_ERRORexcept(260);
			
			
			BOOL didStartDownloading = NO;
			BOOL didRemove = NO;
			
			if (isReachable) {
				BOOL isDownloaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey] boolValue];
				
				if (isDownloaded == NO) {
					didStartDownloading = [fileManager startDownloadingUbiquitousItemAtURL:cachedURL error:&error];FXDLog_ERROR;
				}
			}
			else {
				didRemove = [fileManager removeItemAtURL:cachedURL error:&error];
				
				if (error && error.code != 4 && error.code != 260) {
					FXDLog_ERROR;
				}
				
				//FXDLog(@"didStartDownloading: %d isReachable: %d %@ didRemove: %d %@", didStartDownloading, isReachable, [itemURL followingPathInDocuments], didRemove, [cachedURL followingPathAfterPathComponent:pathcomponentCaches]);
			}
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationCachesControlDidEnumerateCachesMetadataQueryResults object:nil userInfo:nil];
		}];
	}];
}


//MARK: - Observer implementation
- (void)observedCachesMetadataQueryGatheringProgress:(NSNotification*)notification {
	//
}

- (void)observedCachesMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_DEFAULT;
	[self enumerateCachesMetadataQueryResults];
}

- (void)observedCachesMetadataQueryDidUpdate:(NSNotification*)notification {	//FXDLog_DEFAULT;
	[[NSOperationQueue new] addOperationWithBlock:^{
		BOOL isTransferring = [self.ubiquitousCachesMetadataQuery isQueryResultsTransferringWithLogString:nil];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if (isTransferring == NO) {
				[self enumerateCachesMetadataQueryResults];
			}
		}];
	}];
}

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation FXDsuperCachesControl (Added)
@end
