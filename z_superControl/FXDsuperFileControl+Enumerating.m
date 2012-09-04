//
//  FXDsuperFileControl+Enumerating.m
///
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperFileControl.h"

@implementation FXDsuperFileControl (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSMutableArray *metadataItemArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
		
		for (NSMetadataItem *metadataItem in self.ubiquitousDocumentsMetadataQuery.results) {
			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
			
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			[itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];FXDLog_ERRORexcept(260);
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				
				id isHidden = nil;
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERRORexcept(260);
				
				if ([isHidden boolValue] == NO) {
					[metadataItemArray addObject:metadataItem];
					
					[self updateCollectedURLarrayWithMetadataItem:metadataItem];
				}
			}
		}
		
		[userInfo setObject:metadataItemArray forKey:objkeyUbiquitousMetadataItems];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL object:self userInfo:userInfo];
		}];
	}];
}

- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	
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
			NSError *error = nil;
			
			id isDirectory = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);
			
			if ([isDirectory boolValue]) {
				[subfolderURLarray addObject:nextURL];
			}
			else {
				[fileURLarray addObject:nextURL];
			}
			
			nextURL = [enumerator nextObject];
		}
		
		[userInfo setObject:subfolderURLarray forKey:objkeyUbiquitousFolders];
		[userInfo setObject:fileURLarray forKey:objkeyUbiquitousFiles];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:self userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		NSError *error = nil;
		
		NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:appDirectory_Document];
		
		NSURL *nextURL = [enumerator nextObject];
		
		while (nextURL) {
			id isDirectory = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR;
			
			if ([isDirectory boolValue] == NO) {
				BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:nextURL];
				
				if (isUbiquitousItem == NO) {
					NSError *error = nil;
					
					NSString *itemName = nil;
					[nextURL getResourceValue:&itemName forKey:NSURLNameKey error:&error];FXDLog_ERROR;
					
					if ([itemName rangeOfString:@"AviaryContentPacks"].length > 0 || [itemName rangeOfString:@".sqlite"].length > 0) {	//SKIP
						FXDLog(@"SKIPPED: itemName: %@", itemName);
					}
					else {
						id isHidden = nil;
						[nextURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERROR;
						
						if ([isHidden boolValue] == NO) {
							[self setUbiquitousForLocalItemURLarray:@[nextURL] atCurrentFolderURL:nil withSeparatorPathComponent:pathcomponentDocuments];
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