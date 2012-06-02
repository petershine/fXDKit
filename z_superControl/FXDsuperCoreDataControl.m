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
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize defaultEntityName = _defaultEntityName;
@synthesize defaultSortDescriptorKeys = _defaultSortDescriptorKeys;
@synthesize defaultFetchedResults = _defaultFetchedResults;

@synthesize fieldKeys = _fieldKeys;
@synthesize fieldValues = _fieldValues;


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
	[__managedObjectContext release];
	[__managedObjectModel release];
	[__persistentStoreCoordinator release];
	
	[_defaultEntityName release];
	[_defaultSortDescriptorKeys release];
	[_defaultFetchedResults release];
	
	[_fieldKeys release];
	[_fieldValues release];
		
    [super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(observedApplicationDidEnterBackground:)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];

		// Primitives
		
		// Instance variables
		
		// Properties
		__managedObjectContext = nil;
		__managedObjectModel = nil;
		__persistentStoreCoordinator = nil;
		
		_defaultEntityName = nil;
		_defaultSortDescriptorKeys = nil;
		_defaultFetchedResults = nil;
		
		_fieldKeys = nil;
		_fieldValues = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext {

    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
	
	FXDLog_SEPARATE;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
	
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {

    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
	
	FXDLog_DEFAULT;
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:applicationMOMDURL withExtension:@"momd"];
	
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
	
	FXDLog_DEFAULT;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:applicationSqlitePathComponent];
    
    NSError *error = nil;
	
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

#if DEBUG
		FXDLog_ERROR;
		abort();
#endif
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark -
- (NSString*)defaultEntityName {
	if (_defaultEntityName == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultEntityName;
}

- (NSArray*)defaultSortDescriptorKeys {
	if (_defaultSortDescriptorKeys == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultSortDescriptorKeys;
}

- (NSFetchedResultsController*)defaultFetchedResults {
	@synchronized(self) {
		if (_defaultFetchedResults == nil) {
			
			if (self.defaultEntityName && self.defaultSortDescriptorKeys) {				

				NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.defaultEntityName inManagedObjectContext:self.managedObjectContext];
				
				FXDLog_SEPARATE;
				//FXDLog(@"entityDescription propertiesByName:\n%@", [entityDescription propertiesByName]);
								
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest autorelease];
				
				[fetchRequest setEntity:entityDescription];
				[fetchRequest setSortDescriptors:self.defaultSortDescriptorKeys];
				
#ifdef limitDefaultFetch
				fetchRequest.fetchLimit = limitDefaultFetch;
#endif
				fetchRequest.fetchBatchSize = sizeDefaultBatch;
				
				FXDLog(@"fetchRequest:\n%@", fetchRequest);
				
				
				_defaultFetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:self.defaultEntityName];
				
				[_defaultFetchedResults setDelegate:self];
				
				
				NSError *error = nil;
				
				if ([_defaultFetchedResults performFetch:&error]) {
					FXDLog(@"fetchedObjects count: %d", [_defaultFetchedResults.fetchedObjects count]);
				}
				else {
					if (error) {
						FXDLog_ERROR;
					}
				}
			}
			else {	FXDLog_SEPARATE;
				FXDLog(@"defaultEntityName: %@", self.defaultEntityName);
				FXDLog(@"defaultSortDescriptorKeys: %@", self.defaultSortDescriptorKeys);
			}
		}
	}
	
	return _defaultFetchedResults;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
static FXDsuperCoreDataControl *_sharedInstance = nil;

+ (FXDsuperCoreDataControl*)sharedInstance {
	@synchronized(self) {		
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
	}
	
	return _sharedInstance;
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		if (_sharedInstance) {
			
			[_sharedInstance release];
			_sharedInstance = nil;
		}
	}
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

#pragma mark - Application's Documents directory
- (NSURL*)applicationDocumentsDirectory {	FXDLog_DEFAULT;	
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
- (void)startByFetchingDefaultResults {
	NSFetchedResultsController *defaultFetchedResults = self.defaultFetchedResults;
	
	FXDLog_OVERRIDE;
	//FXDLog(@"defaultFetchedResults.fetchedObjects: %@", defaultFetchedResults.fetchedObjects);
	FXDLog(@"defaultFetchedResults.fetchedObjects: %d", [defaultFetchedResults.fetchedObjects count]);
}

- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj {	FXDLog_OVERRIDE;
	FXDLog(@"collectionObj:%@", collectionObj);
	
}


#pragma mark -
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {	FXDLog_DEFAULT;
	NSManagedObject *resultObj = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];
	FXDLog(@"predicate: %@", predicate);
	
	NSArray *filteredArray = [self.defaultFetchedResults.fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] > 0) {
		resultObj = [filteredArray objectAtIndex:0];
		
		if ([filteredArray count] > 1) {
			FXDLog(@"filteredArray:\n%@", filteredArray);
		}
	}	
	
	return resultObj;
}

//MARK: - Observer implementation
- (void)observedApplicationDidEnterBackground:(id)notification {	FXDLog_DEFAULT;
	[self saveContext];
	
}

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {	FXDLog_OVERRIDE;
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {	FXDLog_OVERRIDE;
	
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {	FXDLog_OVERRIDE;
	
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {	FXDLog_OVERRIDE;
	
}


@end