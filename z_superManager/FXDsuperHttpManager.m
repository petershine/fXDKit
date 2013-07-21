//
//  FXDsuperHttpManager.m
//
//
//  Created by petershine on 10/27/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDsuperHttpManager.h"


#pragma mark - Public implemenatation
@implementation FXDsuperHttpManager

#pragma mark Static objects
static FXDsuperHttpManager *observerForReachability = nil;

static Reachability *reachabilityForWifi = nil;
static Reachability *reachabilityForInternet = nil;

static NSMutableSet *_staticHttpControlSet = nil;


#pragma mark - Memory managment

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
+ (void)prepareConnectionReachabilities {	FXDLog_DEFAULT;	
	if (reachabilityForWifi) {
		reachabilityForWifi = nil;
	}
	
	if (reachabilityForInternet) {
		reachabilityForInternet = nil;
	}
	
	if (observerForReachability) {
		observerForReachability = nil;
	}
	
	reachabilityForWifi = [Reachability reachabilityForLocalWiFi];
	
	reachabilityForInternet = [Reachability reachabilityForInternetConnection];
	
	observerForReachability = [[FXDsuperHttpManager alloc] init];
	
	[reachabilityForWifi startNotifier];
	[reachabilityForInternet startNotifier];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:observerForReachability selector:@selector(observedReachabilityChanged:) name:kReachabilityChangedNotification object:reachabilityForWifi];
	[[NSNotificationCenter defaultCenter] addObserver:observerForReachability selector:@selector(observedReachabilityChanged:) name:kReachabilityChangedNotification object:reachabilityForInternet];
}

+ (void)deallocateConnectionReachabilities {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:observerForReachability];
	
	observerForReachability = nil;
	
	[reachabilityForWifi stopNotifier];
	[reachabilityForInternet stopNotifier];
	
	reachabilityForWifi = nil;
	
	reachabilityForInternet = nil;
}

+ (BOOL)isWiFiConnected {
	BOOL isConnected = NO;
	
	NetworkStatus reachabilityStatus = [reachabilityForWifi currentReachabilityStatus];
	
	if (reachabilityStatus == ReachableViaWiFi) {
		if (![reachabilityForWifi connectionRequired]) {
			isConnected = YES;
		}
	}
	
	return isConnected;
}

+ (NSMutableSet*)httpControlSet {
	return _staticHttpControlSet;
}

+ (FXDsuperHttpManager*)popAndRemoveAnyHttpControlFromSet {	FXDLog_DEFAULT;
	FXDsuperHttpManager *httpControl = nil;
	
	if (_staticHttpControlSet) {
		FXDsuperHttpManager *anyHttpControl = [_staticHttpControlSet anyObject];
		
		if (anyHttpControl) {
			httpControl = anyHttpControl;
				// To avoid early deallocation
			
			[_staticHttpControlSet removeObject:anyHttpControl];			
		}
	}
	
	return httpControl;
}

+ (void)addHttpControl:(FXDsuperHttpManager*)httpControl toHttpControlSet:(NSMutableSet*)httpControlSet {
	if (!httpControlSet) {
		if (!_staticHttpControlSet) {
			_staticHttpControlSet = [[NSMutableSet alloc] initWithCapacity:0];
		}
		
		httpControlSet = _staticHttpControlSet;
	}
	
	[httpControlSet addObject:httpControl];
}

- (void)observedReachabilityChanged:(NSNotification*)notification {
	Reachability *changedReachability = [notification object];
	
	if ([changedReachability isEqual:reachabilityForInternet]) {	FXDLog_DEFAULT;
		NetworkStatus reachabilityStatus = [changedReachability currentReachabilityStatus];
		
		if (reachabilityStatus == NotReachable) {
			//TODO: alert user: @"Please make sure Internet is available for your device"
		}
	}
}

- (void)startHttpConnectionWithURLstring:(NSString*)urlString {	FXDLog_DEFAULT;
	[self startHttpConnectionWithURLstring:urlString withPostBody:nil withHttpHeaders:nil];
}

- (void)startHttpConnectionWithURLstring:(NSString*)urlString withPostBody:(id)postBody withHttpHeaders:(NSDictionary*)httpHeaders {	FXDLog_DEFAULT;
	
	self.httpURL = [NSURL URLWithString:urlString];
	self.httpRequest = [NSMutableURLRequest requestWithURL:self.httpURL];
	
	//TODO: implement to use postBody and httpHeaders"
	
	self.httpConnection = [NSURLConnection connectionWithRequest:self.httpRequest delegate:self];
}

//MARK: - Delegate implementation
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog(@"connection: %@", connection);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	FXDLog_ERROR;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
#if ForDEVELOPER
	NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
	FXDLog(@"httpResponse: (%d) %@", statusCode, statusCodeDescription);
	
	//FXDLog(@"\nallHeaderFields:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
#endif
	
	self.httpContentLength = [[(NSHTTPURLResponse*)response allHeaderFields][@"Content-Length"] integerValue];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	if (!_receivedData) {
		_receivedData = [[NSMutableData alloc] initWithLength:0];
	}
	
	if (self.receivedData) {
		[self.receivedData appendData:data];
		
		//FXDLog(@"self.receivedData.length: %d", self.receivedData.length);
		//FXDLog(@"percentReceived: %f %%", ((CGFloat)self.receivedData.length/(CGFloat)self.httpContentLength)*100.0);
	}
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {	FXDLog_DEFAULT;
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {	FXDLog_DEFAULT;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	FXDLog(@"connection: %@", connection);
	FXDLog(@"receivedData.length: %d", self.receivedData.length);
}


@end
