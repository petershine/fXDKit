//
//  FXDFetchedResultsController.m
//  PopTooUniversal
//
//  Created by Peter SHINe on 7/4/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDFetchedResultsController.h"


#pragma mark - Private interface
@interface FXDFetchedResultsController (Private)
@end


#pragma mark - Public implementation
@implementation FXDFetchedResultsController

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management


#pragma mark - Initialization
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
	self = [super initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		_dynamicDelegate = nil;
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
@implementation FXDFetchedResultsController (Added)
@end
