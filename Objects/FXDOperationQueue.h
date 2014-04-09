//
//  FXDOperationQueue.h
//
//
//  Created by petershine on 4/8/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDOperationQueue : NSOperationQueue

@property (strong, nonatomic) NSMutableDictionary *operationDictionary;


#pragma mark - Public
- (void)resetOperationQueue;

- (BOOL)shouldEnqueForOperationKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers;
- (BOOL)cancelForOperationKey:(id)operationKey;

- (void)enqueOperation:(NSOperation*)operation withOperationKey:(id)operationKey;
- (void)removeOperation:(NSOperation*)operation withOperationKey:(id)operationKey;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
