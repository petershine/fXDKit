#if USE_AFNetworking


#import "FXDmoduleNetworking.h"

@implementation FXDmoduleNetworking

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSString*)mainRootURLformat {
	if (_mainRootURLformat == nil) {	FXDLog_OVERRIDE;
	}
	return _mainRootURLformat;
}

- (NSString*)mainAPIkey {
	if (_mainAPIkey == nil) {	FXDLog_OVERRIDE;
	}
	return _mainAPIkey;
}

- (NSString*)mainJSONrootKey {
	if (_mainJSONrootKey == nil) {	FXDLog_OVERRIDE;
	}
	return _mainJSONrootKey;
}

#pragma mark - Public
- (void)collectingRequestWithQueryText:(NSString*)queryText withDidCollectBlock:(void(^)(NSMutableArray* collectedItemArray))didCollectBlock {

	NSURLRequest *searchRequest = [self requestWithQueryText:queryText];

	if (searchRequest == nil) {
		if (didCollectBlock) {
			didCollectBlock(nil);
		}
		return;
	}


	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:searchRequest];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];

	[operation
	 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSMutableArray *collectedItemArray = [self collectedItemArrayFromJSONobj:responseObject];

		 if (didCollectBlock) {
			 didCollectBlock(collectedItemArray);
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 FXDLog_ERROR;

		 if (didCollectBlock) {
			 didCollectBlock(nil);
		 }
	 }];

	[operation start];
}

- (NSURLRequest*)requestWithQueryText:(NSString*)queryText {
	if (self.mainRootURLformat == nil || self.mainAPIkey == nil) {
		return nil;
	}


	NSString *percentEscaped = [queryText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSURL *requestURL = [NSURL evaluatedURLforPath:[NSString stringWithFormat:self.mainRootURLformat, percentEscaped, self.mainAPIkey]];

	NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];

	return request;
}

- (NSMutableArray*)collectedItemArrayFromJSONobj:(id)jsonObj {
	FXDLogObject(self.mainJSONrootKey);
	FXDLogObject(jsonObj);

	NSMutableArray *collectedItemArray = [[NSMutableArray alloc] initWithCapacity:0];

	id items = jsonObj[self.mainJSONrootKey];

	for (id item in items) {
		NSDictionary *simplerItem = [self simplerItemFromItem:item];

		if (simplerItem) {
			[collectedItemArray addObject:simplerItem];
		}
	}

	//NOTE: Never be nil
	FXDLogObject(collectedItemArray);

	return collectedItemArray;
}

- (id)simplerItemFromItem:(id)item {	FXDLog_OVERRIDE;
	FXDLogObject(item);
	
	return item;
}

#pragma mark -
- (void)startRequestOperationWithMethod:(NSString*)method withURLString:(NSString*)urlString withParameters:(NSDictionary*)parameters forContentTypes:(NSArray*)contentTypes withSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock withFailureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {	FXDLog_DEFAULT;

	FXDLogObject(method);
	FXDLogObject(urlString);
	FXDLogObject(parameters);
	FXDLogObject(contentTypes);

	NSError *error = nil;
	NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
									requestWithMethod:method
									URLString:urlString
									parameters:parameters
									error:&error];FXDLog_ERROR;

	AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc]
												initWithRequest:request];

	requestOperation.responseSerializer = [AFCompoundResponseSerializer
										   compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer]]];

	NSMutableSet *modifiedSet = [requestOperation.responseSerializer.acceptableContentTypes mutableCopy];
	[modifiedSet addObjectsFromArray:contentTypes];
	requestOperation.responseSerializer.acceptableContentTypes = modifiedSet;


	[requestOperation
	 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		 FXDLog_BLOCK(operation, @selector(setCompletionBlockWithSuccess:failure:));

		 FXDLogVariable(operation.response.statusCode);
		 FXDLogObject(operation.response.allHeaderFields);
		 FXDLogObject(responseObject);

		 if (successBlock) {
			 successBlock(operation, responseObject);
		 }

	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 FXDLog_BLOCK(operation, @selector(setCompletionBlockWithSuccess:failure:));

		 FXDLogVariable(operation.response.statusCode);
		 FXDLogObject(operation.response.allHeaderFields);
		 FXDLog_ERROR;

		 if (failureBlock) {
			 failureBlock(operation, error);
		 }
	 }];

	[[AFHTTPRequestOperationManager manager].operationQueue
	 addOperation:requestOperation];
}
@end


#endif