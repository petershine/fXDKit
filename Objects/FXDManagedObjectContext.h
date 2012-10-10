//
//  FXDManagedObjectContext.h
//
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#import "FXDKit.h"


#import <CoreData/CoreData.h>

@interface FXDManagedObjectContext : NSManagedObjectContext {
    // Primitives

	// Instance variables

	// Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface NSManagedObjectContext (Added)
- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;
- (NSMutableArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

@end
