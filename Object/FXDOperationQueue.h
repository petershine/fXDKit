//
//  FXDOperationQueue.h
//
//
//  Created by petershine on 4/8/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#warning //TODO: Use weak dictionary owned by other instance, and used only if it's retained
#warning //TODO: Or... don't use dictionary. Make it clean queue


@interface FXDOperationQueue : NSOperationQueue

@property (strong, nonatomic) NSMutableDictionary *operationDictionary;

#pragma mark - Public
- (void)resetOperationQueue;

- (BOOL)shouldEnqueOperationForKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers;

- (void)enqueOperation:(NSOperation*)operation forKey:(id)operationKey;
- (void)removeOperationForKey:(id)operationKey;
- (BOOL)cancelOperationForKey:(id)operationKey;

@end


@interface NSOperationQueue (Essential)
+ (instancetype)newSerialQueue;
@end
