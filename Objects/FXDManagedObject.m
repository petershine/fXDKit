//
//  FXDManagedObject.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDManagedObject.h"


#pragma mark - Public implementation
@implementation FXDManagedObject


#pragma mark - Memory management


#pragma mark - Initialization
#if USE_loggingManagedObjectActivities
- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {	FXDLog_DEFAULT;
	FXDLog(@"entity name: %@ context.concurrencyType: %d", [entity name], context.concurrencyType);
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];

	if (self) {
		// Primitives

		// Instance variables

		// Properties
	}

	return self;
}

// invoked after a fetch or after unfaulting (commonly used for computing derived values from the persisted properties)
- (void)awakeFromFetch {	//FXDLog_DEFAULT;
	[super awakeFromFetch];

}

// invoked after an insert (commonly used for initializing special default/initial settings)
- (void)awakeFromInsert {	FXDLog_DEFAULT;
	[super awakeFromInsert];
}

/* Callback for undo, redo, and other multi-property state resets */
- (void)awakeFromSnapshotEvents:(NSSnapshotEventType)flags NS_AVAILABLE(10_6,3_0) {	FXDLog_DEFAULT;
	FXDLog(@"flags: %u", flags);

	[super awakeFromSnapshotEvents:flags];
}
#endif


#pragma mark - Property overriding


#pragma mark - Method overriding
#if USE_loggingManagedObjectActivities
// lifecycle/change management (includes key-value observing methods)
- (void)willAccessValueForKey:(NSString *)key {	//FXDLog_DEFAULT;
	// read notification

	//FXDLog(@"key: %@", key);

	[super willAccessValueForKey:key];
}

- (void)didAccessValueForKey:(NSString *)key {	//FXDLog_DEFAULT;
	// read notification (together with willAccessValueForKey used to maintain inverse relationships, to fire faults, etc.) - each read access has to be wrapped in this method pair (in the same way as each write access has to be wrapped in the KVO method pair)

	//FXDLog(@"key: %@", key);

	[super didAccessValueForKey:key];
}

// KVO change notification
- (void)willChangeValueForKey:(NSString *)key {	FXDLog_DEFAULT;
	FXDLog(@"key: %@", key);

	[super willChangeValueForKey:key];
}

- (void)didChangeValueForKey:(NSString *)key {	FXDLog_DEFAULT;
	FXDLog(@"key: %@", key);

	[super didChangeValueForKey:key];
}

- (void)willChangeValueForKey:(NSString *)inKey withSetMutation:(NSKeyValueSetMutationKind)inMutationKind usingObjects:(NSSet *)inObjects {	FXDLog_DEFAULT;

	FXDLog(@"inKey: %@, inMutationKind: %u, inObjects: %@", inKey, inMutationKind, inObjects);

	[super willChangeValueForKey:inKey withSetMutation:inMutationKind usingObjects:inObjects];

}
- (void)didChangeValueForKey:(NSString *)inKey withSetMutation:(NSKeyValueSetMutationKind)inMutationKind usingObjects:(NSSet *)inObjects {	FXDLog_DEFAULT;

	FXDLog(@"inKey: %@, inMutationKind: %u, inObjects: %@", inKey, inMutationKind, inObjects);

	[super didChangeValueForKey:inKey withSetMutation:inMutationKind usingObjects:inObjects];
}

/* Callback before delete propagation while the object is still alive.  Useful to perform custom propagation before the relationships are torn down or reconfigure KVO observers. */
- (void)prepareForDeletion NS_AVAILABLE(10_6,3_0) {	FXDLog_DEFAULT;
	[super prepareForDeletion];
}

// commonly used to compute persisted values from other transient/scratchpad values, to set timestamps, etc. - this method can have "side effects" on the persisted values
- (void)willSave {	FXDLog_DEFAULT;
	[super willSave];
}

// commonly used to notify other objects after a save
- (void)didSave {	FXDLog_DEFAULT;
	[super didSave];
}

// invoked automatically by the Core Data framework before receiver is converted (back) to a fault.  This method is the companion of the -didTurnIntoFault method, and may be used to (re)set state which requires access to property values (for example, observers across keypaths.)  The default implementation does nothing.
- (void)willTurnIntoFault NS_AVAILABLE(10_5,3_0) {	FXDLog_DEFAULT;
	[super willTurnIntoFault];
}

// commonly used to clear out additional transient values or caches
- (void)didTurnIntoFault {	FXDLog_DEFAULT;
	[super didTurnIntoFault];
}

// validation - in addition to KVC validation managed objects have hooks to validate their lifecycle state; validation is a critical piece of functionality and the following methods are likely the most commonly overridden methods in custom subclasses
- (BOOL)validateValue:(id *)value forKey:(NSString *)key error:(NSError **)error {	FXDLog_DEFAULT;

	BOOL isValid = [super validateValue:value forKey:key error:error];

	FXDLog(@"isValid: %d, *value: %@, key: %@, *error: %@", isValid, *value, key, *error);

	return isValid;
}

- (BOOL)validateForDelete:(NSError **)error {	FXDLog_DEFAULT;
	BOOL isValid = [super validateForDelete:error];

	FXDLog(@"*isValid: %d, *error: %@", isValid,  *error);

	return isValid;
}

- (BOOL)validateForInsert:(NSError **)error {	FXDLog_DEFAULT;
	BOOL isValid = [super validateForInsert:error];

	FXDLog(@"*isValid: %d, *error: %@", isValid,  *error);

	return isValid;
}

- (BOOL)validateForUpdate:(NSError **)error {	FXDLog_DEFAULT;

	BOOL isValid = [super validateForUpdate:error];

	FXDLog(@"*isValid: %d, *error: %@", isValid,  *error);

	return isValid;
}

#endif


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSManagedObject (Added)
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter {
    NSDictionary *attributes = [[self entity] attributesByName];
	
    for (NSString *attribute in attributes) {
		id value = keyedValues[attribute];
		
		//MARK: Check cases
		if (value == nil) {
			value = keyedValues[[attribute uppercaseString]];
		}
		
		if (value == nil) {
			value = keyedValues[[attribute lowercaseString]];
		}
		
        if (value == nil) {
            continue;	// EMPTY
        }
		
        NSAttributeType attributeType = [attributes[attribute] attributeType];
		
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [[value stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
		else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = @([value integerValue]);
        }
		else if ((attributeType == NSFloatAttributeType || attributeType == NSDoubleAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = @([value doubleValue]);
        }
		else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
            value = [dateFormatter dateFromString:value];
        }
		
        [self setValue:value forKey:attribute];
    }
}


@end