//
//  FXDsuperCoreDataControl.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef applicationSqlitePathComponent
	#define applicationSqlitePathComponent	[NSString stringWithFormat:@"%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
#endif

#ifndef ubiquitousCoreDataContentName
	#define ubiquitousCoreDataContentName @"coredata.store"
#endif

#ifndef documentnameManagedCoreData
	#define documentnameManagedCoreData	@"managed.coredata.document"
#endif


#ifndef limitDefaultFetch
	#define limitDefaultFetch	1000
#endif

#ifndef sizeDefaultBatch
	#define sizeDefaultBatch	10
#endif


#define notificationCoreDataControlDidPrepare	@"notificationCoreDataControlDidPrepare"


#import "FXDKit.h"

#import <CoreData/CoreData.h>

#import "FXDsuperFileControl.h"


@interface FXDsuperCoreDataControl : UIManagedDocument <NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	
    // Properties : For accessor overriding
	NSString *_defaultEntityName;
	NSArray *_defaultSortDescriptors;
	
	FXDFetchedResultsController *_defaultResultsController;
}

// Properties
@property (strong, nonatomic) NSString *defaultEntityName;
@property (strong, nonatomic) NSArray *defaultSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *defaultResultsController;


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance;

- (void)startObservingFileControlNotifications;
- (void)prepareCoreDataControlUsingUbiquityContainerURL:(NSURL*)ubiquityContainerURL;

- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj;

- (void)saveContext;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate


@end
