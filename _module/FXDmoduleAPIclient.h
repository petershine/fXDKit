
#import "FXDKit.h"


#import <AFNetworking.h>
#import <UIKit+AFNetworking.h>


@interface FXDmoduleAPIclient : FXDsuperModule {
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

- (void)generalRequestWithMethod:(NSString*)method withURLString:(NSString*)urlString withParameters:(NSDictionary*)parameters forContentTypes:(NSArray*)contentTypes withSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock withFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
