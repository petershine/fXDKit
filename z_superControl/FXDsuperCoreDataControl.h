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

#ifndef documentnameManagedCoreData
	#define documentnameManagedCoreData	@"managed.coredata.document"
#endif


#define limitDefaultFetch	500
#define sizeDefaultBatch	10


@interface FXDsuperCoreDataControl : UIManagedDocument <NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	NSString *_defaultEntityName;
	NSArray *_defaultSortDescriptors;
	
	FXDFetchedResultsController *_defaultResultsController;

	NSMutableArray *_fieldKeys;
	NSMutableArray *_fieldValues;
}

// Properties
@property (strong, nonatomic) NSString *defaultEntityName;
@property (strong, nonatomic) NSArray *defaultSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *defaultResultsController;

@property (strong, nonatomic) NSMutableArray *fieldKeys;
@property (strong, nonatomic) NSMutableArray *fieldValues;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance;

- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj;

- (void)saveContext;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(id)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(id)notification;
- (void)observedNSManagedObjectContextWillSave:(id)notification;
- (void)observedNSManagedObjectContextDidSave:(id)notification;

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate


@end
