

#import "FXDOperationQueue.h"


@implementation NSOperationQueue (Essential)
+ (instancetype _Nullable)newSerialQueue {
	return [self newSerialQueueWithName:nil];
}

+ (instancetype _Nullable)newSerialQueueWithName:(NSString*_Nullable)queueName {
	NSOperationQueue *serialQueue = [[[self class] alloc] init];
	serialQueue.maxConcurrentOperationCount = 1;

	if (queueName) {
		serialQueue.name = queueName;
	}

	return serialQueue;
}

#pragma mark -
- (void)resetOperationQueueAndDictionary:(NSMutableDictionary*_Nullable)operationDictionary {
	[self cancelAllOperations];

	[operationDictionary removeAllObjects];
}

#pragma mark -
- (BOOL)shouldEnqueueOperationForKey:(NSString*_Nullable)operationKey withDictionary:(nullable NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers {

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
- (void)enqueueOperation:(NSOperation*_Nullable)operation forKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary {
	operationDictionary[operationKey] = operation;
	[self addOperation:operation];
}

- (void)removeOperationForKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary {
	[self cancelOperationForKey:operationKey withDictionary:operationDictionary];

	[operationDictionary removeObjectForKey:operationKey];
}

- (void)cancelOperationForKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary {
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
