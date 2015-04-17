
#import "FXDmoduleStore.h"


@implementation FXDmoduleStore

- (NSArray*)productIdentifiers {
	if (_productIdentifiers == nil) {	FXDLog_OVERRIDE;
	}
	return _productIdentifiers;
}

#pragma mark -
- (void)prepareStoreManager {	FXDLog_DEFAULT;
	//TODO: For listing In-App Purchasable items Combine with BundleIdentifier
	NSSet *identifierSet = [NSSet setWithArray:self.productIdentifiers];

	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifierSet];
	[request setDelegate:self];
	[request start];


	NSDictionary *receiptDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultObjVerifiedReceipt];
	FXDLogObject(receiptDictionary);

#if	ForDEVELOPER
	if (receiptDictionary
		&& receiptDictionary[@"original_purchase_date_ms"]) {

		NSTimeInterval originalPurchaseAbsoluteSeconds = [receiptDictionary[@"original_purchase_date_ms"] doubleValue]/doubleOneThousand;
		NSTimeInterval currentAbsoluteSeconds = [[NSDate date] timeIntervalSince1970];

		NSTimeInterval secondsPassedSinceLastPurchase = currentAbsoluteSeconds -originalPurchaseAbsoluteSeconds;
		FXDLog(@"%@ = %f - %f", _Variable(secondsPassedSinceLastPurchase), currentAbsoluteSeconds, originalPurchaseAbsoluteSeconds);
		Float64 daysPassed = secondsPassedSinceLastPurchase/doubleSecondsInDay;
		FXDLog(@"%@, %@", _Variable(daysPassed), _Variable((NSInteger)daysPassed));

		//TODO: Use this passed seconds to decide advertising or other feature activity
	}
#endif

	if (receiptDictionary) {
		return;
	}


	[self
	 verifyAppStoreReceiptWithValidationURL:validationURLSandbox
	 withFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 FXDLog_BLOCK(self, caller);
		 FXDLog(@"1. SANDBOX %@", _BOOL(didFinish));

		 if (didFinish) {
			 return;
		 }


		 [self
		  verifyAppStoreReceiptWithValidationURL:validationURLProduction
		  withFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
			  FXDLog_BLOCK(self, caller);
			  FXDLog(@"2. PRODUCTION %@", _BOOL(finished));
		  }];
	 }];
}

#pragma mark -
- (void)verifyAppStoreReceiptWithValidationURL:(NSURL*)validationURL withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];

	[self verifyReceiptURL:receiptURL
		 withValidationURL:validationURL
			  withCallback:finishCallback];
}

- (void)verifyReceiptURL:(NSURL*)receiptURL withValidationURL:(NSURL*)validationURL withCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	FXDLogObject(receiptURL);
	FXDLogObject(validationURL);

	
	NSError *error = nil;
	NSData *receiptData = [[NSData alloc] initWithContentsOfURL:receiptURL options:NSDataReadingUncached error:&error];FXDLog_ERROR;
	FXDLog(@"1.%@ %@", _BOOL(receiptData != nil), _Variable(receiptData.length));

	if (receiptData == nil) {
		error = nil;
		receiptData = [[NSData alloc] initWithContentsOfFile:receiptURL.path options:NSDataReadingUncached error:&error];FXDLog_ERROR;
		FXDLog(@"2.%@ %@", _BOOL(receiptData != nil), _Variable(receiptData.length));
	}


	error = nil;
	BOOL isReachable = [receiptURL checkResourceIsReachableAndReturnError:&error];FXDLog_ERROR;
	FXDLogBOOL(isReachable);

	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path];
	FXDLogBOOL(fileExists);

	if (receiptData.length == 0 && fileExists == NO && isReachable == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	NSString *base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
	FXDLog(@"2.%@", _Variable(base64String.length));

	NSDictionary *jsonObj = @{@"receipt-data": base64String};

	error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
	FXDLog_ERROR;
	FXDLog(@"1.%@", _Variable(jsonData.length));


	NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:validationURL];
	[validationRequest setHTTPMethod:@"POST"];
	[validationRequest setHTTPBody:jsonData];


	NSOperationQueue *validationQueue = [NSOperationQueue newSerialQueue];

	[NSURLConnection
	 sendAsynchronousRequest:validationRequest
	 queue:validationQueue
	 completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		 FXDLog_BLOCK(NSURLConnection, @selector(sendAsynchronousRequest:queue:completionHandler:));

		 NSError *error = connectionError;
		 FXDLog_ERROR;

		 if (connectionError) {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  if (finishCallback) {
					  finishCallback(_cmd, NO, nil);
				  }
			  }];
			 return;
		 }


		 error = nil;
		 NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		 FXDLog_ERROR;

		 FXDLogObject(jsonResponse);

		 if (jsonResponse == nil) {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  if (finishCallback) {
					  finishCallback(_cmd, NO, nil);
				  }
			  }];
			 return;
		 }


		 BOOL finished = NO;

		 if ([jsonResponse[@"status"] integerValue] == 0) {
			 finished = YES;

			 NSDictionary *receiptDictionary = jsonResponse[@"receipt"];


#warning //TODO: Find the secure way to save the receipt
			 [[NSUserDefaults standardUserDefaults] setObject:receiptDictionary forKey:userdefaultObjVerifiedReceipt];
			 [[NSUserDefaults standardUserDefaults] synchronize];

			 [self logAboutReceiptDictionary:receiptDictionary];
		 }

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  if (finishCallback) {
				  finishCallback(_cmd, finished, nil);
			  }
		  }];
	 }];
}


#pragma mark -
- (void)logAboutReceiptDictionary:(NSDictionary*)receiptDictionary {	FXDLog_DEFAULT;
	/*
	 2013-12-05 21:05:46.917 PopToo[20934:60b] responseObject: {
	 environment = Production;
	 receipt =     {
***REMOVED***
	 "application_version" = "1.0.5";
***REMOVED***
	 "download_id" = 81004424696190;
	 "in_app" =         (
	 );
	 "original_application_version" = "1.0.3";
	 "original_purchase_date" = "2013-11-18 13:17:02 Etc/GMT";
	 "original_purchase_date_ms" = 1384780622000;
	 "original_purchase_date_pst" = "2013-11-18 05:17:02 America/Los_Angeles";
	 "receipt_type" = Production;
	 "request_date" = "2013-12-05 12:05:46 Etc/GMT";
	 "request_date_ms" = 1386245146102;
	 "request_date_pst" = "2013-12-05 04:05:46 America/Los_Angeles";
	 };
	 status = 0;
	 }
	 */
#if USE_Flurry
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];

	NSArray *receiptKeyArray = @[@"original_application_version",
								 @"original_purchase_date"];

	for (NSString *receiptKey in receiptKeyArray) {

		if (receiptDictionary[receiptKey]) {
			parameters[receiptKey] = receiptDictionary[receiptKey];
		}
	}

	if ([parameters count] > 0) {
		FXDLogObject(parameters);
		LOGEVENT_FULL(@"Receipt", parameters, NO);
	}
#endif
}


#pragma mark - Delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {	FXDLog_DEFAULT;

#if ForDEVELOPER
	FXDLogObject(response.products);

	for (SKProduct *product in response.products) {
		FXDLogObject([product description]);
	}

	FXDLogObject(response.invalidProductIdentifiers);
#endif
}

- (void)requestDidFinish:(SKRequest *)request {	FXDLog_DEFAULT;

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog_ERROR;

	[request cancel];
}

@end
