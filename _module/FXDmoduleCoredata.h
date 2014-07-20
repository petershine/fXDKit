
#import "FXDKit.h"

//MARK: For subclass to define names or keys
/* SAMPLE:
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


@import CoreData;


@interface FXDmoduleCoredata : FXDsuperModule {

	BOOL _shouldMergeForManagedContext;
	BOOL _didStartEnumerating;
	
	UIBackgroundTaskIdentifier _enumeratingTask;
	UIBackgroundTaskIdentifier _dataSavingTask;

	NSString *_mainModelName;
	NSString *_mainUbiquitousContentName;
	NSString *_mainSqlitePathComponent;

	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
}

@property (nonatomic) BOOL shouldMergeForManagedContext;
@property (nonatomic) BOOL didStartEnumerating;

@property (nonatomic) UIBackgroundTaskIdentifier enumeratingTask;
@property (nonatomic) UIBackgroundTaskIdentifier dataSavingTask;

@property (strong, nonatomic) NSString *mainModelName;
@property (strong, nonatomic) NSString *mainUbiquitousContentName;
@property (strong, nonatomic) NSString *mainSqlitePathComponent;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDManagedDocument *mainDocument;


- (void)initializeWithBundledSqliteFile:(NSString*)sqliteFile;
- (void)tranferFromOldSqliteFile:(NSString*)oldSqliteFile;
- (BOOL)doesStoredSqliteExist;
- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath;

#warning //TODO: Add option for selecting xcdatamodel
/*
 NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PopToo2015" withExtension:@"momd"];
 _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
 return _managedObjectModel;
 */
//http://stackoverflow.com/questions/16146289/is-it-possilbe-to-have-mutliple-core-data-model-files-to-one-single-xcode-projec
- (void)prepareWithMOMDfilename:(NSString*)MOMDfilename withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection finishCallback:(FXDcallbackFinish)finishCallback;

- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)startObservingCoreDataNotifications;


- (NSManagedObject*)initializedMainEntityObj;

- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)enumerateAllMainEntityObjShouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)enumerateAllMainEntityObjShouldUsePrivateContext:(BOOL)shouldUsePrivateContext shouldSaveAtTheEnd:(BOOL)shouldSaveAtTheEnd shouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback;


- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)saveMainDocumentShouldSkipMerge:(BOOL)shouldSkipMerge withFinishCallback:(FXDcallbackFinish)finishCallback;


#pragma mark - Observer
- (void)observedUIDocumentStateChanged:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

#pragma mark - Delegate

@end
