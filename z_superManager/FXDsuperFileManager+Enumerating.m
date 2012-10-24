//
//  FXDsuperFileManager+Enumerating.m
///
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperFileManager.h"

@implementation FXDsuperFileManager (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}

	[self.ubiquitousDocumentsMetadataQuery disableUpdates];
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSMutableDictionary *metadataItemArray = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];

		NSString *alertTitle = nil;

		//for (NSMetadataItem *metadataItem in self.ubiquitousDocumentsMetadataQuery.results) {
		for (NSUInteger i = 0; i < self.ubiquitousDocumentsMetadataQuery.resultCount; i++) {
			NSMetadataItem *metadataItem = [self.ubiquitousDocumentsMetadataQuery resultAtIndex:i];

			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];


#if shouldDownloadEvictedFilesInitially
			BOOL isDownloaded = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadedKey] boolValue];
			BOOL isDownloading = [[metadataItem valueForAttribute:NSMetadataUbiquitousItemIsDownloadingKey] boolValue];

			if (isDownloaded == NO && isDownloading == NO) {
				NSError *error = nil;
				BOOL didStartDownloading = [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:itemURL error:&error];

				if ([error code] == 512) {
					if (alertTitle == nil) {
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
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				
				id isHidden = nil;

				NSError *error = nil;
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERRORexcept(260);
				
				if ([isHidden boolValue] == NO) {
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
			[self.ubiquitousDocumentsMetadataQuery enableUpdates];

			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL object:self userInfo:userInfo];
		}];
	}];
}

- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL {	FXDLog_DEFAULT;
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}

	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSMutableArray *subfolderURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		NSMutableArray *fileURLarray = [[NSMutableArray alloc] initWithCapacity:0];
		
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] limitedEnumeratorForRootURL:currentFolderURL];
		
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
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:self userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSFileManager *fileManager = [NSFileManager defaultManager];

		
		NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:appDirectory_Document];
		
		NSURL *nextURL = [enumerator nextObject];

		NSMutableArray *receivedURLarray = [[UIApplication sharedApplication].delegate performSelector:@selector(receivedURLarray)];
		FXDLog(@"receivedURLarray:\n%@", receivedURLarray);
		
		while (nextURL) {
			id isDirectory = nil;

			NSError *error = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR;
			
			if ([isDirectory boolValue] == NO) {
				BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:nextURL];
				
				if (isUbiquitousItem == NO) {
					
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
						
						if ([isHidden boolValue] == NO) {
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

							if (shouldSkip == NO) {
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