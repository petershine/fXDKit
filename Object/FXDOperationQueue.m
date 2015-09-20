

#import "FXDOperationQueue.h"


@implementation NSOperationQueue (Essential)
+ (instancetype)newSerialQueue {
	return [self newSerialQueueWithName:nil];
}

+ (instancetype)newSerialQueueWithName:(NSString*)queueName {
	NSOperationQueue *serialQueue = [[[self class] alloc] init];
	serialQueue.maxConcurrentOperationCount = 1;

	if (queueName) {
		serialQueue.name = queueName;
	}

	return serialQueue;
}

#pragma mark -
- (void)resetOperationQueueAndDictionary:(NSMutableDictionary*)operationDictionary {
	[self cancelAllOperations];

	[operationDictionary removeAllObjects];
}

#pragma mark -
- (BOOL)shouldEnqueOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers {

	BOOL shouldEnque = YES;

	NSBlockOperation *enqueuedOperation = operationDictionary[operationKey];

	if (enqueuedOperation && enqueuedOperation.isCancelled == NO) {
		shouldEnque = NO;
	}

	if (shouldCancelOthers ==  NO) {
		return shouldEnque;
	}


	NSMutableArray *removedKeyArray = [[NSMutableArray alloc] initWithCapacity:0];

	for (NSString *key in [operationDictionary allKeys]) {
		if ([operationKey isEqualToString:key]) {
			continue;
		}


		BOOL isCancelled = [self cancelOperationForKey:key withDictionary:operationDictionary];
		if (isCancelled) {}
		FXDLog(@"%@ %@", _Object(key), _BOOL(isCancelled));

		[removedKeyArray addObject:key];
	}

	[operationDictionary removeObjectsForKeys:removedKeyArray];

	return shouldEnque;
}

#pragma mark -
- (void)enqueOperation:(NSOperation*)operation forKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	[operationDictionary setObject:operation forKey:operationKey];
	[self addOperation:operation];
}

- (BOOL)removeOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	//TEST: May not have to cancel when removing is decided
	//BOOL didRemove = [self cancelOperationForKey:operationKey withDictionary:operationDictionary];
	BOOL didRemove = YES;
	
	[operationDictionary removeObjectForKey:operationKey];

	return didRemove;
}

- (BOOL)cancelOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	if (operationKey == nil) {
		return NO;
	}

	
	NSOperation *operation = operationDictionary[operationKey];
	[operation cancel];

	return operation.isCancelled;
}

@end
