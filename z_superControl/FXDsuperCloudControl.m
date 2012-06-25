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
		_ubiquityURL = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
static FXDsuperCloudControl *_sharedInstance = nil;

+ (FXDsuperCloudControl*)sharedInstance {
	@synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
	}
	
	return _sharedInstance;
}

#pragma mark -
- (void)startCloudSynchronization {	FXDLog_DEFAULT;
	
	BOOL shouldRequestURLforUbiquityContatiner = NO;
	
	if ([FXDsuperGlobalControl isOSversionNew]) {
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		[defaultCenter addObserver:self selector:@selector(observedNSUbiquityIdentityDidChange:) name:NSUbiquityIdentityDidChangeNotification object:nil];
		
		id cloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
		FXDLog(@"cloudToken: %@", cloudToken);
		
		if (cloudToken) {
			shouldRequestURLforUbiquityContatiner = YES;
		}
		else {
			//TODO:
		}
	}
	else {	// For iOS 5
		shouldRequestURLforUbiquityContatiner = YES;
	}
	
	FXDLog(@"shouldRequestURLforUbiquityContatiner: %@", shouldRequestURLforUbiquityContatiner ? @"YES":@"NO");
	
	if (shouldRequestURLforUbiquityContatiner) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			FXDLog(@"%@", @"[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier]");
			
			NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				self.ubiquityURL = ubiquityURL;
				
				FXDLog(@"ubiquityURL: %@", self.ubiquityURL);
			});
		});
	}
}


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(id)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
	
}

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation FXDsuperCloudControl (Added)
@end
