

//MARK: For subclass to define names or keys
/* SAMPLE:
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


#import <fXDObjC/FXDimportEssential.h>
#import <fXDObjC/FXDOperationQueue.h>
#import <fXDObjC/FXDManagedObjectContext.h>
#import <fXDObjC/FXDManagedDocument.h>
#import <fXDObjC/FXDFileManager.h>


@interface FXDmoduleCoredata : NSObject {
	UIBackgroundTaskIdentifier _enumeratingTask;
	UIBackgroundTaskIdentifier _dataSavingTask;

	NSOperationQueue *_enumeratingOperationQueue;

	NSString *_coredataName;
	NSString *_ubiquitousContentName;
	NSString *_sqlitePathComponent;

	NSString *_mainEntityName;
	NSArray *_mainSortDescriptors;
}

@property (nonatomic) UIBackgroundTaskIdentifier enumeratingTask;
@property (nonatomic) UIBackgroundTaskIdentifier dataSavingTask;

@property (strong, nonatomic) NSOperationQueue *enumeratingOperationQueue;

@property (strong, nonatomic) NSString *coredataName;
@property (strong, nonatomic) NSString *ubiquitousContentName;
@property (strong, nonatomic) NSString *sqlitePathComponent;

@property (strong, nonatomic) NSString *mainEntityName;
@property (strong, nonatomic) NSArray *mainSortDescriptors;

@property (strong, nonatomic) FXDManagedDocument *mainDocument;


- (void)initializeWithBundledSqliteFile:(NSString*)sqliteFile;
- (void)tranferFromOldSqliteFile:(NSString*)oldSqliteFile;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL doesStoredSqliteExist;
- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath;


- (void)prepareWithUbiquityContainerURL:(nullable NSURL*)ubiquityContainerURL protectionOption:(nullable NSString*)protectionOption managedDocument:(nullable FXDManagedDocument*)managedDocument finishCallback:(FXDcallbackFinish)finishCallback;

- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)startObservingCoreDataNotifications;


- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)enumerateAllDataWithPrivateContext:(BOOL)shouldUsePrivateContext shouldShowInformationView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback;


- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)saveMainDocumentWithFinishCallback:(FXDcallbackFinish)finishCallback;


- (void)observedUIDocumentStateChanged:(NSNotification*)notification;

- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification;
- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification;
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification;

- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification;

@end
