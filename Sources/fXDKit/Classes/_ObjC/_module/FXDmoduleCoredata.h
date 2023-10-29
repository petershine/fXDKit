

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

@property (strong, nonatomic) NSOperationQueue * _Nullable enumeratingOperationQueue;

@property (strong, nonatomic) NSString * _Nullable coredataName;
@property (strong, nonatomic) NSString * _Nullable ubiquitousContentName;
@property (strong, nonatomic) NSString * _Nullable sqlitePathComponent;

@property (strong, nonatomic) NSString * _Nullable mainEntityName;
@property (strong, nonatomic) NSArray * _Nullable mainSortDescriptors;

@property (strong, nonatomic) FXDManagedDocument * _Nullable mainDocument;


- (void)initializeWithBundledSqliteFile:(NSString*_Nullable)sqliteFile;
- (void)transferFromOldSqliteFile:(NSString*_Nullable)oldSqliteFile;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL doesStoredSqliteExist;
- (BOOL)storeCopiedItemFromSqlitePath:(NSString* _Nullable)sqlitePath toStoredPath:(NSString* _Nullable)storedPath;


- (void)prepareWithUbiquityContainerURL:(nullable NSURL*)ubiquityContainerURL protectionOption:(nullable NSString*)protectionOption managedDocument:(nullable FXDManagedDocument*)managedDocument finishCallback:(FXDcallbackFinish _Nullable)finishCallback;

- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish _Nullable)finishCallback;

- (void)startObservingCoreDataNotifications;


- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish _Nullable)finishCallback;

- (void)enumerateAllDataWithPrivateContext:(BOOL)shouldUsePrivateContext shouldShowInformationView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^_Nullable)(NSManagedObjectContext * _Nullable managedContext, NSManagedObject * _Nullable mainEntityObj, BOOL * _Nullable shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish _Nullable)finishCallback;


- (void)saveManagedContext:(NSManagedObjectContext* _Nullable)managedContext withFinishCallback:(FXDcallbackFinish _Nullable)finishCallback;
- (void)saveMainDocumentWithFinishCallback:(FXDcallbackFinish _Nullable)finishCallback;


- (void)observedNSManagedObjectContextDidSave:(NSNotification* _Nullable)notification;

@end
