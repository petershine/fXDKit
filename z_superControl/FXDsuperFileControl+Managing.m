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


@end
