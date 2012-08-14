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
- (NSMutableSet*)queuedURLset {
	if (_queuedURLset == nil) {
		_queuedURLset =[[NSMutableSet alloc] initWithCapacity:0];
	}
	
	return _queuedURLset;
}

- (NSOperationQueue*)operationQueue {
	if (_operationQueue == nil) {
		_operationQueue = [[NSOperationQueue alloc] init];
	}
	
	return _operationQueue;
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
	
	__block FXDsuperFileControl *fileControl = self;
	
	if (shouldRequestUbiquityContatinerURL) {
		[[NSOperationQueue new] addOperationWithBlock:^{
			fileControl.ubiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			FXDLog(@"ubiquityContainerURL: %@", fileControl.ubiquityContainerURL);
			
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				if (fileControl.ubiquityContainerURL) {
#if TEST_infoDictionaryForFolderURL
					NSFileManager *fileManager = [NSFileManager defaultManager];
					
					FXDLog(@"\nubiquityContainerURL:\n%@", [fileManager infoDictionaryForFolderURL:fileControl.ubiquityContainerURL]);
					FXDLog(@"\nappDirectory_Document:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Document]);
					FXDLog(@"\nappDirectory_Caches:\n%@", [fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
#endif

					
#if shouldUseUbiquitousDocuments
					[fileControl startObservingUbiquityMetadataQueryNotifications];
#endif
					
#if shouldUseLocalDirectoryWatcher
					[fileControl startWatchingLocalDirectoryChange];
#endif
					[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
				}
				else {
					[fileControl failedToUpdateUbiquityContainerURL];
				}
			}];
		}];
	}
	else {
		[fileControl failedToUpdateUbiquityContainerURL];
	}
}

- (void)failedToUpdateUbiquityContainerURL {	FXDLog_DEFAULT;
	FXDAlertView *alertView = [[FXDAlertView alloc] initWithTitle:NSLocalizedString(@"alert_PleaseEnableiCloud", nil)
														  message:nil
														 delegate:nil
												cancelButtonTitle:text_OK
												otherButtonTitles:nil];
	[alertView show];
	
#if shouldUseLocalDirectoryWatcher
	[self startWatchingLocalDirectoryChange];
#endif
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:nil];
}

#pragma mark -
- (void)startObservingUbiquityMetadataQueryNotifications {	FXDLog_DEFAULT;
	self.ubiquitousDocumentsMetadataQuery = [[NSMetadataQuery alloc] init];
	
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidStartGathering:)
						  name:NSMetadataQueryDidStartGatheringNotification
						object:self.ubiquitousDocumentsMetadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryGatheringProgress:)
						  name:NSMetadataQueryGatheringProgressNotification
						object:self.ubiquitousDocumentsMetadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidFinishGathering:)
						  name:NSMetadataQueryDidFinishGatheringNotification
						object:self.ubiquitousDocumentsMetadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidUpdate:)
						  name:NSMetadataQueryDidUpdateNotification
						object:self.ubiquitousDocumentsMetadataQuery];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
	[self.ubiquitousDocumentsMetadataQuery setPredicate:predicate];
	
	[self.ubiquitousDocumentsMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
	[self.ubiquitousDocumentsMetadataQuery setNotificationBatchingInterval:0.1];
	
	
	[self.ubiquitousDocumentsMetadataQuery enableUpdates];
	
	BOOL didStart = [self.ubiquitousDocumentsMetadataQuery startQuery];
	
	if (didStart == NO) {
		//TODO: handle error
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
		NSString *localItemPath = [itemURL unicodeAbsoluteString];
		localItemPath = [[localItemPath componentsSeparatedByString:separatorPathComponent] lastObject];
		
		NSURL *destinationURL = [currentFolderURL URLByAppendingPathComponent:localItemPath];	//Use iCloud /Documents
				
		NSError *error = nil;
				
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:itemURL destinationURL:destinationURL error:&error];FXDLog_ERROR;
		
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
	 */
	
	NSString *title = nil;
	
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
				title = [NSString stringWithFormat:@"%@\n%@", [resultError localizedDescription], localItemURL];
				break;
		}
	}
	
	if (title) {	FXDLog_DEFAULT;
		//TODO: should alert?
		FXDLog(@"title: %@", title);
	}
}

#pragma mark -
- (void)evictAllUbiquitousDocuments {	FXDLog_DEFAULT;
	__block FXDsuperFileControl *fileControl = self;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] fullEnumeratorForRootURL:self.ubiquitousDocumentsURL];
		
		NSURL *nextURL = [enumerator nextObject];
		
		while (nextURL) {
			
			BOOL isUbiquitousItem = [[NSFileManager defaultManager] isUbiquitousItemAtURL:nextURL];
			
			if (isUbiquitousItem) {
				[fileControl evictUbiquitousItemURLarray:@[nextURL]];
			}
			
			nextURL = [enumerator nextObject];
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEvictAllUbiquitousDocuments object:fileControl userInfo:nil];
		}];
	}];
}

- (void)evictUbiquitousItemURLarray:(NSArray *)itemURLarray {
#if ForDEVELOPER
	if ([itemURLarray count] > 1) {
		FXDLog_DEFAULT;
	}
#endif
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	for (NSURL *itemURL in itemURLarray) {
		BOOL didEvict = [fileManager evictUbiquitousItemAtURL:itemURL error:&error];FXDLog_ERROR;
		
		FXDLog(@"didEvict: %d %@", didEvict, itemURL);
	}
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_DEFAULT;
	
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	//FXDLog_DEFAULT;
#if DEBUG
	NSMetadataQuery *metadataQuery = notification.object;
	
	NSArray *results = metadataQuery.results;
	NSURL *lastItemURL = [(NSMetadataItem*)[results lastObject] valueForAttribute:NSMetadataItemURLKey];
	
	FXDLog(@"documents: %d %@", metadataQuery.resultCount-1, [[[lastItemURL unicodeAbsoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject]);
#endif
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	//FXDLog_OVERRIDE;
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidFinishGathering object:notification.object userInfo:notification.userInfo];
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {
	NSMetadataQuery *metadataQuery = notification.object;
	
	BOOL didLogTransferring = [metadataQuery logQueryResultsWithTransferringPercentage];
	
	//TODO: distinguish uploading and downloading and finished updating
	
	if (didLogTransferring) {		
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryIsTransferring object:notification.object userInfo:notification.userInfo];
	}
	else {	//FXDLog_OVERRIDE;
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlMetadataQueryDidUpdate object:notification.object userInfo:notification.userInfo];
	}
}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher*)folderWatcher {	//FXDLog_DEFAULT;
	[self enumerateLocalDirectory];
}


@end
