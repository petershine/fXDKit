//
//  FXDOperationQueue.m
//
//
//  Created by petershine on 4/8/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDOperationQueue.h"


#pragma mark - Public implementation
@implementation FXDOperationQueue


#pragma mark - Memory management
- (void)dealloc {	//FXDLog_DEFAULT;
	[self resetOperationQueue];
}


#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMutableDictionary*)operationDictionary {
	if (_operationDictionary == nil) {
		_operationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}

	return _operationDictionary;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)resetOperationQueue {
	[_operationDictionary removeAllObjects];
	[self cancelAllOperations];
}

#pragma mark -
- (BOOL)shouldEnqueOperationForKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers {

	BOOL shouldEnque = YES;

	if ([self.operationDictionary objectForKey:operationKey]) {
		shouldEnque = NO;
	}

	if (shouldCancelOthers == NO) {
		return shouldEnque;
	}


	for (NSString *key in [self.operationDictionary allKeys]) {
		if ([operationKey isEqualToString:key]) {
			shouldEnque = NO;
			continue;
		}


		[self cancelOperationForKey:key];
	}

	return shouldEnque;
}

#pragma mark -
- (void)enqueOperation:(NSOperation*)operation forKey:(id)operationKey {
	[self.operationDictionary setObject:operation forKey:operationKey];
	[self addOperation:operation];
}

- (void)removeOperationForKey:(id)operationKey {
	[self cancelOperationForKey:operationKey];
	[self.operationDictionary removeObjectForKey:operationKey];
}

- (BOOL)cancelOperationForKey:(id)operationKey {
	NSOperation *operation = self.operationDictionary[operationKey];
	[operation cancel];

	return [operation isCancelled];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
