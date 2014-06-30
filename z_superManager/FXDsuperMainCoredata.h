//
//  FXDsuperMainCoredata.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

//MARK: For subclass to define names or keys
/* SAMPLE:
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


@import CoreData;


#import "FXDsuperManager.h"
@interface FXDsuperMainCoredata : FXDsuperManager {

	BOOL _shouldMergeForManagedContext;
	BOOL _didStartEnumerating;
	
	UIBackgroundTaskIdentifier _enumeratingTask;
	UIBackgroundTaskIdentifier _dataSavingTask;

	NSString *_mainModelName;
	FXDManagedDocument *_mainDocument;
	
	NSString *_mainSqlitePathComponent;
	NSString *_mainUbiquitousContentName;

	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
}

@property (nonatomic) BOOL shouldMergeForManagedContext;
@property (nonatomic) BOOL didStartEnumerating;

@property (nonatomic) UIBackgroundTaskIdentifier enumeratingTask;
@property (nonatomic) UIBackgroundTaskIdentifier dataSavingTask;

@property (strong, nonatomic) NSString *mainModelName;
@property (strong, nonatomic) FXDManagedDocument *mainDocument;

@property (strong, nonatomic) NSString *mainSqlitePathComponent;
@property (strong, nonatomic) NSString *mainUbiquitousContentName;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;


#pragma mark - Public
- (void)initializeWithBundledSqliteFile:(NSString*)sqliteFile;
- (void)tranferFromOldSqliteFile:(NSString*)oldSqliteFile;
- (BOOL)doesStoredSqliteExist;
- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath;

- (void)prepareWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection finishCallback:(FXDcallbackFinish)finishCallback;

- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)startObservingCoreDataNotifications;


- (NSManagedObject*)initializedMainEntityObj;

- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)enumerateAllMainEntityObjShouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)enumerateAllMainEntityObjShouldUsePrivateContext:(BOOL)shouldUsePrivateContext shouldSaveAtTheEnd:(BOOL)shouldSaveAtTheEnd shouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: Saving methods
- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)saveMainDocumentShouldSkipMerge:(BOOL)shouldSkipMerge withFinishCallback:(FXDcallbackFinish)finishCallback;


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
