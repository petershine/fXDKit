//
//  FXDmoduleQuery.h
//
//
//  Created by petershine on 7/2/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@protocol FXDMetadataQueryDelegate <NSMetadataQueryDelegate>
@required
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification;
@end


@interface FXDmoduleQuery : FXDsuperModule <FXDMetadataQueryDelegate> {
	FXDcallbackFinish _metadataQueryCallback;

	NSMetadataQuery *_mainMetadataQuery;
}

@property (copy) FXDcallbackFinish metadataQueryCallback;

@property (strong, nonatomic) NSMetadataQuery *mainMetadataQuery;

- (void)startObservingMetadataQueryNotifications;

@end
