

#import "FXDmoduleAPIclient.h"

@implementation FXDmoduleAPIclient
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

		 if (error && [error localizedDescription]) {
			 [FXDAlertView
			  showAlertWithTitle:[error localizedDescription]
			  message:nil
			  cancelButtonTitle:nil
			  withAlertCallback:nil];
		 }

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

	NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:self.mainRootURLformat, percentEscaped, self.mainAPIkey]];

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

	//MARK: Never be nil
	FXDLogObject(collectedItemArray);

	return collectedItemArray;
}

- (id)simplerItemFromItem:(id)item {	FXDLog_OVERRIDE;
	FXDLogObject(item);
	
	return item;
}

@end
