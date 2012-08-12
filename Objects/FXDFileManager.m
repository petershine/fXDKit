//
//  FXDFileManager.m
///
//
//  Created by petershine on 7/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDFileManager.h"


#pragma mark - Private interface
@interface FXDFileManager (Private)
@end


#pragma mark - Public implementation
@implementation FXDFileManager

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


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

#pragma mark -
- (NSMutableDictionary*)infoDictionaryForFolderURL:(NSURL*)folderURL {
	
	NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[infoDictionary setObject:[folderURL lastPathComponent] forKey:@"folderName"];
	
	
	NSDirectoryEnumerator *enumerator = [self limitedEnumeratorForRootURL:folderURL];
	
	NSMutableArray *itemArray = nil;
	
	NSError *error = nil;
	
	NSURL *nextURL = [enumerator nextObject];
	
	while (nextURL) {
		NSString *resourceType = nil;
		[nextURL getResourceValue:&resourceType forKey:NSURLFileResourceTypeKey error:&error];
		
		if ([resourceType isEqualToString:NSURLFileResourceTypeDirectory]) {
			
			//MARK: recursively called
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
	
	FXDLog_ERROR;
	
	if (itemArray && [itemArray count] > 0) {
		[infoDictionary setObject:itemArray forKey:@"items"];
	}
	
	return infoDictionary;
}

@end
