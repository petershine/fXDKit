
#import "FXDimportEssential.h"


@interface NSOperationQueue (Essential)
+ (instancetype _Nullable)newSerialQueue;
+ (instancetype _Nullable)newSerialQueueWithName:(NSString*_Nullable)queueName;

- (void)resetOperationQueueAndDictionary:(NSMutableDictionary*_Nullable)operationDictionary;

- (BOOL)shouldEnqueueOperationForKey:(NSString*_Nullable)operationKey withDictionary:(nullable NSMutableDictionary*)operationDictionary shouldCancelOthers:(BOOL)shouldCancelOthers;

- (void)enqueueOperation:(NSOperation*_Nullable)operation forKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary;
- (void)removeOperationForKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary;
- (void)cancelOperationForKey:(NSString*_Nullable)operationKey withDictionary:(NSMutableDictionary*_Nullable)operationDictionary;

@end
