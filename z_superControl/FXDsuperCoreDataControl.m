//
//  FXDsuperCoreDataControl.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoreDataControl.h"
#import "FXDsuperCoreDataControl+CSVparser.h"


#pragma mark - Private interface
@interface FXDsuperCoreDataControl (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperCoreDataControl

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)initWithFileURL:(NSURL *)url {	FXDLog_DEFAULT;
	NSURL *applicationDocumentsDirectory = nil;
	
	if (url == nil) {
		applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		
		url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"managed.coredata.document"];
	}
	
	FXDLog(@"url: %@", url);
	
	self = [super initWithFileURL:url];
	
	if (self) {
		if (applicationDocumentsDirectory) {
			NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:applicationSqlitePathComponent];
			
			NSDictionary *options = @{	NSMigratePersistentStoresAutomaticallyOption: @YES,
										NSInferMappingModelAutomaticallyOption: @YES};
			
			NSError *error = nil;
			
			BOOL didConfigure = [self configurePersistentStoreCoordinatorForURL:storeURL
																		 ofType:NSSQLiteStoreType
															 modelConfiguration:nil
																   storeOptions:options
																		  error:&error];
			if (error || didConfigure == NO) {
				FXDLog_ERROR;
			}
			
#if ForDEVELOPER
			NSPersistentStoreCoordinator *storeCoordinator = self.managedObjectContext.persistentStoreCoordinator;
			
			for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
				FXDLog(@"persistentStore: %@", persistentStore);
				FXDLog(@"metadataForPersistentStore: %@", [storeCoordinator metadataForPersistentStore:persistentStore]);
			}
#endif
			
			NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
			
			[defaultCenter addObserver:self
							  selector:@selector(observedUIApplicationDidEnterBackground:)
								  name:UIApplicationDidEnterBackgroundNotification
								object:nil];
			
			[defaultCenter addObserver:self
							  selector:@selector(observedNSManagedObjectContextObjectsDidChange:)
								  name:NSManagedObjectContextObjectsDidChangeNotification
								object:self.managedObjectContext];
			
			[defaultCenter addObserver:self
							  selector:@selector(observedNSManagedObjectContextWillSave:)
								  name:NSManagedObjectContextWillSaveNotification
								object:self.managedObjectContext];
			
			[defaultCenter addObserver:self
							  selector:@selector(observedNSManagedObjectContextDidSave:)
								  name:NSManagedObjectContextDidSaveNotification
								object:self.managedObjectContext];
		}
		
		// Primitives
		
		// Instance variables
		
		// Properties
		_defaultEntityName = nil;
		_defaultSortDescriptors = nil;
				
		_fieldKeys = nil;
		_fieldValues = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSString*)defaultEntityName {
	if (_defaultEntityName == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultEntityName;
}

- (NSArray*)defaultSortDescriptors {
	if (_defaultSortDescriptors == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultSortDescriptors;
}

#pragma mark -
- (NSFetchedResultsController*)defaultFetchedResults {
	if (_defaultFetchedResults == nil) {	FXDLog_DEFAULT;
		_defaultFetchedResults = [self resultsControllerForEntityName:self.defaultEntityName
												andForSortDescriptors:self.defaultSortDescriptors
											 fromManagedObjectContext:self.managedObjectContext];
	}
	
	return _defaultFetchedResults;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] initWithFileURL:nil];
	});
	
    return _sharedInstance;
}

#pragma mark -
- (NSFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName andForSortDescriptors:(NSArray*)sortDescriptors fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {	FXDLog_DEFAULT;
	if (entityName == nil) {
		entityName = self.defaultEntityName;
	}
	
	if (sortDescriptors == nil) {
		sortDescriptors = self.defaultSortDescriptors;
	}
	
	if (managedObjectContext == nil) {
		managedObjectContext = self.managedObjectContext;
	}
	
	NSFetchedResultsController *resultsController = nil;
	
	if (entityName && sortDescriptors) {
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:entityDescription];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		[fetchRequest setFetchLimit:limitDefaultFetch];
		[fetchRequest setFetchBatchSize:sizeDefaultBatch];

		
		resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:entityName];
		
		NSError *error = nil;
		
		if ([resultsController performFetch:&error]) {
			FXDLog(@"resultsController count: %d", [resultsController.fetchedObjects count]);
		}
		
		if (error) {
			FXDLog_ERROR;
		}
	}
	
	return resultsController;
}

- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {	FXDLog_DEFAULT;
	NSManagedObject *resultObj = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];
	FXDLog(@"predicate: %@", predicate);
		
	NSArray *filteredArray = [self.defaultFetchedResults.fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] > 0) {
		resultObj = filteredArray[0];
		
		if ([filteredArray count] > 1) {
			FXDLog(@"filteredArray:\n%@", filteredArray);
		}
	}	
	
	return resultObj;
}

- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj {	FXDLog_OVERRIDE;
	FXDLog(@"collectionObj:%@", collectionObj);
	
}

#pragma mark -
- (void)saveContext {	FXDLog_SEPARATE;
    NSError *error = nil;
	
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
#if DEBUG
            FXDLog_ERROR;
            abort();
#endif
        }
    }
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(id)notification {	FXDLog_OVERRIDE;	
	// Usually [self saveContext] has been used
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(id)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);

}

- (void)observedNSManagedObjectContextWillSave:(id)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSManagedObjectContextDidSave:(id)notification {	FXDLog_OVERRIDE;
	
}


//MARK: - Delegate implementation


@end