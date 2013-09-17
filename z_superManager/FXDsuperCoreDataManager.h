//
//  FXDsuperCoreDataManager.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


/*
#define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
#define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


#ifndef applicationSqlitePathComponent
	#if ForDEVELOPER
		#define applicationSqlitePathComponent	[NSString stringWithFormat:@"%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
	#else
		#define applicationSqlitePathComponent	[NSString stringWithFormat:@".%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]
	#endif
#endif

#ifndef ubiquitousCoreDataContentName
	#define ubiquitousCoreDataContentName @"coredata.store"
#endif

#ifndef documentnameManagedCoreData
	#define documentnameManagedCoreData	@"managed.coredata.document"
#endif

#ifndef documentURLmanagedCoreData
	#define documentURLmanagedCoreData	[appDirectory_Document URLByAppendingPathComponent:documentnameManagedCoreData]
#endif


#ifndef USE_iCloudCoreData
	#define USE_iCloudCoreData	0	//MARK: Until safely implement iCloudCoreData"
#endif

#if USE_iCloudCoreData
//[[<#AppPrefix#>managerFile sharedInstance] startUpdatingUbiquityContainerURLwithDidFinishBlock:<#DidFinishBlock#>];
#endif



#define notificationCoreDataManagerDidPrepare	@"notificationCoreDataManagerDidPrepare"


#import "FXDsuperCloudManager.h"


@interface FXDsuperCoreDataManager : FXDObject <NSFetchedResultsControllerDelegate> {

	BOOL _shouldMergeForManagedContext;
	BOOL _didStartEnumerating;
	
	UIBackgroundTaskIdentifier _enumeratingTaskIdentifier;
	UIBackgroundTaskIdentifier _savingTaskIdentifier;
	
	FXDManagedDocument *_mainDocument;
	
	NSString *_mainSqlitePathComponent;
	NSString *_mainUbiquitousContentName;

	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
	
	FXDFetchedResultsController *_mainResultsController;
}

// Properties
@property (nonatomic) BOOL shouldMergeForManagedContext;
@property (nonatomic) BOOL didStartEnumerating;

@property (nonatomic) UIBackgroundTaskIdentifier enumeratingTaskIdentifier;
@property (nonatomic) UIBackgroundTaskIdentifier savingTaskIdentifier;

@property (strong, nonatomic) FXDManagedDocument *mainDocument;

@property (strong, nonatomic) NSString *mainSqlitePathComponent;
@property (strong, nonatomic) NSString *mainUbiquitousContentName;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;


#pragma mark - Public
+ (FXDsuperCoreDataManager*)sharedInstance;

- (void)prepareCoreDataManagerWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection didFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)upgradeAllAttributesForNewDataModelWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)startObservingCoreDataNotifications;

- (void)initializeWithBundledCoreDataName:(NSString*)bundledSqlitePathComponent;
- (BOOL)isSqliteAlreadyInitialized;


- (id)initializedMainEntityObj;

- (void)deleteAllDataWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)enumerateAllMainEntityObjWithDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)enumerateAllMainEntityObjShouldUsePrivateContext:(BOOL)shouldUsePrivateContext shouldSaveAtTheEnd:(BOOL)shouldSaveAtTheEnd withDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;


- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)saveMainDocumentShouldSkipMerge:(BOOL)shouldSkipMerge withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedUIDocumentStateChanged:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
