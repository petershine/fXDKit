//
//  FXDsuperCloudControl.h
//  PopTooUniversal
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


#define notificationCloudControlDidUpdateUbiquityURL	@"notificationCloudControlDidUpdateUbiquityURL"


@interface FXDsuperCloudControl : FXDObject {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	id _ubiquityToken;
	NSURL *_ubiquityURL;
}

// Properties
@property (strong, nonatomic) id ubiquityToken;
@property (strong, nonatomic) NSURL *ubiquityURL;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCloudControl*)sharedInstance;

- (void)startCloudSynchronization;


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(id)notification;

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface FXDsuperCloudControl (Added)
@end
