//
//  FXDsuperCoreDataControl.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef USE_loggingResultObjFiltering
	#define USE_loggingResultObjFiltering	0
#endif


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
+ (FXDsuperCoreDataControl*)sharedInstance;

- (void)startObservingFileControlNotifications;
- (void)prepareCoreDataControlWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL forFinishedHandler:(void(^)(BOOL didFinish))finishedHandler;
- (void)prepareCoredataControlObserverMethods;


- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (FXDManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue fromResultsController:(FXDFetchedResultsController*)resultsController;
- (void)insertNewObjectForMainEntityNameWithCollectionObj:(id)collectionObj;

- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

- (void)observedPrivateManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedPrivateManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedPrivateManagedObjectContextDidSave:(NSNotification*)notification;


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate


@end
