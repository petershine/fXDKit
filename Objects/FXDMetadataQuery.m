//
//  FXDMetadataQuery.m
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDMetadataQuery.h"


#pragma mark - Private interface
@interface FXDMetadataQuery (Private)
@end


#pragma mark - Public implementation
@implementation FXDMetadataQuery

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
@implementation NSMetadataQuery (Added)
- (BOOL)logQueryResultsWithTransferringPercentage {
	
	BOOL didLogTransferring = NO;
	
	for (NSMetadataItem *metadataItem in [self results]) {
#if TEST_logTransferringPercentage
		NSString *logString = @"";
#endif
		id isDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadedKey];
		id isUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadedKey];
		
		if ([isUploaded boolValue] == NO) {
			id isUploading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadingKey];
			
			if ([isUploading boolValue]) {
				didLogTransferring = YES;
			}
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isUploaded: %d", [isUploaded boolValue]];
			
			if (didLogTransferring) {
				NSNumber *percentUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentUploadedKey];
				logString = [logString stringByAppendingFormat:@" uploading: %@", percentUploaded];
			}
#endif
		}
		else if ([isDownloaded boolValue] == NO) {
			id isDownloading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadingKey];
			
			if ([isDownloading boolValue]) {
				didLogTransferring = YES;
			}
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isDownloaded: %d", [isDownloaded boolValue]];
			
			if (didLogTransferring) {
				NSNumber *percentDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentDownloadedKey];
				logString = [logString stringByAppendingFormat:@" downloading %@", percentDownloaded];
			}
#endif
		}
		
#if TEST_logTransferringPercentage
		if ([logString isEqualToString:@""] == NO) {
			NSString *displayName = [metadataItem valueForKey:NSMetadataItemDisplayNameKey];
			
			FXDLog(@"item: %@ %@", displayName, logString);
		}
#endif
	}
	
	return didLogTransferring;
}


@end


@implementation NSMetadataItem (Added)
- (double)transferPercentage {
	double transferPercentage = 0.0;
		
	BOOL isDownloading = NO;
	
	BOOL isUploading = [[self valueForAttribute:NSMetadataUbiquitousItemIsUploadingKey] boolValue];
	
	if (isUploading) {
		transferPercentage = [[self valueForAttribute:NSMetadataUbiquitousItemPercentUploadedKey] doubleValue];
	}
	else {
		isDownloading = [[self valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];
		
		if (isDownloading) {
			transferPercentage = [[self valueForAttribute:NSMetadataUbiquitousItemPercentDownloadedKey] doubleValue];
		}
	}
	
	return transferPercentage;
}

#pragma mark -
- (NSString*)unicodeAbsoluteString {
	return [[[self valueForAttribute:NSMetadataItemURLKey] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSContentChangeDateKey];
	
	return attributeModificationDate;
}


@end
