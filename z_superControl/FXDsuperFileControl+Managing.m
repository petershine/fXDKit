//
//  FXDsuperFileControl+Managing.m
//  EasyFileSharing
//
//  Created by petershine on 8/12/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDsuperFileControl.h"

@implementation FXDsuperFileControl (Managing)
#pragma mark - Public
- (void)addNewFolderInsideCurrentFolderURL:(NSURL*)currentFolderURL withNewFolderName:(NSString*)newFolderName {	//FXDLog_DEFAULT;
	//FXDLog(@"currentFolderURL: %@", currentFolderURL);
	
	if (currentFolderURL == nil) {
		currentFolderURL = self.ubiquitousDocumentsURL;
	}
	
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

- (void)removeSelectedURLarray:(NSArray*)selectedURLarray fromCurrentFolderURL:(NSURL*)currentFolderURL {	FXDLog_DEFAULT;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	
	for (NSURL *itemURL in selectedURLarray) {
		BOOL didRemove = [fileManager removeItemAtURL:itemURL error:&error];
		
		FXDLog(@"didRemove: %d itemURL: %@", didRemove, itemURL);
	}
	
	FXDLog_ERROR;
	
	[self enumerateUbiquitousDocumentsAtCurrentFolderURL:currentFolderURL];
	[self enumerateUbiquitousMetadataItemsAtCurrentFolderURL:currentFolderURL];
}


#pragma mark -
- (NSURL*)cachedURLForItemURL:(NSURL*)itemURL {
	NSURL *cachedURL = nil;
	
	if (self.ubiquitousCachesURL == nil) {
		return cachedURL;
	}
	
		
	NSString *relativePath = [[[itemURL absoluteString] componentsSeparatedByString:pathcomponentDocuments] lastObject];
	
	NSString *filePathComponent = [relativePath lastPathComponent];
	filePathComponent = [NSString stringWithFormat:@".cached_%@", filePathComponent];
	
	NSMutableArray *pathComponents = [[NSMutableArray alloc] initWithArray:[relativePath pathComponents]];
	[pathComponents replaceObjectAtIndex:[pathComponents count]-1 withObject:filePathComponent];
	
	cachedURL = [self.ubiquitousCachesURL URLByAppendingPathComponent:[NSString pathWithComponents:pathComponents]];
	
	return cachedURL;
}

@end
