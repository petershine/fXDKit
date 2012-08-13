//
//  FXDsuperCachesControl.m
//  EasyFileSharing
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
	if (_ubiquitousCachesMetadataQuery == nil) {	//FXDLog_DEFAULT;
		_ubiquitousCachesMetadataQuery = [[NSMetadataQuery alloc] init];
		
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		
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
		
		[_ubiquitousCachesMetadataQuery setNotificationBatchingInterval:1.0];
		
		
		[_ubiquitousCachesMetadataQuery enableUpdates];
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
- (UIImage*)thumbImageForItemURL:(NSURL*)itemURL forDimension:(CGFloat)thumbnailDimension {
	
	UIImage *thumbImage = nil;
	
	NSURL *cachedURL = [[FXDsuperCachesControl sharedInstance] cachedURLForItemURL:itemURL];
	
	
	thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:cachedURL]];
	
	if (thumbImage) {
		return thumbImage;
	}
	
	
	UIImage *originalImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:itemURL]];
	
	if (originalImage == nil) {
		FXDLog(@"originalImage: %@ %@", originalImage, [itemURL lastPathComponent]);
		
		return thumbImage;
	}
	
	
	thumbImage = [originalImage thumbImageUsingThumbDimension:thumbnailDimension];
	
	if (thumbImage) {
		[self addNewThumbImage:thumbImage toCachedURL:cachedURL];
	}
	
	return thumbImage;
}

#pragma mark -
- (NSURL*)cachedURLForItemURL:(NSURL*)itemURL {
	NSURL *cachedURL = nil;
	
	EFScontrolFile *fileControl = [EFScontrolFile sharedInstance];
	
	if (fileControl.ubiquitousCachesURL == nil) {
		return cachedURL;
	}
	
	
	NSString *relativePath = [[[itemURL absoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject];
	
	NSString *filePathComponent = [relativePath lastPathComponent];
	filePathComponent = [NSString stringWithFormat:@".cached_%@", filePathComponent];
	
	NSMutableArray *pathComponents = [[NSMutableArray alloc] initWithArray:[relativePath pathComponents]];
	[pathComponents replaceObjectAtIndex:[pathComponents count]-1 withObject:filePathComponent];
	
	cachedURL = [fileControl.ubiquitousCachesURL URLByAppendingPathComponent:[NSString pathWithComponents:pathComponents]];
	
	return cachedURL;
}

- (void)addNewThumbImage:(UIImage*)thumbImage toCachedURL:(NSURL*)cachedURL {	FXDLog_DEFAULT;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSData *imageData = UIImagePNGRepresentation(thumbImage);
	
	NSString *thumbItemPath = [appSearhPath_Caches stringByAppendingPathComponent:[cachedURL lastPathComponent]];
	
	BOOL didCreate = [fileManager createFileAtPath:thumbItemPath contents:imageData attributes:nil];
	
	NSURL *thumbItemURL = [NSURL URLWithString:thumbItemPath];
	
	
	NSError *error = nil;
	
	[fileManager createDirectoryAtURL:[cachedURL URLByDeletingLastPathComponent]
									withIntermediateDirectories:YES
													 attributes:nil
														  error:&error];
	FXDLog_ERROR;
	
	
	BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:thumbItemURL destinationURL:cachedURL error:&error];
	FXDLog_ERROR;
	
	
	[cachedURL setResourceValue:@(YES) forKey:NSURLIsHiddenKey error:&error];
	FXDLog_ERROR;
	
	
	FXDLog(@"didCreate: %d didSetUbiquitous: %d %@", didCreate, didSetUbiquitous, [cachedURL lastPathComponent]);
}

#pragma mark -
- (void)manageCachedURLarrayWithItemURLarray:(NSArray*)itemURLarray forItemActionType:(ITEM_ACTION_TYPE)itemActionType fromCurrentFolderURL:(NSURL*)currentFolderURL toDestinationFolderURL:(NSURL*)destinationFolderURL {	FXDLog_DEFAULT;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	for (NSURL *itemURL in itemURLarray) {
		
	}
}

#pragma mark -
- (void)enumerateCachesMetadataQueryResults {
	__block NSArray *results = self.ubiquitousCachesMetadataQuery.results;
	
	[[NSOperationQueue new] addOperationWithBlock:^{	FXDLog_DEFAULT;
		
		for (NSMetadataItem *metadataItem in results) {
			BOOL isDownloading = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];
			BOOL isDownloaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey] boolValue];
			
			if (isDownloading == NO && isDownloaded) {
				NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
				
				NSError *error = nil;
				BOOL didStartDownloading = [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:itemURL error:&error];
				FXDLog_ERROR;
				
				FXDLog(@"didStartDownloading: %d %@", didStartDownloading, [itemURL lastPathComponent]);
			}
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationCachesControlDidEnumerateCachesMetadataQueryResults object:nil userInfo:nil];
		}];
	}];
}


//MARK: - Observer implementation
- (void)observedCachesMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_DEFAULT;
	[self enumerateCachesMetadataQueryResults];
}

- (void)observedCachesMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT;
	BOOL didLogTransferring = [self.ubiquitousCachesMetadataQuery logQueryResultsWithTransferringPercentage];
	
	if (didLogTransferring == NO) {
		[self enumerateCachesMetadataQueryResults];
	}
}

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation FXDsuperCachesControl (Added)
@end
