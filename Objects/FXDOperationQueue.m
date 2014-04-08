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
	FXDLog(@"%@ %@", _Variable([self operationCount]), _Variable([_operationDictionary count]));

	[_operationDictionary removeAllObjects];
	[self cancelAllOperations];
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


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
