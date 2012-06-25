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


#define limitDefaultFetch	1000
#define sizeDefaultBatch	100


@interface FXDsuperCoreDataControl : FXDObject <NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
	NSManagedObjectContext *_managedObjectContext;
	
	NSString *_defaultEntityName;
	NSArray *_defaultSortDescriptorKeys;
	NSFetchedResultsController *_defaultFetchedResults;
	
	NSMutableArray *_fieldKeys;
	NSMutableArray *_fieldValues;
}

// Properties
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *defaultEntityName;
@property (strong, nonatomic) NSArray *defaultSortDescriptorKeys;
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

- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;

- (void)startByFetchingDefaultResults;
- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj;

- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(id)notification;

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate


@end
