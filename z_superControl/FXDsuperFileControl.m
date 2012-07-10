//
//  FXDsuperFileControl.m
//  PopTooUniversal
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
@synthesize ubiquityIdentityToken = _ubiquityIdentityToken;

@synthesize ubiquityContainerURL = _ubiquityContainerURL;
@synthesize ubiquityDocumentsURL = _ubiquityDocumentsURL;

@synthesize ubiquityMetadataQuery = _ubiquityMetadataQuery;

@synthesize directoryWatcher = _directoryWatcher;


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
		_ubiquityIdentityToken = nil;
		
		_ubiquityContainerURL = nil;
		_ubiquityDocumentsURL = nil;
		
		_ubiquityMetadataQuery = nil;
		
		_directoryWatcher = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSURL*)ubiquityDocumentsURL {
	if (_ubiquityDocumentsURL == nil) {
		if (self.ubiquityContainerURL) {
			_ubiquityDocumentsURL = [self.ubiquityContainerURL URLByAppendingPathComponent:@"Documents"];			
		}
	}
	
	return _ubiquityDocumentsURL;
}

#pragma mark -
- (NSMetadataQuery*)ubiquityMetadataQuery {
	if (_ubiquityMetadataQuery == nil) {
		_ubiquityMetadataQuery = [[NSMetadataQuery alloc] init];
	}
	
	return _ubiquityMetadataQuery;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperFileControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
	
    return _sharedInstance;
}

#pragma mark -
- (void)startCloudSynchronization {	FXDLog_DEFAULT;
	
	BOOL shouldRequestUbiquityContatinerURL = NO;
	
	if ([FXDsuperGlobalControl isOSversionNew]) {		
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(observedNSUbiquityIdentityDidChange:)
													 name:NSUbiquityIdentityDidChangeNotification
												   object:nil];
		
		self.ubiquityIdentityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
		FXDLog(@"ubiquityToken: %@", self.ubiquityIdentityToken);
		
		if (self.ubiquityIdentityToken) {
			shouldRequestUbiquityContatinerURL = YES;
		}
#endif
	}
	else {
		shouldRequestUbiquityContatinerURL = YES;
	}
	
	FXDLog(@"shouldRequestUbiquityContatinerURL: %@", shouldRequestUbiquityContatinerURL ? @"YES":@"NO");
	
	if (shouldRequestUbiquityContatinerURL) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSURL *ubiquityContainerURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			
			dispatch_async(dispatch_get_main_queue(), ^{	FXDLog_DEFAULT;
				self.ubiquityContainerURL = ubiquityContainerURL;
				
				FXDLog(@"ubiquityContainerURL: %@", self.ubiquityContainerURL);
				
#if DEBUG
				NSArray *directoryTree = [[NSFileManager defaultManager] directoryTreeForRootURL:self.ubiquityDocumentsURL];
				FXDLog(@"directoryTree count: %d", [directoryTree count]);
#endif
				
				[self startObservingUbiquityMetadataQueryNotifications];
				[self startObservingLocalDocumentDirectoryChange];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
			});
		});
	}
	else {
		//TODO: alert user about using iCloud;
		
		[self startObservingLocalDocumentDirectoryChange];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:nil];
	}
}

#pragma mark -
- (void)startObservingUbiquityMetadataQueryNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidStartGathering:)
						  name:NSMetadataQueryDidStartGatheringNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryGatheringProgress:)
						  name:NSMetadataQueryGatheringProgressNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidFinishGathering:)
						  name:NSMetadataQueryDidFinishGatheringNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidUpdate:)
						  name:NSMetadataQueryDidUpdateNotification
						object:nil];
	
	[self.ubiquityMetadataQuery applyDefaultConfiguration];
	
	[self.ubiquityMetadataQuery enableUpdates];
	
	BOOL didStart = [self.ubiquityMetadataQuery startQuery];
	
	if (didStart == NO) {
		//TODO: handle error
	}
}

- (void)startObservingLocalDocumentDirectoryChange {	FXDLog_DEFAULT;
	NSString *searchPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	self.directoryWatcher = [DirectoryWatcher watchFolderWithPath:searchPath delegate:self];
}

#pragma mark -
- (void)delayedUpdateUbiquityDocuments {	FXDLog_DEFAULT;
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:self.ubiquityDocumentsURL
															 includingPropertiesForKeys:nil
																				options:0
																		   errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
																			   FXDLog_ERROR;
																			   FXDLog(@"url: %@", url);
																			   
																			   return YES;
																		   }];
	NSURL *nextObject = [enumerator nextObject];
	
	NSUInteger currentLevel = 1;	//TODO: change level appropriately
	
	NSMutableArray *files = [[NSMutableArray alloc] initWithCapacity:0];
	
	while (nextObject) {
		//FXDLog(@"enumerator.level: %u", enumerator.level);
		
		if (enumerator.level == currentLevel) {
			[files addObject:nextObject];
		}
		
		nextObject = [enumerator nextObject];
	}
	
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	if (files && [files count] > 0) {
		[userInfo setObject:files forKey:@"ubiquitousFiles"];
	}
	
	if (userInfo && [userInfo count] > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityDocuments object:self userInfo:userInfo];
	}
}

- (void)delayedUpdateLocalDirectory {	FXDLog_DEFAULT;
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:applicationDocumentsDirectory
															 includingPropertiesForKeys:nil
																				options:0
																		   errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
																			   FXDLog_ERROR;
																			   FXDLog(@"url: %@", url);
																			   
																			   return YES;
																		   }];
	
	NSURL *nextObject = [enumerator nextObject];
	
	NSMutableArray *files = [[NSMutableArray alloc] initWithCapacity:0];
	
	while (nextObject) {
		id isUbiquitousItem = nil;
		
		[nextObject getResourceValue:&isUbiquitousItem forKey:NSURLIsUbiquitousItemKey error:nil];
		
		if ([isUbiquitousItem boolValue] == NO) {
			[files addObject:nextObject];
		}
		
		nextObject = [enumerator nextObject];
	}
	
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	if (files && [files count] > 0) {
		[self setUbiquitousForLocalFiles:files];
		
		[userInfo setObject:files forKey:@"localFiles"];
	}
	
	if (userInfo && [userInfo count] > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateLocalDirectory object:self userInfo:userInfo];
	}
}

#pragma mark -
- (void)setUbiquitousForLocalFiles:(NSArray*)localFiles {	FXDLog_DEFAULT;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	FXDLog(@"ubiquityDocumentsURL: %@", self.ubiquityDocumentsURL);
	
	for (NSURL *localfileURL in localFiles) {
		//Use default /Documents path in iCloud
		
		NSString *localfilePath = [[[localfileURL absoluteString] componentsSeparatedByString:@"Documents/"] lastObject];
		
		NSURL *destinationURL = [self.ubiquityDocumentsURL URLByAppendingPathComponent:localfilePath];
				
		NSError *error = nil;
		
		BOOL didSetUbiquitous = [fileManager setUbiquitous:YES itemAtURL:localfileURL destinationURL:destinationURL error:&error];
		
		if (error) {
			FXDLog_ERROR;
			
			//TODO: deal with following cases
			/*
			 domain: NSCocoaErrorDomain
			 code: 516
			 localizedDescription: The operation couldn’t be completed. (Cocoa error 516.)
			 userInfo: {
			 NSFilePath = "/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/EasyFileSharing_1.1_0710.pdf";
			 NSUnderlyingError = "Error Domain=NSPOSIXErrorDomain Code=17 \"The operation couldn\U2019t be completed. File exists\"";
			 }
			 
			 domain: NSPOSIXErrorDomain
			 code: 63
			 localizedDescription: The operation couldn’t be completed. File name too long
			 userInfo: {
			 NSDescription = "Unable to lstat destination path '/private/var/mobile/Library/Mobile Documents/EHB284SWG9~kr~co~ensight~EasyFileSharing/Documents/%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%90%E1%85%B3%20%E1%84%8C%E1%85%A5%E1%86%A8%E1%84%85%E1%85%B5%E1%86%B8%20%E1%84%8F%E1%85%AE%E1%84%91%E1%85%A9%E1%86%AB%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%E1%84%83%E1%85%A2%E1%84%8C%E1%85%A1%E1%86%BC.xls'.";
			 }

			 */
			
			
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
																message:nil
															   delegate:nil
													  cancelButtonTitle:text_OK
													  otherButtonTitles:nil];
			[alertView show];
		}
		
		if (didSetUbiquitous) {
			id isUploaded = nil;
			
			[localfileURL getResourceValue:&isUploaded forKey:NSURLUbiquitousItemIsDownloadedKey error:nil];
			
			FXDLog(@"didSetUbiquitous: %@ isUploaded: %@", didSetUbiquitous ? @"YES":@"NO", [isUploaded boolValue] ? @"YES":@"NO");
		}
		else {
			FXDLog(@"didSetUbiquitous: %@", didSetUbiquitous ? @"YES":@"NO");
		}
	}
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;

}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_OVERRIDE;
	NSMetadataQuery *metadataQuery = notification.object;
	
	for (NSMetadataItem *metadataItem in [metadataQuery results]) {
		FXDLog(@"\nvalues:\n%@", [metadataItem valuesForAttributes:[metadataItem attributes]]);
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateUbiquityDocuments) object:nil];
	
	NSTimeInterval delay = [metadataQuery notificationBatchingInterval] *3;
	[self performSelector:@selector(delayedUpdateUbiquityDocuments) withObject:nil afterDelay:delay];
}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher*)folderWatcher {	FXDLog_DEFAULT;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateLocalDirectory) object:nil];
	[self performSelector:@selector(delayedUpdateLocalDirectory) withObject:nil afterDelay:2];
}


@end
