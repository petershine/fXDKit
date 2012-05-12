//
//  FXDsuperCoreDataControl.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoreDataControl.h"


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

// Controllers


#pragma mark - Memory management
- (void)dealloc {
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
	
    // Controllers
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
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
		
        // Controllers
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
	
	FXDLog_SEPARATE;
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:applicationMOMDURL withExtension:@"momd"];
	
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
	
	FXDLog_SEPARATE;
    
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
		if (_defaultFetchedResults == nil) {	FXDLog_DEFAULT;
			
			FXDLog(@"defaultEntityName: %@", self.defaultEntityName);
			FXDLog(@"defaultSortDescriptorKeys: %@", self.defaultSortDescriptorKeys);
			
			if (self.defaultEntityName && self.defaultSortDescriptorKeys) {
				NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
				[fetchRequest autorelease];
				

				NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.defaultEntityName inManagedObjectContext:self.managedObjectContext];				
				FXDLog(@"entityDescription propertiesByName:\n%@", [entityDescription propertiesByName]);
				
				[fetchRequest setEntity:entityDescription];
				[fetchRequest setSortDescriptors:self.defaultSortDescriptorKeys];
				
				fetchRequest.fetchLimit = limitDefaultFetch;
				fetchRequest.fetchBatchSize = sizeDefaultBatch;
				
				FXDLog(@"fetchRequest:\n%@", fetchRequest);
				
				
				_defaultFetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:self.defaultEntityName];
				
				[_defaultFetchedResults setDelegate:self];
				
				
				NSError *error = nil;
				
				if ([_defaultFetchedResults performFetch:&error]) {
					FXDLog(@"FETCHED");
				}
				else {
					if (error) {
						FXDLog_ERROR;
					}
				}
			}
		}
	}
	
	return _defaultFetchedResults;
}


// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
static FXDsuperCoreDataControl *_sharedInstance = nil;

+ (FXDsuperCoreDataControl*)sharedInstance {
	@synchronized(self) {		
        if (_sharedInstance == nil) {	FXDLog_DEFAULT;
            _sharedInstance = [[self alloc] init];
        }
	}
	
	return _sharedInstance;
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		if (_sharedInstance) {	FXDLog_DEFAULT;
			
			[_sharedInstance release];
			_sharedInstance = nil;
		}
	}
}

#pragma mark -
+ (NSManagedObjectContext*)managedObjectContext {	FXDLog_DEFAULT;
	return [[self sharedInstance] managedObjectContext];
}

+ (void)saveManagedObjectContext {	FXDLog_SEPARATE;
	[[self sharedInstance] saveContext];
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
- (void)startByPerformingDefaultFetchedResults {	FXDLog_OVERRIDE;
	FXDLog(@"defaultFetchedResults.fetchedObjects: %@", self.defaultFetchedResults.fetchedObjects);
	
}

- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj {	FXDLog_OVERRIDE;
	FXDLog(@"collectionObj:%@", collectionObj);
	
}


#pragma mark -
- (void)parseFromCSVfileName:(NSString*)csvFileName {	FXDLog_DEFAULT;
	NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:csvFileName ofType:@"csv"];
	
	NSError *error = nil;
	
	CHCSVParser *csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:csvFilePath encoding:NSUTF8StringEncoding error:&error];
	[csvParser setParserDelegate:self];
	
	[csvParser parse];
	
	if (error) {
		FXDLog_ERROR;
	}
}

- (void)insertParsedObjForEntityName:(NSString*)entityName usingKeys:(NSArray*)keys usingValues:(NSArray*)values {	FXDLog_DEFAULT;
	
	NSMutableDictionary *keysWithValues = [[NSMutableDictionary alloc] initWithCapacity:0];
	[keysWithValues autorelease];
	
	for (NSInteger i = 0; i < [keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];
		NSString *value = [values objectAtIndex:i];
		
		[keysWithValues setValue:value forKey:key];
	}
	
	//FXDLog(@"keysWithValues:\n%@", keysWithValues);
	
	NSManagedObject *insertedObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
	
	[insertedObj setValuesForKeysWithDictionary:keysWithValues dateFormatter:nil];
	
	FXDLog(@"insertedObj: %@", insertedObj);
}

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


#pragma mark - CHCSVParserDelegate
- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {	FXDLog_DEFAULT;
	FXDLog(@"csvFile: %@", csvFile);
}

- (void) parser:(CHCSVParser *)parser didStartLine:(NSUInteger)lineNumber {
	
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field {
	//FXDLog(@"field: %@", field);
	
	if (self.fieldValues == nil) {
		self.fieldValues = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	}
	
	[self.fieldValues addObject:field];
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber {
	//FXDLog(@"lineNumber: %u\n%@", lineNumber, self.fieldValues);
	
	if (lineNumber == 1) {	// Assume this is key line
		self.fieldKeys = nil;
		self.fieldKeys = [[[NSMutableArray alloc] initWithArray:self.fieldValues] autorelease];
	}
	else {
		if (self.fieldKeys) {
			[self insertParsedObjForEntityName:self.defaultEntityName usingKeys:self.fieldKeys usingValues:self.fieldValues];
		}
	}
	
	self.fieldValues = nil;
}

- (void) parser:(CHCSVParser *)parser didEndDocument:(NSString *)csvFile {	FXDLog_DEFAULT;
	[parser release];
	
	self.fieldKeys = nil;
	
	[self saveContext];
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {	FXDLog_DEFAULT;
	if (error) {
		FXDLog_ERROR;
	}
	
	[parser release];
	
	self.fieldKeys = nil;
	self.fieldValues = nil;
	
	[self saveContext];
}


@end