//
//  FXDsuperCoreDataControl.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <CoreData/CoreData.h>


#ifndef applicationSqlitePathComponent
	#define applicationSqlitePathComponent	[NSString stringWithFormat:@"%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
#endif


#define limitDefaultFetch	500
#define sizeDefaultBatch	100


@interface FXDsuperCoreDataControl : UIManagedDocument {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	NSString *_defaultEntityName;
	NSArray *_defaultSortDescriptors;
	
	NSFetchedResultsController *_defaultFetchedResults;

	NSMutableArray *_fieldKeys;
	NSMutableArray *_fieldValues;
}

// Properties
@property (strong, nonatomic) NSString *defaultEntityName;
@property (strong, nonatomic) NSArray *defaultSortDescriptors;

@property (strong, nonatomic) NSFetchedResultsController *defaultFetchedResults;

@property (strong, nonatomic) NSMutableArray *fieldKeys;
@property (strong, nonatomic) NSMutableArray *fieldValues;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance;

- (NSFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName andForSortDescriptors:(NSArray*)sortDescriptors fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj;

- (void)saveContext;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(id)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(id)notification;
- (void)observedNSManagedObjectContextWillSave:(id)notification;
- (void)observedNSManagedObjectContextDidSave:(id)notification;

//MARK: - Delegate implementation


@end
