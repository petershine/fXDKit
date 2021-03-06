

#import "FXDmoduleNetworking.h"

@implementation FXDmoduleNetworking

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Public
- (void)collectingRequestWithQueryText:(nullable NSString*)queryText withDidCollectBlock:(void(^_Nullable)(NSMutableArray* _Nullable collectedItemArray))didCollectBlock {

	NSURLRequest *searchRequest = [self requestWithQueryText:queryText];

	if (searchRequest == nil) {
		if (didCollectBlock) {
			didCollectBlock(nil);
		}
		return;
	}


	NSURLSessionTask *searchTask =
	[[NSURLSession sharedSession]
	 dataTaskWithRequest:searchRequest
	 completionHandler:^(NSData *data,
						 NSURLResponse *response,
						 NSError *error) {	FXDLog_BLOCK(self, _cmd);
		 FXDLogObject(response);
		 FXDLog_ERROR;

		 if (error != nil) {
			 if (didCollectBlock) {
				 [[NSOperationQueue mainQueue]
				  addOperationWithBlock:^{
					  didCollectBlock(nil);
				  }];
			 }
			 return;
		 }


		 NSError *serializationError = nil;

		 id responseJSON = [NSJSONSerialization
							JSONObjectWithData:data
							options:NSJSONReadingMutableContainers
							error:&serializationError];
		 FXDLogObject(serializationError);

		 NSMutableArray *collectedItemArray = [self collectedItemArrayFromJSONobj:responseJSON];

		 if (didCollectBlock) {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  didCollectBlock(collectedItemArray);
			  }];
		 }
	 }];

	[searchTask resume];
}

- (nullable NSURLRequest*)requestWithQueryText:(nullable NSString*)queryText {
	if (self.mainRootURLformat == nil || self.mainAPIkey == nil) {
		return nil;
	}


	NSString *percentEscaped = nil;

	percentEscaped = [queryText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];


	NSURL *requestURL = [NSURL evaluatedURLforPath:[NSString stringWithFormat:self.mainRootURLformat, percentEscaped, self.mainAPIkey]];

	NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];

	return request;
}

- (nullable NSMutableArray*)collectedItemArrayFromJSONobj:(nullable id)jsonObj {
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

	//MARK: Never be nil
	FXDLogObject(collectedItemArray);

	return collectedItemArray;
}

- (nullable id)simplerItemFromItem:(nullable id)item {	FXDLog_OVERRIDE;
	FXDLogObject(item);
	
	return item;
}

@end
