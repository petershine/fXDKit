
#import "FXDimportEssential.h"


@interface FXDmoduleNetworking : NSObject

@property (strong, nonatomic, readonly, nonnull) NSString *mainRootURLformat;
@property (strong, nonatomic, readonly, nonnull) NSString *mainAPIkey;
@property (strong, nonatomic, readonly, nonnull) NSString *mainJSONrootKey;


- (void)collectingRequestWithQueryText:(nullable NSString*)queryText withDidCollectBlock:(void(^_Nullable)(NSMutableArray* _Nullable collectedItemArray))didCollectBlock;
- (nullable NSURLRequest*)requestWithQueryText:(nullable NSString*)queryText;
- (nullable NSMutableArray*)collectedItemArrayFromJSONobj:(nullable id)jsonObj;
- (nullable id)simplerItemFromItem:(nullable id)item;

@end
