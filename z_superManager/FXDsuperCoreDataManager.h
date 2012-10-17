//
//  FXDsuperCoreDataManager.h
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


#define notificationCoreDataControlDidPrepare	@"notificationCoreDataControlDidPrepare"


#import "FXDKit.h"

#import <CoreData/CoreData.h>

#import "FXDsuperFileManager.h"


@interface FXDsuperCoreDataManager : UIManagedDocument <NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
	
	FXDFetchedResultsController *_mainResultsController;
}

// Properties
@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSMutableArray *fieldValues;
@property (strong, nonatomic) NSMutableArray *fieldKeys;


#pragma mark - Public
+ (FXDsuperCoreDataManager*)sharedInstance;

- (void)startObservingFileControlNotifications;
- (void)prepareCoreDataControlWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL forFinishedHandler:(void(^)(BOOL didFinish))finishedHandler;
- (void)prepareCoredataControlObserverMethods;


- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSMutableArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (FXDManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue fromResultsController:(FXDFetchedResultsController*)resultsController;
- (void)insertNewObjectForMainEntityNameWithCollectionObj:(id)collectionObj;

- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext forFinishedBlock:(void(^)(void))finishedBlock;


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
