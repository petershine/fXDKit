//
//  FXDsuperCoreDataManager.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef USE_iCloudCoreData
	#define USE_iCloudCoreData	0	//MARK: Until safely implement iCloudCoreData"
#endif

#if USE_iCloudCoreData
/* SAMPLE
 [[<#AppPrefix#>managerCoreData sharedInstance] startObservingFileManagerNotifications];
 [[<#AppPrefix#>managerFile sharedInstance] startUpdatingUbiquityContainerURL];
 */
#endif


//SAMPLE: For managing attribute names
/*
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attributekey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


#ifndef applicationSqlitePathComponent
	#define applicationSqlitePathComponent	[NSString stringWithFormat:@".%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
#endif

#ifndef ubiquitousCoreDataContentName
	#define ubiquitousCoreDataContentName @"coredata.store"
#endif


#ifndef documentnameManagedCoreData
	#define documentnameManagedCoreData	@"managed.coredata.document"
#endif


#define notificationCoreDataManagerDidPrepare	@"notificationCoreDataManagerDidPrepare"


#import "FXDsuperFileManager.h"

@interface FXDsuperCoreDataManager : FXDObject <NSFetchedResultsControllerDelegate> {
    // Primitives
	UIManagedDocument *_mainDocument;
	
	NSString *_mainSqlitePathComponent;
	NSString *_mainUbiquitousContentName;

	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
	
	FXDFetchedResultsController *_mainResultsController;
}

// Properties
@property (strong, nonatomic) UIManagedDocument *mainDocument;

@property (strong, nonatomic) NSString *mainSqlitePathComponent;
@property (strong, nonatomic) NSString *mainUbiquitousContentName;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;


#pragma mark - Public
+ (FXDsuperCoreDataManager*)sharedInstance;

- (void)startObservingFileManagerNotifications;
- (void)startObservingCoreDataNotifications;

- (void)prepareCoreDataManagerWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection didFinishBlock:(void(^)(BOOL finished))didFinishBlock;
- (void)initializeWithBundledCoreDataName:(NSString*)bundledSqlitePathComponent;
- (BOOL)isSqliteAlreadyInitialized;

- (id)initializedMainEntityObj;

- (void)enumerateAllMainEntityObjWithDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *mainManagedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(void(^)(BOOL finished))didFinishBlock;

- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext didFinishBlock:(void(^)(BOOL finished))didFinishBlock;


//MARK: - Observer implementation
#warning "TODO: When it's found to be following observing is not necessary, remove them out"
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
