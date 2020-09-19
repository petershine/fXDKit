

#import "FXDmoduleQuery.h"


@implementation FXDmoduleQuery
#pragma mark - Memory management
- (void)dealloc {
	_metadataQueryCallback = nil;
	FXDLogObject(_mainMetadataQuery);
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMetadataQuery*)mainMetadataQuery {

	if (_mainMetadataQuery == nil) {	FXDLog_DEFAULT
		_mainMetadataQuery = [[NSMetadataQuery alloc] init];

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];
		_mainMetadataQuery.predicate = predicate;

		_mainMetadataQuery.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
	}

	return _mainMetadataQuery;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingMetadataQueryNotifications {	FXDLog_DEFAULT

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidStartGathering:)
	 name:NSMetadataQueryDidStartGatheringNotification
	 object:self.mainMetadataQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryGatheringProgress:)
	 name:NSMetadataQueryGatheringProgressNotification
	 object:self.mainMetadataQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidFinishGathering:)
	 name:NSMetadataQueryDidFinishGatheringNotification
	 object:self.mainMetadataQuery];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSMetadataQueryDidUpdate:)
	 name:NSMetadataQueryDidUpdateNotification
	 object:self.mainMetadataQuery];

	BOOL didStart = [self.mainMetadataQuery startQuery];
	FXDLogBOOL(didStart);

	if (didStart) {}

	if (self.mainMetadataQuery.isStarted) {
		//TODO:
	}
}

#pragma mark - Observer
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

	if (_metadataQueryCallback) {
		_metadataQueryCallback(_cmd, YES, notification);
	}
}

- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

	if (_metadataQueryCallback) {
		_metadataQueryCallback(_cmd, YES, notification);
	}
}

- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

	if (_metadataQueryCallback) {
		_metadataQueryCallback(_cmd, YES, notification);
	}
}

- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

	if (_metadataQueryCallback) {
		_metadataQueryCallback(_cmd, YES, notification);
	}
}

#pragma mark - Delegate

@end

