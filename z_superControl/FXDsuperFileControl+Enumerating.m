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
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *metadataItemArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		for (NSMetadataItem *metadataItem in [self.ubiquitousDocumentsMetadataQuery results]) {
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
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *folderURLarray = [[NSMutableArray alloc] initWithCapacity:0];
	__block NSMutableArray *fileURLarray = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] limitedEnumeratorForRootURL:currentFolderURL];
		
		NSURL *nextURL = [enumerator nextObject];
		
		while (nextURL) {
			NSError *error = nil;
			
			id isDirectory = nil;
			[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERRORexcept(260);
			
			if ([isDirectory boolValue]) {
				[folderURLarray addObject:nextURL];
			}
			else {
				[fileURLarray addObject:nextURL];
			}
			
			nextURL = [enumerator nextObject];
		}
		
		[userInfo setObject:folderURLarray forKey:objkeyUbiquitousFolders];
		[userInfo setObject:fileURLarray forKey:objkeyUbiquitousFiles];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	__block FXDsuperFileControl *fileControl = self;
	
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
							[fileControl setUbiquitousForLocalItemURLarray:@[nextURL] atCurrentFolderURL:nil withSeparatorPathComponent:pathcomponentDocuments];
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