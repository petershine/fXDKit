
#import "FXDimportEssential.h"


@interface NSOperationQueue (Essential)
+ (instancetype)newSerialQueue;
+ (instancetype)newSerialQueueWithName:(NSString*)queueName;

- (void)resetOperationQueueAndDictionary:(NSMutableDictionary*)operationDictionary;

- (BOOL)shouldEnqueueOperationForKey:(id)operationKey withDictionary:(nullable NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers;

- (void)enqueueOperation:(NSOperation*)operation forKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;
- (BOOL)removeOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;
- (BOOL)cancelOperationForKey:(id)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;

@end
