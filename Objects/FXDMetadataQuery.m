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
- (BOOL)isQueryResultsTransferringWithLogString:(NSString*)logString {
	
	BOOL isTransferring = NO;

#if TEST_logTransferringPercentage
	double percentage = 0.0;
#endif
	
	for (NSMetadataItem *metadataItem in [self results]) {
#if TEST_logTransferringPercentage
		logString = @"";
#endif
		id isDownloaded = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey];
		id isUploaded = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey];
		
		if ([isUploaded boolValue] == NO) {
			id isUploading = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadingKey];
			
			if ([isUploading boolValue]) {
				isTransferring = YES;
			}
			
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isUploaded: %d", [isUploaded boolValue]];
			
			if (isTransferring) {
				NSNumber *percentUploaded = [metadataItem valueForAttribute:NSMetadataUbiquitousItemPercentUploadedKey];
				percentage = [percentUploaded doubleValue];
				
				logString = [logString stringByAppendingFormat:@" uploading: %@", percentUploaded];
			}
#endif
		}
		else if ([isDownloaded boolValue] == NO) {
			id isDownloading = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey];
			
			if ([isDownloading boolValue]) {
				isTransferring = YES;
			}
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isDownloaded: %d", [isDownloaded boolValue]];
			
			if (isTransferring) {
				NSNumber *percentDownloaded = [metadataItem valueForAttribute:NSMetadataUbiquitousItemPercentDownloadedKey];
				percentage = [percentDownloaded doubleValue];
				
				logString = [logString stringByAppendingFormat:@" downloading %@", percentDownloaded];
			}
#endif
		}
		
#if TEST_logTransferringPercentage
		if (isTransferring && percentage > 0.0 && logString.length > 0) {
			NSString *itemName = [metadataItem valueForAttribute:NSMetadataItemFSNameKey];
			
			FXDLog(@"item: %@ %@", itemName, logString);
		}
#endif
	}
	
	return isTransferring;
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
	//NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSCreationDateKey];
	
	return attributeModificationDate;
}


@end
