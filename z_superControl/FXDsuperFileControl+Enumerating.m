//
//  FXDsuperFileControl+Enumerating.m
//  EasyFileSharing
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperFileControl.h"

@implementation FXDsuperFileControl (Enumerating)
#pragma mark - Public
- (void)enumerateUbiquitousMetadataItemsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *metadataItems = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	//FXDLog(@"self.ubiquityMetadataQuery results] count: %d", [[self.ubiquityMetadataQuery results] count]);
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		for (NSMetadataItem *metadataItem in [self.ubiquityMetadataQuery results]) {
			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
			
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			[itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				
				id isHidden = nil;
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
				//FXDLog(@"isHidden: %@", isHidden);
				
				if ([isHidden boolValue]) {
					//SKIP
				}
				else {
					[metadataItems addObject:metadataItem];
				}
			}
		}
		
		[userInfo setObject:metadataItems forKey:objkeyUbiquitousMetadataItems];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousMetadataItemsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateUbiquitousDocumentsAtCurrentFolderURL:(NSURL*)currentFolderURL {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *folders = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] fullEnumeratorForRootURL:currentFolderURL];
		
		NSURL *nextObject = [enumerator nextObject];
		
		while (nextObject) {
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			
			[nextObject getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				id fileResourceType = nil;
				
				[nextObject getResourceValue:&fileResourceType forKey:NSURLFileResourceTypeKey error:&error];
				
				if ([fileResourceType isEqualToString:NSURLFileResourceTypeDirectory]) {
					[folders addObject:nextObject];
				}
			}
			
			FXDLog_ERROR;
			
			nextObject = [enumerator nextObject];
		}
		
		[userInfo setObject:folders forKey:objkeyUbiquitousFolders];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSFileManager *fileManager = [NSFileManager defaultManager];
	
	
	NSURL *rootURL = [NSURL URLWithString:appSearhPath_Document];
	
	NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:rootURL];
	
	NSURL *nextObject = [enumerator nextObject];
	
	while (nextObject) {
		
		__block NSURL *itemURL = nextObject;
		
		if ([fileControl.queuedURLset containsObject:itemURL] == NO) {
			[fileControl.queuedURLset addObject:itemURL];
			
			[fileControl.operationQueue addOperationWithBlock:^{
				id isUbiquitousItem = nil;
				id isHidden = nil;
				
				NSError *error = nil;
				
				[itemURL getResourceValue:&isUbiquitousItem forKey:NSURLIsUbiquitousItemKey error:&error];
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
				
				FXDLog_ERROR;
				
				if ((isUbiquitousItem == nil || [isUbiquitousItem boolValue] == NO) && [isHidden boolValue] == NO) {
					NSArray *localItemURLarray = @[itemURL];
					
					[fileControl setUbiquitousForLocalItemURLarray:localItemURLarray withCurrentFolderURL:self.ubiquitousDocumentsURL withSeparatorPathComponent:pathcomponentDocuments withFileManager:fileManager];
				}
				
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					if ([fileControl.queuedURLset containsObject:itemURL]) {
						[fileControl.queuedURLset removeObject:itemURL];
					}
				}];
			}];
		}
		
		nextObject = [enumerator nextObject];
	}
}


@end