//
//  FXDsuperCoreDataControl.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CHCSV.h"


#ifndef applicationMOMDURL
	#define applicationMOMDURL	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#endif

#ifndef applicationSqlitePathComponent
	#define applicationSqlitePathComponent	[NSString stringWithFormat:@"%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
#endif


#define limitDefaultFetch	100
#define sizeDefaultBatch	10


@interface FXDsuperCoreDataControl : FXDObject <NSFetchedResultsControllerDelegate, CHCSVParserDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
	
	NSString *_defaultEntityName;
	NSArray *_defaultSortDescriptorKeys;
	NSFetchedResultsController *_defaultFetchedResults;
	
	NSMutableArray *_fieldKeys;
	NSMutableArray *_fieldValues;
}

// Properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain, nonatomic) NSString *defaultEntityName;
@property (retain, nonatomic) NSArray *defaultSortDescriptorKeys;
@property (retain, nonatomic) NSFetchedResultsController *defaultFetchedResults;

@property (retain, nonatomic) NSMutableArray *fieldKeys;
@property (retain, nonatomic) NSMutableArray *fieldValues;

// Controllers


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance;
+ (void)releaseSharedInstance;

+ (NSManagedObjectContext*)managedObjectContext;
+ (void)saveManagedObjectContext;

- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;

- (void)startByPerformingDefaultFetchedResults;
- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj;

- (void)parseFromCSVfileName:(NSString*)csvFileName;
- (void)insertParsedObjForEntityName:(NSString*)entityName usingKeys:(NSArray*)keys usingValues:(NSArray*)values;
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
#pragma mark - CHCSVParserDelegate


@end
