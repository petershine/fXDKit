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
	
	[self setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
	[self setNotificationBatchingInterval:0.5];
}

- (BOOL)logQueryResultsWithTransferringPercentage {
	BOOL didLogTransferring = NO;
	
	for (NSMetadataItem *metadataItem in [self results]) {
		NSString *logString = @"";
		
		NSNumber *isDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadedKey];
		NSNumber *isUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadedKey];
		
		if ([isUploaded boolValue] == NO) {
			logString = [logString stringByAppendingFormat:@"isUploaded: %@ ", [isUploaded boolValue] ? @"YES":@"NO"];
			
			
			NSNumber *isUploading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsUploadingKey];
			
			if ([isUploading boolValue]) {
				didLogTransferring = YES;
				
				NSNumber *percentUploaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentUploadedKey];
				logString = [logString stringByAppendingFormat:@"uploading: %@", percentUploaded];
			}
		}
		else if ([isDownloaded boolValue] == NO) {
			logString = [logString stringByAppendingFormat:@"isDownloaded: %@ ", [isDownloaded boolValue] ? @"YES":@"NO"];
			
			NSNumber *isDownloading = [metadataItem valueForKey:NSMetadataUbiquitousItemIsDownloadingKey];
			
			if ([isDownloading boolValue]) {
				didLogTransferring = YES;
				
				NSNumber *percentDownloaded = [metadataItem valueForKey:NSMetadataUbiquitousItemPercentDownloadedKey];
				logString = [logString stringByAppendingFormat:@"downloading %@", percentDownloaded];
			}
		}
		
		if ([logString isEqualToString:@""] == NO) {
			NSString *displayName = [metadataItem valueForKey:NSMetadataItemDisplayNameKey];
			logString = [logString stringByAppendingFormat:@"    %@", displayName];
			
			FXDLog(@"%@", logString);
		}
	}
	
	return didLogTransferring;
}


@end