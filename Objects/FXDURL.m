//
//  FXDURL.m
//  EasyFileSharing
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDURL.h"


#pragma mark - Private interface
@interface FXDURL (Private)
@end


#pragma mark - Public implementation
@implementation FXDURL

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
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
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSURL (Added)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error {	FXDLog_DEFAULT;
	NSArray *ubiquitousItemKeys = [NSArray arrayWithObjects:
								   NSURLIsUbiquitousItemKey,
								   NSURLUbiquitousItemHasUnresolvedConflictsKey,
								   NSURLUbiquitousItemIsDownloadedKey,
								   NSURLUbiquitousItemIsDownloadingKey,
								   NSURLUbiquitousItemIsUploadedKey,
								   NSURLUbiquitousItemIsUploadingKey,
								   nil];
	
	NSDictionary *resourceValues = [self resourceValuesForKeys:ubiquitousItemKeys error:error];
	
	return resourceValues;
}

- (NSDictionary*)fullResourceValuesWithError:(NSError **)error {
	NSMutableDictionary *resourceValues = [[NSMutableDictionary alloc] initWithDictionary:[self resourceValuesForUbiquitousItemKeysWithError:error]];
	
	[resourceValues setValuesForKeysWithDictionary:[self resourceValuesForKeys:nil error:error]];
	
	return resourceValues;	
}


@end