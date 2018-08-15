
#import "FXDimportEssential.h"


@interface NSOperationQueue (Essential)
+ (instancetype)newSerialQueue;
+ (instancetype)newSerialQueueWithName:(NSString*)queueName;

- (void)resetOperationQueueAndDictionary:(NSMutableDictionary*)operationDictionary;

- (BOOL)shouldEnqueueOperationForKey:(NSString*)operationKey withDictionary:(nullable NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers;

- (void)enqueueOperation:(NSOperation*)operation forKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;
- (void)removeOperationForKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;
- (BOOL)cancelOperationForKey:(NSString*)operationKey withDictionary:(NSMutableDictionary*)operationDictionary;

@end
