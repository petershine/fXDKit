

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
- (BOOL)shouldEnqueueOperationForKey:(NSString*)operationKey withDictionary:(nullable NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers {

	BOOL shouldEnque = YES;

	NSBlockOperation *enqueuedOperation = operationDictionary[operationKey];

	if (enqueuedOperation && enqueuedOperation.isCancelled == NO && enqueuedOperation.isFinished == NO) {
		shouldEnque = NO;
	}

	if (shouldCancelOthers ==  NO) {
		return shouldEnque;
	}


	NSMutableArray *otherCanceledOperationKeyArray = [[NSMutableArray alloc] initWithCapacity:0];

	for (NSString *key in operationDictionary.allKeys) {
		if ([operationKey isEqualToString:key]) {
			continue;
		}


		[self cancelOperationForKey:key withDictionary:operationDictionary];

		[otherCanceledOperationKeyArray addObject:key];
	}

	[operationDictionary removeObjectsForKeys:otherCanceledOperationKeyArray];

	return shouldEnque;
}

#pragma mark -
- (void)enqueueOperation:(NSOperation*)operation forKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	operationDictionary[operationKey] = operation;
	[self addOperation:operation];
}

- (void)removeOperationForKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	[self cancelOperationForKey:operationKey withDictionary:operationDictionary];

	[operationDictionary removeObjectForKey:operationKey];
}

- (void)cancelOperationForKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	if (operationKey == nil) {
		return;
	}

	
	NSOperation *operation = operationDictionary[operationKey];
	[operation cancel];

	/*if (operation.isFinished == NO) {
		FXDLog(@"CANCELED: %@ isCancelled: %@ isFinished: %@", operationKey, @(operation.isCancelled), @(operation.isFinished));
	}*/
}

@end
