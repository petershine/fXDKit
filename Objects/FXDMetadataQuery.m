//
//  FXDMetadataQuery.m
//
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMetadataQuery.h"


@implementation FXDMetadataQuery
@end


#pragma mark - Category
@implementation NSMetadataQuery (Added)
- (BOOL)isQueryResultsTransferring {
	
	BOOL isTransferring = NO;

	for (NSMetadataItem *metadataItem in [self results]) {

		BOOL isDownloaded = NO;
		BOOL isUploaded = NO;
		
		id value = [metadataItem valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
		isDownloaded = (value == NSMetadataUbiquitousItemDownloadingStatusDownloaded);
		isUploaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey] boolValue];

		if (isUploaded == NO) {
			id isUploading = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadingKey];
			
			if ([isUploading boolValue]) {
				isTransferring = YES;
			}
			
		}
		else if (isDownloaded == NO) {
			id isDownloading = [metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey];
			
			if ([isDownloading boolValue]) {
				isTransferring = YES;
			}
		}
	}
	
	return isTransferring;
}

@end


@implementation NSMetadataItem (Added)
- (Float64)transferPercentage {
	Float64 transferPercentage = 0.0;
		
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

- (NSString*)unicodeAbsoluteString {
	return [[[self valueForAttribute:NSMetadataItemURLKey] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSContentChangeDateKey];
	//NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSCreationDateKey];
	
	return attributeModificationDate;
}


@end
