//
//  FXDMetadataQuery.m
//  EasyFileSharing
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
- (void)applyDefaultConfiguration {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", NSMetadataItemURLKey, @""];	// For all files
	[self setPredicate:predicate];
	
	/*
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:0];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
	[sortDescriptors addObject:descriptor];
	[self setSortDescriptors:sortDescriptors];
	 */
	
	[self setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
	[self setNotificationBatchingInterval:0.1];
}

- (BOOL)logQueryResultsWithTransferringPercentage {
	BOOL didLogTransferring = NO;
	
	for (NSMetadataItem *metadataItem in [self results]) {
#if TEST_logTransferringPercentage
		NSString *logString = @"";
#endif
		
		NSNumber *isDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadedKey];
		NSNumber *isUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadedKey];
		
		if ([isUploaded boolValue] == NO) {
			didLogTransferring = YES;
			
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isUploaded: %d ", [isUploaded boolValue]];
			
			NSNumber *isUploading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadingKey];
			
			if ([isUploading boolValue]) {
				NSNumber *percentUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentUploadedKey];
				logString = [logString stringByAppendingFormat:@"uploading: %@", percentUploaded];
			}
#endif
		}
		else if ([isDownloaded boolValue] == NO) {
			didLogTransferring = YES;
			
#if TEST_logTransferringPercentage
			logString = [logString stringByAppendingFormat:@"isDownloaded: %d ", [isDownloaded boolValue]];
			
			NSNumber *isDownloading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadingKey];
			
			if ([isDownloading boolValue]) {				
				NSNumber *percentDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentDownloadedKey];
				logString = [logString stringByAppendingFormat:@"downloading %@", percentDownloaded];
			}
#endif
		}
		
#if TEST_logTransferringPercentage
		if ([logString isEqualToString:@""] == NO) {
			NSString *displayName = [metadataItem valueForKey:NSMetadataItemDisplayNameKey];
			logString = [logString stringByAppendingFormat:@" %@", displayName];
			
			FXDLog(@"%@", logString);
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
