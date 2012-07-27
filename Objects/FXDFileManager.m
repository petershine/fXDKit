//
//  FXDFileManager.m
//  EasyFileSharing
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

- (NSArray*)directoryTreeForRootPath:(NSString*)rootPath {
	NSURL *rootURL = [NSURL URLWithString:rootPath];
	
	NSArray *directoryTree = [self directoryTreeForRootURL:rootURL];
	
	return directoryTree;
}

- (NSArray*)directoryTreeForRootURL:(NSURL*)rootURL {	//FXDLog_DEFAULT;
	FXDLog(@"rootURL: %@", rootURL);
	
	NSMutableArray *directoryTree = [[NSMutableArray alloc] initWithCapacity:0];
	
	NSDirectoryEnumerator *enumerator = [self fullEnumeratorForRootURL:rootURL];
	
	NSString *keyFolderName = @"_name";
	NSString *keyFolderFiles = @"files";
	
	NSMutableDictionary *folder = nil;
	NSMutableArray *files = nil;
	
	NSURL *nextObject = [enumerator nextObject];
	
	while (nextObject) {		
		NSString *absoluteString = nextObject.absoluteString;
		NSArray *components = [absoluteString componentsSeparatedByString:@"/"];
		NSString *pathComponent = [components objectAtIndex:[components count] -1];
		
		if ([pathComponent isEqualToString:@""]) {
			NSString *pathComponent = [components objectAtIndex:[components count] -2];
			
			if (folder) {
				[directoryTree addObject:folder];
				
				files = nil;
				folder = nil;
			}
						
			if (folder == nil) {
				folder = [[NSMutableDictionary alloc] initWithCapacity:0];
				[folder setObject:pathComponent forKey:keyFolderName];
				
				files = [[NSMutableArray alloc] initWithCapacity:0];
				[folder setObject:files forKey:keyFolderFiles];
			}
		}
		else {
			
			if (files == nil && folder == nil) {
				[directoryTree addObject:pathComponent];
			}
			else if	(folder){
				if (files == nil) {
					files = [[NSMutableArray alloc] initWithCapacity:0];
				}
				
				[files addObject:pathComponent];
			}
		}
		
		nextObject = [enumerator nextObject];
	}
	
	if (folder) {
		[directoryTree addObject:folder];
		
		files = nil;
		folder = nil;
	}
	
	if ([directoryTree count] == 0) {
		directoryTree = nil;
	}
	
	return directoryTree;
}

@end
