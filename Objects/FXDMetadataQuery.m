//
//  FXDMetadataQuery.m
//  EasyFileSharing
//
//  Created by petershine on 7/10/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDMetadataQuery.h"


#pragma mark - Private interface
@interface FXDMetadataQuery (Private)
@end


#pragma mark - Public implementation
@implementation FXDMetadataQuery

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
@implementation NSMetadataQuery (Added)
- (void)applyDefaultConfiguration {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K >= %@", NSMetadataItemFSContentChangeDateKey, [NSDate date]];
	
	NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithCapacity:0];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:NSMetadataItemFSContentChangeDateKey ascending:NO];
	[sortDescriptors addObject:descriptor];
	
	[self setPredicate:predicate];
	[self setSortDescriptors:sortDescriptors];
	
	[self setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
}

- (NSDictionary*)descriptionDictionary {
	NSMutableDictionary *descriptionDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[descriptionDictionary setObject:[self searchScopes] forKey:@"searchScopes"];
	//[descriptionDictionary setObject:[self valueListAttributes] forKey:@"valueListAttributes"];
	//[descriptionDictionary setObject:[self groupingAttributes] forKey:@"groupingAttributes"];
	[descriptionDictionary setObject:[self results] forKey:@"results"];
	//[descriptionDictionary setObject:[self valueLists] forKey:@"valueLists"];
	//[descriptionDictionary setObject:[self groupedResults] forKey:@"groupedResults"];
	
	return descriptionDictionary;
}


@end