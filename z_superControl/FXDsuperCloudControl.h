//
//  FXDsuperCloudControl.h
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


#define notificationCloudControlDidUpdateUbiquityURL	@"notificationCloudControlDidUpdateUbiquityURL"


@interface FXDsuperCloudControl : FXDObject <NSMetadataQueryDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	id _ubiquityToken;
	NSURL *_ubiquityURL;
	
	NSMetadataQuery *_metadataQuery;
}

// Properties
@property (strong, nonatomic) id ubiquityToken;
@property (strong, nonatomic) NSURL *ubiquityURL;

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
