
#import "FXDKit.h"


#warning //TODO: Use weak dictionary owned by other instance, and used only if it's retained
#warning //TODO: Or... don't use dictionary. Make it clean queue


@interface FXDOperationQueue : NSOperationQueue

@property (strong, nonatomic) NSMutableDictionary *operationDictionary;


- (void)resetOperationQueue;

- (BOOL)shouldEnqueOperationForKey:(id)operationKey shouldCancelOthers:(BOOL)shouldCancelOthers;

- (void)enqueOperation:(NSOperation*)operation forKey:(id)operationKey;
- (void)removeOperationForKey:(id)operationKey;
- (BOOL)cancelOperationForKey:(id)operationKey;

@end


@interface NSOperationQueue (Essential)
+ (instancetype)newSerialQueue;
@end
