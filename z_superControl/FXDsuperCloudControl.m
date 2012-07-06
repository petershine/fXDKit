//
//  FXDsuperCloudControl.m
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCloudControl.h"


#pragma mark - Private interface
@interface FXDsuperCloudControl (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperCloudControl

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
		_ubiquityToken = nil;
		_ubiquityURL = nil;
		
		_metadataQuery = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSMetadataQuery*)metadataQuery {
	if (_metadataQuery == nil) {
		_metadataQuery = [[NSMetadataQuery alloc] init];
	}
	
	return _metadataQuery;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCloudControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
	
    return _sharedInstance;
}

#pragma mark -
- (void)startCloudSynchronization {	FXDLog_DEFAULT;
	
	BOOL shouldRequestURLforUbiquityContatiner = NO;
	
	if ([FXDsuperGlobalControl isOSversionNew]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observedNSUbiquityIdentityDidChange:) name:NSUbiquityIdentityDidChangeNotification object:nil];
		
		self.ubiquityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
		FXDLog(@"ubiquityToken: %@", self.ubiquityToken);
		
		if (self.ubiquityToken) {
			shouldRequestURLforUbiquityContatiner = YES;
		}
	}
	else {
		shouldRequestURLforUbiquityContatiner = YES;
	}
	
	FXDLog(@"shouldRequestURLforUbiquityContatiner: %@", shouldRequestURLforUbiquityContatiner ? @"YES":@"NO");
	
	if (shouldRequestURLforUbiquityContatiner) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			
			dispatch_async(dispatch_get_main_queue(), ^{	FXDLog_DEFAULT;
				self.ubiquityURL = ubiquityURL;
				
				FXDLog(@"ubiquityURL: %@", self.ubiquityURL);
				
				[self startObservingMetadataQueryNotifications];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudControlDidUpdateUbiquityURL object:self.ubiquityURL];
			});
		});
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudControlDidUpdateUbiquityURL object:nil];
	}
}

#pragma mark -
- (void)startObservingMetadataQueryNotifications {	FXDLog_DEFAULT;
	
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidStartGathering:)
						  name:NSMetadataQueryDidStartGatheringNotification
						object:self.metadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryGatheringProgress:)
						  name:NSMetadataQueryGatheringProgressNotification
						object:self.metadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidFinishGathering:)
						  name:NSMetadataQueryDidFinishGatheringNotification
						object:self.metadataQuery];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSMetadataQueryDidUpdate:)
						  name:NSMetadataQueryDidUpdateNotification
						object:self.metadataQuery];
	
	//TODO: work with metadataQuery
}

//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
	
}

#pragma mark -
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation FXDsuperCloudControl (Added)
@end
