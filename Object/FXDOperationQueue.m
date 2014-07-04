

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
	[operationDictionary removeAllObjects];
	[self cancelAllOperations];
}

#pragma mark -
- (BOOL)shouldEnqueOperationForKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers withDictionary:(NSMutableDictionary*)operationDictionary {

	BOOL shouldEnque = YES;

	if ([operationDictionary objectForKey:operationKey]) {
		shouldEnque = NO;
	}

	if (shouldCancelOthers == NO) {
		return shouldEnque;
	}


	for (NSString *key in [operationDictionary allKeys]) {
		if ([operationKey isEqualToString:key]) {
			shouldEnque = NO;
			continue;
		}


		[self cancelOperationForKey:key withDictionary:operationDictionary];
	}

	return shouldEnque;
}

#pragma mark -
- (void)enqueOperation:(NSOperation*)operation forKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	[operationDictionary setObject:operation forKey:operationKey];
	[self addOperation:operation];
}

- (void)removeOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	[self cancelOperationForKey:operationKey withDictionary:operationDictionary];
	[operationDictionary removeObjectForKey:operationKey];
}

- (BOOL)cancelOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary {
	if (operationKey == nil) {
		return NO;
	}


	NSOperation *operation = operationDictionary[operationKey];
	[operation cancel];

	return [operation isCancelled];
}

@end
