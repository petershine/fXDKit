

#import "FXDsuperModule.h"
@interface FXDmoduleNetworking : FXDsuperModule {
	NSString *_mainRootURLformat;
	NSString *_mainAPIkey;
	NSString *_mainJSONrootKey;
}

@property (strong, nonatomic) NSString *mainRootURLformat;
@property (strong, nonatomic) NSString *mainAPIkey;
@property (strong, nonatomic) NSString *mainJSONrootKey;


- (void)collectingRequestWithQueryText:(NSString*)queryText withDidCollectBlock:(void(^)(NSMutableArray* collectedItemArray))didCollectBlock;
- (NSURLRequest*)requestWithQueryText:(NSString*)queryText;
- (NSMutableArray*)collectedItemArrayFromJSONobj:(id)jsonObj;
- (id)simplerItemFromItem:(id)item;

@end