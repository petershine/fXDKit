//
//  FXDsuperFileControl+Managing.m
///
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperFileControl.h"

@implementation FXDsuperFileControl (Managing)
#pragma mark - Public
- (void)addNewFolderInsideCurrentFolderURL:(NSURL*)currentFolderURL withNewFolderName:(NSString*)newFolderName {	//FXDLog_DEFAULT;
	/*
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	 */
	
	if (newFolderName == nil || [newFolderName isEqualToString:@""]) {
		newFolderName = [[NSDate date] description];
	}
	
	
	NSString *pathComponent = [NSString stringWithFormat:@"%@", newFolderName];
	NSURL *newFolderURL = [currentFolderURL URLByAppendingPathComponent:pathComponent];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	[fileManager createDirectoryAtURL:newFolderURL
		  withIntermediateDirectories:YES
						   attributes:nil
								error:&error];
	
	FXDLog_ERROR;
	
	[self enumerateUbiquitousDocumentsAtCurrentFolderURL:currentFolderURL];
}

#pragma mark -
- (void)manageItemURLarray:(NSArray*)itemURLarray forItemActionType:(ITEM_ACTION_TYPE)itemActionType fromCurrentFolderURL:(NSURL*)currentFolderURL toDestinationFolderURL:(NSURL*)destinationFolderURL {	FXDLog_DEFAULT;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	for (NSURL *itemURL in itemURLarray) {
		BOOL didSucceed = NO;
		
		if (itemActionType == itemActionDelete) {
			didSucceed = [fileManager removeItemAtURL:itemURL error:&error];
		}
		else {
			NSURL *itemDestinationURL = [destinationFolderURL URLByAppendingPathComponent:[itemURL lastPathComponent]];
			
			if (itemActionType == itemActionMove) {
				didSucceed = [fileManager moveItemAtURL:itemURL toURL:itemDestinationURL error:&error];
			}
			else if (itemActionType == itemActionCopy) {
				didSucceed = [fileManager copyItemAtURL:itemURL toURL:itemDestinationURL error:&error];
			}
		}
		
		FXDLog_ERROR;
	}
	
	if (currentFolderURL) {
		[self enumerateUbiquitousDocumentsAtCurrentFolderURL:currentFolderURL];
		[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:currentFolderURL];
	}
}


@end
