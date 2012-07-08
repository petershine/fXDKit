//
//  FXDsuperCloudControl.h
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


#define notificationCloudControlDidUpdateUbiquityContainerURL	@"notificationCloudControlDidUpdateUbiquityContainerURL"


@interface FXDsuperCloudControl : FXDObject <NSMetadataQueryDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	id _ubiquityIdentityToken;
	NSURL *_ubiquityContainerURL;
	
	NSMetadataQuery *_metadataQuery;
}

// Properties
@property (strong, nonatomic) id ubiquityIdentityToken;
@property (strong, nonatomic) NSURL *ubiquityContainerURL;

@property (strong, nonatomic) NSMetadataQuery *metadataQuery;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCloudControl*)sharedInstance;

- (void)startCloudSynchronization;

- (void)startObservingMetadataQueryNotifications;


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification;

- (void)observedNSMetadataQueryDidStartGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryGatheringProgress:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidFinishGathering:(NSNotification*)notification;
- (void)observedNSMetadataQueryDidUpdate:(NSNotification*)notification;

//MARK: - Delegate implementation


@end
