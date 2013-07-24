//
//  FXDsuperCloudManager+Enumerating.m
//
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCloudManager.h"


@implementation FXDsuperCloudManager (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtFolderURL:(NSURL*)folderURL withDidEnumerateBlock:(void(^)(BOOL finished, NSDictionary *userInfo))didEnumerateBlock {	FXDLog_DEFAULT;
	
	if (!folderURL) {
		folderURL = self.ubiquitousDocumentsURL;
	}

	[self.cloudDocumentsQuery disableUpdates];
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSMutableDictionary *metadataItemArray = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];

		NSString *alertTitle = nil;

		for (NSUInteger i = 0; i < [self.cloudDocumentsQuery resultCount]; i++) {
			NSMetadataItem *metadataItem = [self.cloudDocumentsQuery resultAtIndex:i];

			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];

#if shouldUSE_DownloadingEvictedFilesInitially
			BOOL isDownloaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey] boolValue];
			BOOL isDownloading = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];

			if (!isDownloaded && !isDownloading) {
				NSError *error = nil;
				BOOL didStartDownloading = [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:itemURL error:&error];

				if ([error code] == 512) {
					if (!alertTitle) {
						NSError *underlyingError = ([([error userInfo])[@"NSUnderlyingError"] userInfo])[@"NSUnderlyingError"];

						if (underlyingError) {
							NSDictionary *userInfo = [underlyingError userInfo];

							alertTitle = userInfo[@"NSDescription"];
						}
					}
				}
				else {
					FXDLog(@"didStartDownloading: %d itemURL followingPathInDocuments: %@", didStartDownloading, [itemURL followingPathInDocuments]);
					FXDLog_ERROR;
				}
			}
#endif			
			
			id parentDirectoryURL = nil;

			NSError *error = nil;
			[itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];FXDLog_ERRORexcept(260);
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[folderURL absoluteString]]) {
				
				id isHidden = nil;

				NSError *error = nil;
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERRORexcept(260);
				
				if (![isHidden boolValue]) {
					metadataItemArray[[itemURL absoluteString]] = metadataItem;
					
					[self updateCollectedURLarrayWithMetadataItem:metadataItem];
				}
			}
		}
		
		userInfo[objkeyUbiquitousMetadataItems] = metadataItemArray;

		if (alertTitle) {
			userInfo[@"alertTitle"] = alertTitle;
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self.cloudDocumentsQuery enableUpdates];
			
			FXDLog(@"userInfo: %@", userInfo);

			if (didEnumerateBlock) {
				didEnumerateBlock(YES, userInfo);
			}
			else {
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidEnumerateUbiquitousMetadataItems object:self userInfo:userInfo];
			}
		}];
	}];
}

- (void)enumerateUbiquitousDocumentsAtFolderURL:(NSURL*)folderURL withDidEnumerateBlock:(void(^)(BOOL finished, NSDictionary *userInfo))didEnumerateBlock {	FXDLog_DEFAULT;
	
	if (!folderURL) {
		folderURL = self.ubiquitousDocumentsURL;
	}

	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSMutableArray *subfolderURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		NSMutableArray *fileURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] limitedEnumeratorForRootURL:folderURL];
		
		NSURL *nextURL = [enumerator nextObject];
		
		while (nextURL) {
			id isDirectory = nil;

			NSError *error = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);
			
			if ([isDirectory boolValue]) {
				[subfolderURLarray addObject:nextURL];
			}
			else {
				[fileURLarray addObject:nextURL];
			}
			
			nextURL = [enumerator nextObject];
		}
		
		userInfo[objkeyUbiquitousFolders] = subfolderURLarray;
		userInfo[objkeyUbiquitousFiles] = fileURLarray;
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			
			FXDLog(@"userInfo: %@", userInfo);
			
			if (didEnumerateBlock) {
				didEnumerateBlock(YES, userInfo);
			}
			else {
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCloudManagerDidEnumerateUbiquitousDocuments object:self userInfo:userInfo];
			}
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSFileManager *fileManager = [NSFileManager defaultManager];

		
		NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:appDirectory_Document];
		
		NSURL *nextURL = [enumerator nextObject];

		
		NSMutableArray *receivedURLarray = nil;
		
		SEL receivedURLarraySelector = NSSelectorFromString(@"receivedURLarray");
		
		if (receivedURLarraySelector) {
			receivedURLarray = [[UIApplication sharedApplication].delegate performSelector:receivedURLarraySelector];
		}
		
		FXDLog(@"receivedURLarray:\n%@", receivedURLarray);
		
		while (nextURL) {
			id isDirectory = nil;

			NSError *error = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR;
			
			if (![isDirectory boolValue]) {
				BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:nextURL];
				
				if (!isUbiquitousItem) {
					
					NSString *itemName = nil;

					error = nil;
					[nextURL getResourceValue:&itemName forKey:NSURLNameKey error:&error];FXDLog_ERROR;
					
					if ([itemName rangeOfString:@"AviaryContentPacks"].length > 0
						|| [itemName rangeOfString:@".sqlite"].length > 0
						|| [itemName rangeOfString:@"aviary"].length > 0) {	//SKIP
						FXDLog(@"SKIPPED: itemName: %@", itemName);

						//[nextURL setResourceValue:@YES forKey:NSURLIsHiddenKey error:&error];FXDLog_ERROR;
					}
					else {
						id isHidden = nil;

						error = nil;
						[nextURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERROR;
						
						if (![isHidden boolValue]) {
							BOOL shouldSkip = NO;

							if (receivedURLarray && [receivedURLarray count] > 0) {
								for (NSURL *receivedURL in receivedURLarray) {
									if ([[receivedURL absoluteString] isEqualToString:[nextURL absoluteString]]) {
										FXDLog(@"SKIPPED until passcode entered: receivedURL: %@ nextURL: %@", receivedURL, nextURL);
										shouldSkip = YES;
									}
								}
							}

							FXDLog(@"shouldSkip: %d", shouldSkip);

							if (!shouldSkip) {
								[self setUbiquitousForLocalItemURLarray:@[nextURL] atCurrentFolderURL:nil withSeparatorPathComponent:pathcomponentDocuments];
							}
						}
					}
				}
			}
			
			nextURL = [enumerator nextObject];
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			//TODO:
		}];
	}];
}


@end