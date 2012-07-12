//
//  FXDsuperHTTPControl.m
//
//
//  Created by petershine on 10/27/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDsuperHTTPControl.h"


#pragma mark - Private interface
@interface FXDsuperHTTPControl (Private)
@end


#pragma mark - Public implemenatation
@implementation FXDsuperHTTPControl

#pragma mark Static objects
static FXDsuperHTTPControl *observerForReachability = nil;

static Reachability *reachabilityForWifi = nil;
static Reachability *reachabilityForInternet = nil;

static NSMutableSet *_staticHttpControlSet = nil;


#pragma mark Synthesizing
// Properties
@synthesize httpContentLength = _httpContentLength;
@synthesize receivedDataLength = _receivedDataLength;

@synthesize httpURL = _httpURL;
@synthesize httpRequest = _httpRequest;
@synthesize httpConnection = _httpConnection;

@synthesize receivedData = _receivedData;

@synthesize nextHttpControl = _nextHttpControl;


#pragma mark - Memory managment


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {		
		// Primitives
		
		// Instance variables
		
		// Properties
		_httpContentLength = 0;
		_receivedDataLength = 0;
		
		_httpURL = nil;
		_httpRequest = nil;
		_httpConnection = nil;
		
		_receivedData = nil;
		
		_nextHttpControl = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


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
	
	observerForReachability = [[FXDsuperHTTPControl alloc] init];
	
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

#pragma mark -
+ (BOOL)isWiFiConnected {
	BOOL isConnected = NO;
	
	NetworkStatus reachabilityStatus = [reachabilityForWifi currentReachabilityStatus];
	
	if (reachabilityStatus == ReachableViaWiFi) {
		if ([reachabilityForWifi connectionRequired] == NO) {
			isConnected = YES;
		}
	}
	
	return isConnected;
}

#pragma mark -
+ (NSMutableSet*)httpControlSet {
	return _staticHttpControlSet;
}

+ (FXDsuperHTTPControl*)popAndRemoveAnyHttpControlFromSet {	FXDLog_DEFAULT;
	FXDsuperHTTPControl *httpControl = nil;
	
	if (_staticHttpControlSet) {
		FXDsuperHTTPControl *anyHttpControl = [_staticHttpControlSet anyObject];
		
		if (anyHttpControl) {
			httpControl = anyHttpControl;
				// To avoid early deallocation
			
			[_staticHttpControlSet removeObject:anyHttpControl];			
		}
	}
	
	return httpControl;
}

+ (void)addHttpControl:(FXDsuperHTTPControl*)httpControl toHttpControlSet:(NSMutableSet*)httpControlSet {
	if (httpControlSet == nil) {
		if (_staticHttpControlSet == nil) {
			_staticHttpControlSet = [[NSMutableSet alloc] initWithCapacity:0];
		}
		
		httpControlSet = _staticHttpControlSet;
	}
	
	[httpControlSet addObject:httpControl];
}

#pragma mark -
- (void)observedReachabilityChanged:(NSNotification*)notification {
	Reachability *changedReachability = [notification object];
	
	if ([changedReachability isEqual:reachabilityForInternet]) {	FXDLog_DEFAULT;
		NetworkStatus reachabilityStatus = [changedReachability currentReachabilityStatus];
		
		if (reachabilityStatus == NotReachable) {
			/*
			UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:nil
															   message:@"Please make sure Internet is available for your device"
															  delegate:nil
													 cancelButtonTitle:nil
													 otherButtonTitles:text_OK, nil];
			[alerview show];
			[alerview release];
			 */
		}
	}
}

#pragma mark -
- (void)startHttpConnectionWithURLstring:(NSString*)urlString {	FXDLog_DEFAULT;
	[self startHttpConnectionWithURLstring:urlString withPostBody:nil withHttpHeaders:nil];
}

- (void)startHttpConnectionWithURLstring:(NSString*)urlString withPostBody:(id)postBody withHttpHeaders:(NSDictionary*)httpHeaders {	FXDLog_DEFAULT;
	
	self.httpURL = [NSURL URLWithString:urlString];
	self.httpRequest = [NSMutableURLRequest requestWithURL:self.httpURL];
	
	//TODO: implement to use postBody and httpHeaders
	
	self.httpConnection = [NSURLConnection connectionWithRequest:self.httpRequest delegate:self];
}

//MARK: - Delegate implementation
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	FXDLog_DEFAULT;
	FXDLog(@"connection: %@", connection);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if (error) {
		FXDLog_ERROR;
	}
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSString *statusCodeDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
	FXDLog(@"httpResponse: (%d) %@", statusCode, statusCodeDescription);
	
	//FXDLog(@"\nallHeaderFields:\n%@", [(NSHTTPURLResponse*)response allHeaderFields]);
	
	self.httpContentLength = [[[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Content-Length"] integerValue];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	if (self.receivedData == nil) {
		self.receivedData = [[NSMutableData alloc] initWithLength:0];
	}
	
	if (self.receivedData) {
		[self.receivedData appendData:data];
		
		//FXDLog(@"self.receivedData.length: %d", self.receivedData.length);
		//FXDLog(@"percentReceived: %f %%", ((float)self.receivedData.length/(float)self.httpContentLength)*100.0);
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
