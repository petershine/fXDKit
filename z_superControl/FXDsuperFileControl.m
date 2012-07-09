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
		
		_ubiquityMetadataQuery = nil;
		
		_directoryWatcher = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
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
				
				[self startObservingUbiquityMetadataQueryNotifications];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidUpdateUbiquityContainerURL object:self.ubiquityContainerURL];
			});
		});
	}
	else {
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
}

- (void)startObservingLocalDocumentDirectoryChange {	FXDLog_DEFAULT;
	NSString *searchPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	self.directoryWatcher = [DirectoryWatcher watchFolderWithPath:searchPath delegate:self];
}

#pragma mark -
- (void)configureMetadataQuery:(NSMetadataQuery*)metadataQuery {	FXDLog_DEFAULT;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <= %@", NSMetadataItemFSContentChangeDateKey, [NSDate date]];
	[metadataQuery setPredicate:predicate];
	
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:0];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
	[sortDescriptors addObject:descriptor];
	[metadataQuery setSortDescriptors:sortDescriptors];
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
	
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification: %@", notification);
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification: %@", notification);
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification: %@", notification);
	
	NSMetadataQuery *metadataQuery = notification.object;
	
	FXDLog(@"searchScopes: %@", [metadataQuery searchScopes]);
	FXDLog(@"valueListAttributes: %@", [metadataQuery valueListAttributes]);
	FXDLog(@"groupingAttributes: %@", [metadataQuery groupingAttributes]);
	
	FXDLog(@"resultCount: %u", [metadataQuery resultCount]);
	FXDLog(@"results:\n%@", [metadataQuery results]);
	
	FXDLog(@"valueLists:\n%@", [metadataQuery valueLists]);
	FXDLog(@"groupedResults:\n%@", [metadataQuery groupedResults]);
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification: %@", notification);

}


//MARK: - Delegate implementation
#pragma mark - NSMetadataQueryDelegate

#pragma mark - DirectoryWatcherDelegate
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher {	FXDLog_DEFAULT;
	NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	
	FXDLog(@"applicationDocumentsDirectory: %@", applicationDocumentsDirectory);
	
	NSArray *directoryTree = [[NSFileManager defaultManager] directoryTreeForRootURL:applicationDocumentsDirectory];
	FXDLog(@"directoryTree count: %d", [directoryTree count]);
}


@end
