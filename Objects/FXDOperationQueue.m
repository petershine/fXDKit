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
- (void)dealloc {	FXDLog_DEFAULT;
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
- (void)resetOperationQueue {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Variable([self operationCount]), _Variable([_operationDictionary count]));
	[_operationDictionary removeAllObjects];
	[self cancelAllOperations];
}

#pragma mark -
- (BOOL)shouldEnqueForOperationKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers {

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


		[self cancelForOperationKey:key];
	}

	return shouldEnque;
}

- (BOOL)cancelForOperationKey:(id)operationKey {
	NSOperation *operation = self.operationDictionary[operationKey];
	[operation cancel];

	return [operation isCancelled];
}

#pragma mark -
- (void)enqueOperation:(NSOperation*)operation withOperationKey:(id)operationKey {
	[self.operationDictionary setObject:operation forKey:operationKey];
	[self addOperation:operation];
}

- (void)removeOperation:(NSOperation*)operation withOperationKey:(id)operationKey {
	[self.operationDictionary removeObjectForKey:operationKey];
	[operation cancel];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
