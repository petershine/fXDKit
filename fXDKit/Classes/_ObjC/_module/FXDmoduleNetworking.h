
#import "FXDimportEssential.h"


@interface FXDmoduleNetworking : NSObject

@property (strong, nonatomic, readonly, nonnull) NSString *mainRootURLformat;
@property (strong, nonatomic, readonly, nonnull) NSString *mainAPIkey;
@property (strong, nonatomic, readonly, nonnull) NSString *mainJSONrootKey;


- (void)collectingRequestWithQueryText:(NSString*)queryText withDidCollectBlock:(void(^)(NSMutableArray* collectedItemArray))didCollectBlock;
- (NSURLRequest*)requestWithQueryText:(NSString*)queryText;
- (NSMutableArray*)collectedItemArrayFromJSONobj:(id)jsonObj;
- (id)simplerItemFromItem:(id)item;

@end