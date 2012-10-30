//
//  FXDFileManager.m
///
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDFileManager.h"


#pragma mark - Public implementation
@implementation FXDFileManager


#pragma mark - Memory management


#pragma mark - Initialization


#pragma mark - Property overriding


#pragma mark - Method overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSFileManager (Added)
- (NSDirectoryEnumerator*)fullEnumeratorForRootURL:(NSURL*)rootURL {
	
	NSDirectoryEnumerator *fullEnumerator = [self enumeratorAtURL:rootURL
									   includingPropertiesForKeys:nil
														  options:0
													 errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
														 FXDLog_ERROR;
														 FXDLog(@"url: %@", url);
														 
														 return YES;
													 }];
	
	return fullEnumerator;
}

- (NSDirectoryEnumerator*)limitedEnumeratorForRootURL:(NSURL*)rootURL {
	
	NSDirectoryEnumerator *limitedEnumerator = [self enumeratorAtURL:rootURL
										  includingPropertiesForKeys:nil
															 options:NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsPackageDescendants
														errorHandler:^BOOL(NSURL *url, NSError *error) {	FXDLog_DEFAULT;
															FXDLog_ERROR;
															FXDLog(@"url: %@", url);
															
															return YES;
														}];
	
	return limitedEnumerator;
}

- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL {
	
	NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	infoDictionary[@"folderName"] = [folderURL lastPathComponent];
	
	
	NSDirectoryEnumerator *enumerator = [self limitedEnumeratorForRootURL:folderURL];
	
	NSMutableArray *itemArray = nil;
	
	NSURL *nextURL = [enumerator nextObject];
	
	while (nextURL) {
		
		id isDirectory = nil;

		NSError *error = nil;
		[nextURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error];FXDLog_ERROR;
		
		if ([isDirectory boolValue]) {	//MARK: recursively called
			NSMutableDictionary *subInfoDictionary = [self infoDictionaryForFolderURL:nextURL];
			
			if (subInfoDictionary && [subInfoDictionary count] > 0) {
				if (itemArray == nil) {
					itemArray = [[NSMutableArray alloc] initWithCapacity:0];
				}
				
				[itemArray addObject:subInfoDictionary];
			}
		}
		else {
			if (itemArray == nil) {
				itemArray = [[NSMutableArray alloc] initWithCapacity:0];
			}
			
			[itemArray addObject:[nextURL lastPathComponent]];
		}
		
		nextURL = [enumerator nextObject];
	}
	
	if (itemArray && [itemArray count] > 0) {
		infoDictionary[@"items"] = itemArray;
	}
	
	return infoDictionary;
}

@end
