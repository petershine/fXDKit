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
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
	__block FXDsuperFileControl *fileControl = self;
	
	__block NSMutableArray *metadataItems = [[NSMutableArray alloc] initWithCapacity:0];
	
	__block NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	//FXDLog(@"self.ubiquityMetadataQuery results] count: %d", [[self.ubiquityMetadataQuery results] count]);
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		for (NSMetadataItem *metadataItem in [self.ubiquitousDocumentsMetadataQuery results]) {
			NSURL *itemURL = [metadataItem valueForAttribute:NSMetadataItemURLKey];
			
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			[itemURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];FXDLog_ERROR;
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				
				id isHidden = nil;
				[itemURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERROR;
				//FXDLog(@"isHidden: %@", isHidden);
				
				if ([isHidden boolValue] == NO) {
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
		
		NSURL *nextURL = [enumerator nextObject];
		
		while (nextURL) {
			NSError *error = nil;
			
			id parentDirectoryURL = nil;
			[nextURL getResourceValue:&parentDirectoryURL forKey:NSURLParentDirectoryURLKey error:&error];FXDLog_ERROR;
			
			if (parentDirectoryURL && [[parentDirectoryURL absoluteString] isEqualToString:[currentFolderURL absoluteString]]) {
				
				id isDirectory = nil;
				[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR;
				
				if ([isDirectory boolValue]) {
					[folders addObject:nextURL];
				}
			}
			
			nextURL = [enumerator nextObject];
		}
		
		[userInfo setObject:folders forKey:objkeyUbiquitousFolders];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:notificationFileControlDidEnumerateUbiquitousDocumentsAtCurrentFolderURL object:fileControl userInfo:userInfo];
		}];
	}];
}

- (void)enumerateLocalDirectory {	//FXDLog_DEFAULT;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSDirectoryEnumerator *enumerator = [fileManager fullEnumeratorForRootURL:appDirectory_Document];
	
	__block NSURL *nextURL = [enumerator nextObject];
	
	while (nextURL) {
		NSError *error = nil;
		
		NSString *localizedName = nil;
		[nextURL getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:&error];FXDLog_ERROR;
		
		if ([localizedName rangeOfString:@".sqlite"].length > 0) {	//SKIP
			FXDLog(@"localizedName: %@", localizedName);
		}
		else {
			id isHidden = nil;
			[nextURL getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];FXDLog_ERROR;
			
			if ([isHidden boolValue] == NO) {
				__block FXDsuperFileControl *fileControl = self;
								
				BOOL doesContain = [fileControl.queuedURLset containsObject:nextURL];
				
				if (doesContain == NO) {
					BOOL isUbiquitousItem = [fileManager isUbiquitousItemAtURL:nextURL];
					
					if (isUbiquitousItem == NO) {
						[fileControl.queuedURLset addObject:nextURL];
						
						[fileControl.operationQueue addOperationWithBlock:^{
							NSArray *localItemURLarray = @[nextURL];
							
							[fileControl setUbiquitousForLocalItemURLarray:localItemURLarray atCurrentFolderURL:nil withSeparatorPathComponent:pathcomponentDocuments];
							
							[[NSOperationQueue mainQueue] addOperationWithBlock:^{
								if ([fileControl.queuedURLset containsObject:nextURL]) {
									[fileControl.queuedURLset removeObject:nextURL];
								}
							}];
						}];
					}
				}
			}
		}
		
		nextURL = [enumerator nextObject];
	}
}


@end