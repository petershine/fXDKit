//
//  FXDsuperCoreDataManager.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef shouldUSE_iCloudCoreData
	#define shouldUSE_iCloudCoreData	0	//MARK: Until safely implement iCloudCoreData"
#endif

#if shouldUSE_iCloudCoreData
/* SAMPLE
 [[<#AppPrefix#>managerFile sharedInstance] startUpdatingUbiquityContainerURLwithDidFinishBlock:<#DidFinishBlock#>];
 */

#warning "//TODO: Add cloud DataQuery observing for transaction log updating"
#define notificationCloudDataQuery

#endif


//SAMPLE: For managing attribute names
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

#define notificationCoreDataManagerDidPrepare	@"notificationCoreDataManagerDidPrepare"


#import "FXDsuperCloudManager.h"


@interface FXDsuperCoreDataManager : FXDObject <NSFetchedResultsControllerDelegate> {

	BOOL _shouldMergeForManagedContext;
	BOOL _didStartEnumerating;
	
	UIBackgroundTaskIdentifier _enumeratingTaskIdentifier;
	
	UIManagedDocument *_mainDocument;
	
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

@property (strong, nonatomic) UIManagedDocument *mainDocument;

@property (strong, nonatomic) NSString *mainSqlitePathComponent;
@property (strong, nonatomic) NSString *mainUbiquitousContentName;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;


#pragma mark - Public
+ (FXDsuperCoreDataManager*)sharedInstance;

- (void)startObservingCoreDataNotifications;

- (void)prepareCoreDataManagerWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection didFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)initializeWithBundledCoreDataName:(NSString*)bundledSqlitePathComponent;
- (BOOL)isSqliteAlreadyInitialized;

- (id)initializedMainEntityObj;

- (void)deleteAllDataWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)enumerateAllMainEntityObjWithDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *mainManagedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext didFinishBlock:(FXDblockDidFinish)didFinishBlock;


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
