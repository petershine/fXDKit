//
//  FXDMetadataQuery.m
///
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMetadataQuery.h"


#pragma mark - Public implementation
@implementation FXDMetadataQuery


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

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
		
		BOOL isDownloaded = NO;
		BOOL isUploaded = NO;
		
		if (SYSTEM_VERSION_lowerThan(iosVersion7)) {
#if __IPHONE_7_0
			id value = [metadataItem valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
			isDownloaded = (value == NSMetadataUbiquitousItemDownloadingStatusDownloaded);
			isUploaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey] boolValue];;
#else
			isDownloaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey] boolValue];
			isUploaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey] boolValue];
#endif
		}
		else {
#if __IPHONE_7_0
			id value = [metadataItem valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
			isDownloaded = (value == NSMetadataUbiquitousItemDownloadingStatusDownloaded);
			isUploaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsUploadedKey] boolValue];;
#endif
		}
		
		if (isUploaded == NO) {
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
		else if (isDownloaded == NO) {
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

- (NSString*)unicodeAbsoluteString {
	return [[[self valueForAttribute:NSMetadataItemURLKey] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate*)attributeModificationDate {
	NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSContentChangeDateKey];
	//NSDate *attributeModificationDate = [self valueForAttribute:NSMetadataItemFSCreationDateKey];
	
	return attributeModificationDate;
}


@end
