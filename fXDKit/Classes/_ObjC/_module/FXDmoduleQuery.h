
@import UIKit;
@import Foundation;


@protocol FXDMetadataQueryDelegate <NSMetadataQueryDelegate>
@required
- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification;
@end


#import "FXDsuperModule.h"
@interface FXDmoduleQuery : FXDsuperModule <FXDMetadataQueryDelegate> {
	FXDcallbackFinish _metadataQueryCallback;

	NSMetadataQuery *_mainMetadataQuery;
}

@property (copy) FXDcallbackFinish metadataQueryCallback;

@property (strong, nonatomic) NSMetadataQuery *mainMetadataQuery;

- (void)startObservingMetadataQueryNotifications;

@end